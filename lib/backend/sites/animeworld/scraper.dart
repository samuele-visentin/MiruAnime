import 'dart:io';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:miru_anime/backend/globals/video_parser/doodstream_parser.dart';
import 'package:miru_anime/backend/globals/video_parser/streamlare_parser.dart';
import 'package:miru_anime/backend/globals/video_parser/streamtape_parser.dart';
import 'package:miru_anime/backend/globals/video_parser/userload_parser.dart';
import 'package:miru_anime/backend/globals/video_parser/vup_parser.dart';
import 'package:miru_anime/backend/globals/video_parser/vvvvid.dart';
import 'package:miru_anime/backend/models/anime.dart';
import 'package:miru_anime/backend/models/comment.dart';
import 'package:miru_anime/backend/models/home_page.dart';
import 'package:miru_anime/backend/models/news.dart';
import 'package:miru_anime/backend/models/server.dart';
import 'package:miru_anime/backend/models/specific_page.dart';
import 'package:miru_anime/backend/models/upcoming_anime.dart';
import 'package:miru_anime/backend/sites/animeworld/anime_section.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/globals/video_url.dart';
import 'package:miru_anime/backend/globals/server_types.dart';

const userAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0';

class AnimeWorldScraper {
  final _dio = Dio();
  static final _customHeaders = {HttpHeaders.userAgentHeader: userAgent};
  static bool _saveCookie = true;

  /*String _getAwCookiw(final String script) {
    final values = <String>[];

    String atob(final String string) {
      final stringToBase64 = utf8.fuse(base64);
      return stringToBase64.decode(string);
    }

    List<int> toNumbers(final String codes) {
      final nums = <int>[];
      codes.replaceAllMapped(RegExp('(..)'), (final match) {
        nums.add(int.parse(match.group(1)!, radix: 16));
        return '';
      });
      return nums;
    }

    String toHex(List<int> bytes) {
      var charCode = '0'; //FIXME is '0' or ''
      for (final byte in bytes) {
        charCode += (16 > byte ? '0' : '') + byte.toRadixString(16);
      }
      return charCode.toLowerCase();
    }

    String hexToString(final String string) {
      final regex = RegExp('/x([0-9]*)');
      return String.fromCharCodes(
          regex.allMatches(string).map((e) => int.parse(e.group(1)!)));
    }

    for (final string in script.split('[')[1].split('];')[0].split(',')) {
      values.add(string.replaceAll('"', ''));
    }
    //TODO: check if this work with the new token type
    final b1 = toNumbers(atob('YjM2MTQxYjhkNGEzMDg1Y2ZhNDFiZDhkMjYzZjkxMTg='));
    final c1 = script.split('c1=atob("')[1].split('"')[0];
    final c2 = toNumbers(atob(c1));
    final a3 = toNumbers(script.split('a3=toNumbers("')[1].split('"')[0]);
    final encrypter = Encrypter(AES(
        Key(Uint8List.fromList(b1)),
        mode: AESMode.cbc
    ));
    final encrypted = toHex(encrypter.decryptBytes(
        Encrypted(Uint8List.fromList(a3)), iv: IV(Uint8List.fromList(c2))));
    return 'SecurityAW=$encrypted';
  }*/

  Future<AnimeWorldHomePage> getHomePage() async {
    Response<String> response = await _dio.get(
        AnimeWorldEndPoints.sitePrefixNoS,
        options: Options(headers: _customHeaders));
    if (response.data!.length < 1500) {
      //Sometimes the site returns one dummy page with some javascript to redirect the page with new cookied
      final regex =  RegExp(r'document\.cookie="[^=]+=([^;"]+);');
      final match = regex.firstMatch(response.data!);
      if (match != null) {
        _customHeaders['cookie'] = 'SecurityAW=${match.group(1)!} ; '; //FIXME: check if works
        //print(match.group(1));
      }
      final uri = Uri.parse(response.data!.split('location.href="')[1].split('"')[0]);
      final url = uri.replace(scheme: 'https');
      //print(url);
      response = await _dio.getUri(url, options: Options(headers: _customHeaders));
      if (response.headers['set-cookie'] != null) {
        _customHeaders['cookie'] = (_customHeaders['cookie'] ?? '') + response.headers['set-cookie']!
                .map((final cookie) => cookie.split(';')[0])
                .join('; ');
        _saveCookie = false;
      }
    } else if (_saveCookie && response.headers['set-cookie'] != null) {
      _customHeaders['cookie'] = response.headers['set-cookie']!
          .map((final cookie) => cookie.split(';')[0])
          .join('; ');
      _saveCookie = false;
    }
    final page = parse(response.data);
    final mainContent = page
        .querySelectorAll('.hotnew > div.widget-body > div.content')
        .map((final tab) {
      final setName = <String>{};
      final listAnime = <Anime>[];
      for (final anime in tab.querySelectorAll('.item > .inner')) {
        final name = anime.querySelector('a.name')!;
        if (setName.contains(name.text)) continue;
        setName.add(name.text);
        listAnime.add(Anime(
          thumbnail: anime.querySelector('img')!.attributes['src']!,
          title: name.text.trim(),
          link: AnimeWorldEndPoints.sitePrefixNoS + name.attributes['href']!,
        ));
      }
      return listAnime;
    }).toList(growable: false);
    final topAnime = page
        .querySelectorAll('.ranking > div.widget-body > div.content')
        .map((final topSection) {
      final list = <Anime>[];
      final firstAnime = topSection.querySelector('div.item-top')!;
      list.add(Anime(
          thumbnail:
              firstAnime.querySelector('a.thumb > img')!.attributes['src']!,
          link: AnimeWorldEndPoints.sitePrefixNoS +
              firstAnime.querySelector('a.name')!.attributes['href']!,
          title: firstAnime.querySelector('a.name')!.text.trim(),
          rank: firstAnime.querySelector('i.rank')!.text.trim()));
      list.addAll(topSection.querySelectorAll('div.item').map((final element) =>
          Anime(
              thumbnail: element.querySelector('img')!.attributes['src']!,
              title: element.querySelector('div.info > a.name')!.text.trim(),
              link: AnimeWorldEndPoints.sitePrefixNoS +
                  element
                      .querySelector('div.info > a.name')!
                      .attributes['href']!,
              rank: element.querySelector('i.rank')!.text)));
      return list;
    }).toList(growable: false);
    final RegExp regex = RegExp(
        r'(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])',
        caseSensitive: false,
        multiLine: true);
    final sliders = page
        .querySelectorAll(
            '#swiper-container > div.items.swiper-wrapper > div.item.swiper-slide')
        .map((final element) => Anime(
            title: element.querySelector('a.name')!.text.trim(),
            link: AnimeWorldEndPoints.sitePrefixNoS +
                element.querySelector('a.name')!.attributes['href']!,
            thumbnail: regex.stringMatch(element.attributes['style']!)!))
        .toList(growable: false);
    final ongoing = <Anime>[];
    for (final anime in page
        .querySelectorAll('#main > div.content > div.widget')[3]
        .querySelectorAll(
            'div.widget-body > div.film-list > div.owl-carousel > div.item')) {
      final name = anime.querySelector('a.name')!;
      ongoing.add(Anime(
        thumbnail: anime.querySelector('img')!.attributes['src']!,
        title: name.text.trim(),
        link: name.attributes['href']!,
      ));
    }
    final newAdded = page
        .querySelectorAll('.simple-film-list > div.widget-body > div.item')
        .map(getAnime)
        .toList(growable: false);
    final upcoming = page
        .querySelectorAll('div.widget-body > div.film-list')[1]
        .querySelectorAll('.inner')
        .map((final e) => Anime(
            thumbnail: e.querySelector('img')!.attributes['src']!,
            link: e.querySelector('a.name')!.attributes['href']!,
            title: e.querySelector('a.name')!.text.trim()))
        .toList(growable: false);
    return AnimeWorldHomePage(
        topAnime: topAnime,
        all: mainContent[0],
        sliders: sliders,
        subITA: mainContent[1],
        dubbed: mainContent[2],
        trending: mainContent[3],
        ongoing: ongoing,
        newAdded: newAdded,
        upcoming: upcoming,
        upcomingTitle: page
            .querySelectorAll('div.widget')[5]
            .querySelector('div.widget-title > div.title')!
            .text
            .trim());
  }

  Anime getAnime(final Element div) {
    final name = div.querySelector('a.name')!;
    return Anime(
        thumbnail: div.querySelector('img')!.attributes['src']!,
        title: name.text.trim(),
        link: AnimeWorldEndPoints.sitePrefixNoS +
            name.attributes['href']!);
  }

  Future<List<Anime>> getSearchList(final String title) async {
    final document = parse((await _dio.get(
            AnimeWorldEndPoints.searchPageUrl + title,
            options: Options(headers: _customHeaders)))
        .data);
    return document
        .querySelectorAll('div.film-list > div.item')
        .map(getAnime)
        .toList(growable: false);
  }

  Future<String> getRandomAnime() async {
    return (await _dio.get(AnimeWorldEndPoints.random,
            options: Options(headers: _customHeaders)))
        .redirects
        .first
        .location
        .replace(scheme: 'https')
        .toString();
  }

  Future<AnimeWorldSpecificAnime> getSpecificAnimePage(final String url) async {
    AnimeState getState(final String info) {
      switch (info) {
        case 'Non rilasciato':
          return AnimeState.toBeRelease;
        case 'Finito':
          return AnimeState.finish;
        case 'In corso':
          return AnimeState.ongoing;
        default:
          return AnimeState.undefined;
      }
    }

    ServerName getName(final String id) {
      switch (id) {
        case '9':
          return ServerName.animeworld;
        case '3':
          return ServerName.vvvvid;
        case '8':
          return ServerName.streamtape;
        case '6':
          return ServerName.server2;
        case '2':
          return ServerName.doodStream;
        case '17':
          return ServerName.userload;
        case '4':
          return ServerName.youtube;
        case '18':
          return ServerName.vup;
        case '25':
          return ServerName.streamlare;
        default:
          return ServerName.none;
      }
    }

    final head = {
      HttpHeaders.userAgentHeader: userAgent,
      HttpHeaders.refererHeader: 'https://www.animeworld.tv/',
      HttpHeaders.upgradeHeader: '?1',
      'DNT': '1',
      HttpHeaders.connectionHeader: 'keep-alive',
      'cookie': _customHeaders['cookie']
    };
    final response = await _dio.get(url, options: Options(headers: head));
    final animePage = parse(response.data);
    final infoDd = animePage
        .querySelector(
            '#main > div > div.widget.info > div > div > div.info.col-md-9 > div.row')!
        .querySelectorAll('dd');
    final nextEp = animePage.querySelector('#next-episode');
    final server = <AnimeWorldServer>[];
    for (final e in animePage.querySelectorAll('div.server')) {
      final name = e.attributes['data-name']!;
      final finalName = getName(name);
      if (finalName == ServerName.none) continue;
      server.add(AnimeWorldServer(
          name: finalName,
          canDownload: name != '4',
          listEpisode: e.querySelectorAll('a').map((episode) {
            final title = episode.text.trim();
            return AnimeWorldEpisode(
                title: title,
                commentID: episode.attributes['data-episode-id']!,
                dataID: episode.attributes['data-id']!,
                isFinal: infoDd[8].text.trim() == title,
                referer: AnimeWorldEndPoints.sitePrefixNoS +
                    episode.attributes['href']!);
          }).toList(growable: false)));
    }
    return AnimeWorldSpecificAnime(
        image: animePage
            .querySelector('#thumbnail-watch > img')!
            .attributes['src']!,
        title: animePage.querySelector('h2.title')!.text.trim(),
        animeID: animePage.querySelector('#animeId')?.attributes['data-id'] ??
            response.realUri.toString().split('.').last.split('/')[0],
        comment: AnimeWorldComment(
          referer:
              AnimeWorldEndPoints.sitePrefixNoS + response.realUri.toString(),
          token: animePage
              .querySelector('meta#csrf-token')!
              .attributes['content']!,
          commentId: animePage
                  .querySelector('#player')
                  ?.attributes['data-anime-id'] ??
              animePage.querySelector('#loveButton')!.attributes['data-id']!,
        ),
        description: animePage
                .querySelector('div.desc')
                ?.text
                .replaceAll(RegExp(r'\s+'), ' ') ??
            'Nessuna descrizione disponibile',
        info: DetailAnime(
            categoria: infoDd[0].text.trim(),
            audio: Href(infoDd[1].text.trim(),
                infoDd[1].children.first.attributes['href'] ?? ''),
            releaseDate: infoDd[2].text.trim(),
            season: Href(infoDd[3].text.trim(),
                infoDd[3].children.first.attributes['href'] ?? ''),
            studio: infoDd[4]
                .querySelectorAll('a')
                .map((e) => Href(e.text.trim(), e.attributes['href'] ?? ''))
                .toList(),
            genre: infoDd[5]
                .querySelectorAll('a')
                .map((e) => Href(e.text.trim(), e.attributes['href'] ?? ''))
                .toList(),
            voto: infoDd[6].text.trim(),
            durata: infoDd[7].text.trim(),
            numberEpisode: infoDd[8].text.trim(),
            views: infoDd[10].text.trim(),
            status: Href(infoDd[9].text.trim(),
                infoDd[9].children.first.attributes['href'] ?? '')),
        servers: server,
        simili: animePage
            .querySelectorAll('div.film-list > div.item')
            .map(getAnime)
            .toList(growable: false),
        correlati: animePage
            .querySelectorAll('div.related > div.item')
            .map(getAnime)
            .toList(growable: false),
        state: getState(infoDd[9].text.trim()),
        nextEpisode: nextEp != null
            ? '${nextEp.attributes['data-calendar-date']!} ${nextEp.attributes['data-calendar-time']}'
            : '',
        anilistLink: animePage.querySelector('#anilist-button')?.attributes['href'],
        myanimelistLink: animePage.querySelector('#mal-button')?.attributes['href']
    );
  }

  Future<List<UserComment>> getComment(final AnimeWorldComment info,
      [final String episodeID = '', final String? referer]) async {
    final regexEmoji = RegExp(r'<img.*alt="([^"]+)".*>');
    final head = {
      'user-agent': userAgent,
      'cookie': _customHeaders['cookie']!,
      'CSRF-Token': info.token,
      'Referer': referer ?? info.referer,
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': 'https://www.animeworld.tv/',
      'Connection': 'keep-alive',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-GPC': '1',
      'TE': 'trailers',
      'Accept': 'text/html, */*; q=0.01',
    };
    final request = await _dio.post(
        '${AnimeWorldEndPoints.apiComment}${info.commentId}/$episodeID',
        options: Options(
          headers: head,
        ));
    final page = parse(request.data);
    return page
        .querySelectorAll('div.widget.comment-wrapper')
        .map((final comment) => UserComment(
              image: comment
                  .querySelector('img.comment-author-image')!
                  .attributes['src']!,
              text: comment
                  .querySelector('span.comment-content')!
                  .text
                  .replaceAll(regexEmoji, '')
                  .replaceAll(RegExp(r'\s+'), ' '),
              name: comment
                  .querySelector('div.comment-author-name > a')!
                  .text
                  .replaceAll(regexEmoji, '')
                  .replaceAll(RegExp(r'\s+'), ' '),
              time: comment.querySelector('p.comment-date')!.text.split(' ')[0],
            ))
        .toList()
      ..removeWhere((final comment) => comment.text == '');
  }

  Future<DirectUrlVideo> getUrlVideo(
      final AnimeWorldEpisode episode, final ServerName nameServer) async {
    var head = Map<String, String>.from(_customHeaders);
    head['X-Requested-With'] = 'XMLHttpRequest';
    head['Referer'] = episode.referer;
    final json = Map<String, String>.from((await _dio.get(
            AnimeWorldEndPoints.apiEpisode + episode.dataID,
            options: Options(headers: head)))
        .data as Map);
    final grabber = json['grabber'] ?? '';
    switch (nameServer) {
      case ServerName.youtube:
      case ServerName.animeworld:
        return DirectUrlVideo(grabber, {});
      case ServerName.vvvvid:
        return await VvvvidServer().urlVideo(grabber);
      case ServerName.streamtape:
        return await StreamtapeParser().getUrl(grabber, episode.referer);
      case ServerName.server2:
        return DirectUrlVideo(grabber.split('link=')[1], {});
      case ServerName.doodStream:
        return await DoodstreamParser().getUrl(grabber);
      case ServerName.userload:
        return await UserloadParser().getUrl(grabber);
      case ServerName.streamlare:
        return await StreamlareParser().getUrlVideo(grabber);
      case ServerName.vup:
        return await VupParser().getUrlVideo(grabber);
      default:
        return DirectUrlVideo('', {});
    }
  }

  Future<AnimeGenericData> getGenericPageInfo(final String url) async {
    final data =
        (await _dio.get(url, options: Options(headers: _customHeaders))).data
            as String;
    final page = parse(data);
    return AnimeGenericData(
      _getGenericAnimeList(page),
      int.parse(page.querySelector('.total')?.text ?? '1'));
  }

  Future<List<Anime>> getGenericPage(final String url) async {
    final data =
        (await _dio.get(url, options: Options(headers: _customHeaders))).data
            as String;
    final page = parse(data);
    return _getGenericAnimeList(page);
  }

  List<Anime> _getGenericAnimeList(final Document page) {
    final animeList = <Anime>[];
    final setName = <String>{};
    for (final div in page.querySelectorAll('.film-list > .item > .inner')) {
      final name = div.querySelector('a.name')!;
      if(setName.contains(name.text)) continue;
      setName.add(name.text);
      animeList.add(Anime(
          thumbnail: div.querySelector('img')!.attributes['src']!,
          title: name.text.trim(),
          link: AnimeWorldEndPoints.sitePrefixNoS +
              name.attributes['href']!)
      );
    }
    return animeList;
  }

  List<News> _getListNews(final List<Element> elements) {
    return elements
        .map((final element) => News(
              title: element.querySelector('.title')?.text.trim() ?? '',
              url: AnimeWorldEndPoints.sitePrefixNoS +
                  (element.querySelector('a')?.attributes['href'] ?? ''),
              body: element.querySelector('div.text')?.text.trim() ?? '',
              views: element
                      .querySelector('div.views')
                      ?.text
                      .replaceAll(RegExp('<i.*>'), '') ??
                  '',
              time: element
                      .querySelector('div.date')
                      ?.text
                      .replaceAll(RegExp('<i.*>'), '') ??
                  '',
              img: element.querySelector('img')?.attributes['src'] ?? '',
              type: element
                  .querySelectorAll('span.badge.badge-primary')
                  .map((final e) => e.text)
                  .join(', '),
            ))
        .toList();
  }

  Future<NewsData> getNewsWithPage(final String url) async {
    final data =
        (await _dio.get(url, options: Options(headers: _customHeaders))).data
            as String;
    final page = parse(data);
    return NewsData(
        _getListNews(page.querySelectorAll('div.post-list > div.item.row')),
        int.parse(page.querySelector('.total')?.text ?? '1'));
  }

  Future<List<News>> getNews(final String url) async {
    final data =
        (await _dio.get(url, options: Options(headers: _customHeaders))).data
            as String;
    final page = parse(data);
    return _getListNews(page.querySelectorAll('div.post-list > div.item.row'));
  }

  Future<List<Href>> getUpcomingSections() async {
    final data = (await _dio.get(AnimeWorldEndPoints.upcoming,
            options: Options(headers: _customHeaders)))
        .data as String;
    final page = parse(data);
    return page
        .querySelectorAll('.horiznav_nav > ul > li > a')
        .map((e) => Href(
              e.text.trim(),
              e.attributes['href'] ?? '',
            ))
        .where((element) => element.name != '...')
        .toList();
  }

  Future<UpComingAnime> getUpcomingAnime(final String url) async {
    List<Anime> getListAnime(final Element element) {
      return element
          .querySelectorAll('.item > .inner')
          .map((e) => Anime(
              thumbnail: e.querySelector('img')!.attributes['src']!,
              link: AnimeWorldEndPoints.sitePrefixNoS +
                  e.querySelector('.name')!.attributes['href']!,
              title: e.querySelector('.name')!.text.trim()))
          .toList();
    }

    final data =
        (await _dio.get(url, options: Options(headers: _customHeaders))).data
            as String;
    final page = parse(data);
    final list = page.querySelectorAll('.film-listnext');
    return UpComingAnime(
      tv: getListAnime(list[0]),
      ova: getListAnime(list[1]),
      ona: getListAnime(list[2]),
      special: getListAnime(list[3]),
      movie: getListAnime(list[4]),
    );
  }
}
