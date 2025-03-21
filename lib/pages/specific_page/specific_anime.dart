import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/database/anime_saved.dart';
import 'package:miru_anime/backend/database/custom_player.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/backend/models/anime_cast.dart';
import 'package:miru_anime/backend/models/comment.dart';
import 'package:miru_anime/backend/models/server.dart';
import 'package:miru_anime/backend/models/specific_page.dart';
import 'package:miru_anime/backend/sites/anilist/anilist.dart';
import 'package:miru_anime/backend/sites/anilist/anilist_status.dart';
import 'package:miru_anime/backend/sites/myanimelist/mal_status.dart';
import 'package:miru_anime/backend/sites/myanimelist/myanimelist.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/globals/server_types.dart';
import 'package:miru_anime/backend/globals/video_url.dart';
import 'package:miru_anime/objectbox.g.dart';
import 'package:miru_anime/pages/specific_page/macro_widget/comment_widget.dart';
import 'package:miru_anime/pages/specific_page/macro_widget/detail_anime.dart';
import 'package:miru_anime/pages/specific_page/macro_widget/related_content.dart';
import 'package:miru_anime/pages/specific_page/shimmer_page.dart';
import 'package:miru_anime/pages/video_player/video_player.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';
import 'package:miru_anime/widgets/refresh_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificAnimePage extends StatefulWidget {
  static const randomAnimeRoute = '/random';
  static const route = '/specific';
  final String? url;
  final bool isRandom;
  const SpecificAnimePage({super.key, this.url, this.isRandom = false});

  @override
  State<SpecificAnimePage> createState() => _SpecificAnimePageState();
}

class _SpecificAnimePageState extends State<SpecificAnimePage> {
  late String _url;
  late Future<AnimeWorldSpecificAnime> _anime;
  late AnimeDatabase _animeSaved;
  bool _isAdded = false;
  late final Box<AnimeDatabase> _box;
  late final StreamSubscription _sub;
  int _currentServer = 0;
  ServerName _nameServer = ServerName.none;
  final commentMap = <String, Future<List<UserComment>>>{};
  Future<List<AnimeCast>>? animeCast;

  Future<AnimeWorldSpecificAnime> getFuture(final url) async {
    return await AnimeWorldScraper().getSpecificAnimePage(url).then((value) async {
      if (value.servers.isNotEmpty) {
        final index = value.servers.indexWhere((element) => element.name == ServerName.animeworld);
        if (index != -1) {
          final animeworldServer = value.servers[index];
          value.servers.removeAt(index);
          value.servers.insert(0, animeworldServer);
        }
        _nameServer = value.servers.first.name;
      }
      _sub = _box.query(AnimeDatabase_.animeID.equals(value.animeID)).watch(triggerImmediately: true).listen((event) {
        final anime = event.findUnique();
        if (!mounted) return;
        if (anime != null) {
          setState(() {
            _isAdded = true;
            _animeSaved = anime;
          });
        }
      });
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isRandom) {
      _anime = AnimeWorldScraper().getRandomAnime().then((value) async {
        _url = value;
        return await getFuture(_url);
      });
    } else {
      _url = widget.url!;
      _anime = getFuture(_url);
    }
    _box = ObjectBox.store.box<AnimeDatabase>();
  }

  @override
  void dispose() {
    _anime.whenComplete(() {
      _sub.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: SpecificAnimePage.route,
      child: FutureBuilder<AnimeWorldSpecificAnime?>(
        future: _anime,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const ShimmerAnimePage();
          } else if (snap.hasError) {
            return AppRefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  _anime = getFuture(_url);
                  setState(() {});
                },
                child: DefaultErrorPage(error: snap.error.toString()));
          }
          return _successfulPage(snap.data!);
        },
      ),
    );
  }

  Widget _successfulPage(final AnimeWorldSpecificAnime data) {
    final buttonColor = Theme.of(context).colorScheme.secondary;

    final thumbnailWithBadge = Padding(
      padding: const EdgeInsets.only(top: 4, left: 25),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => ViewImage(url: data.image), transitionsBuilder: transitionBuilder)),
            child: ThumbnailAnime(
              width: 145,
              height: 200,
              image: data.image,
            ),
          ),
          _Badge(voto: data.info.voto),
        ],
      ),
    );

    final addRemoveButton = IconButton(
        iconSize: 20,
        splashRadius: 20,
        onPressed: () => _manageStorage(data),
        icon: Icon(
          _isAdded ? FontAwesomeIcons.circleMinus : FontAwesomeIcons.circlePlus,
          color: buttonColor,
          //size: 17,
        ));

    final shareButton = IconButton(
      splashRadius: 20,
      iconSize: 20,
      icon: Icon(
        FontAwesomeIcons.share,
        color: buttonColor,
        //size: 17,
      ),
      onPressed: () {
        Share.share(_url);
      },
    );

    final closeButton = GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: SizedBox(
        width: 36,
        height: 20,
        child: Icon(
          FontAwesomeIcons.circleXmark,
          size: 20,
          color: buttonColor,
        ),
      ),
    );

    final title = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
      child: Center(
        child: SizedBox(
          height: 150,
          child: Text(
            data.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 7,
          ),
        ),
      ),
    );

    final section = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              animeCast ??= Anilist().getCastAnime(data.anilistLink);
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DetailWidget(
                        description: data.description,
                        detail: data.info,
                        nextEpisode: data.nextEpisode,
                        cast: animeCast!,
                      ),
                  transitionsBuilder: transitionBuilder));
            },
            child: Text(
              'Dettagli',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        GestureDetector(
            onTap: () {
              commentMap['animeComment'] ??= AnimeWorldScraper().getComment(data.comment);
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CommentWidget(comments: commentMap['animeComment']!, name: 'Commenti'),
                  transitionsBuilder: transitionBuilder));
            },
            child: Text(
              'Commenti',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => RelatedContent(simili: data.simili, correlati: data.correlati),
                  transitionsBuilder: transitionBuilder));
            },
            child: Text(
              'Altri contenuti',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
      ],
    );

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            thumbnailWithBadge,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        addRemoveButton,
                        shareButton,
                        closeButton,
                      ],
                    ),
                    title
                  ],
                ),
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        section,
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
        ),
        const Divider(
          indent: 8,
          endIndent: 8,
          thickness: 1.5,
          height: 0,
          color: AppColors.grey,
        ),
        Expanded(
          child: _episodeWidget(data),
        )
      ],
    );
  }

  Widget _episodeWidget(final AnimeWorldSpecificAnime anime) {
    final List<AnimeWorldServer> data = anime.servers;
    final buttonColor = Theme.of(context).colorScheme.secondary;

    Widget selectServer() {
      final leftArrow = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_currentServer > 0) {
            setState(() {
              --_currentServer;
              _nameServer = data[_currentServer].name;
            });
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FaIcon(
              FontAwesomeIcons.backward,
              size: 20,
              color: _currentServer > 0 ? buttonColor : AppColors.grey.withOpacity(0.35),
            )),
      );

      final serverName = SizedBox(
        width: 175,
        child: Text(_nameServer.toString(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
      );

      final rightArrow = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_currentServer < data.length - 1) {
            setState(() {
              ++_currentServer;
              _nameServer = data[_currentServer].name;
            });
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FaIcon(
              FontAwesomeIcons.forward,
              size: 20,
              color: _currentServer < data.length - 1 ? buttonColor : AppColors.grey.withOpacity(0.35),
            )),
      );

      return Row(
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [leftArrow, serverName, rightArrow],
      );
    }

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Non ci sono episodi',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1.5),
            child: CupertinoScrollbar(
              child: ListView.builder(
                key: const PageStorageKey('EpsiodeWidget'),
                itemBuilder: (final context, final index) {
                  final episode = data[_currentServer].listEpisode[index];
                  final title = SizedBox(
                    width: 125,
                    height: 20,
                    child: Center(
                      child: Text('Episodio: ${episode.title}', style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  );

                  final playButton = Visibility(
                    visible: _nameServer != ServerName.youtube,
                    replacement: const SizedBox(
                      width: 27,
                    ),
                    child: SizedBox(
                      width: 27,
                      height: 20,
                      child: IconButton(
                        iconSize: 20,
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        onPressed: () => _playEpisode(episode, anime),
                        icon: Icon(
                          FontAwesomeIcons.play,
                          color: buttonColor,
                          //size: 17,
                        ),
                      ),
                    ),
                  );

                  final playBrowser = SizedBox(
                    width: 27,
                    height: 20,
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      onPressed: () => _playBrowserVideo(episode, anime),
                      icon: Icon(
                        FontAwesomeIcons.compass,
                        color: buttonColor,
                      ),
                    ),
                  );

                  final openComment = SizedBox(
                    width: 27,
                    height: 20,
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      onPressed: () => _openComment(anime, episode),
                      icon: Icon(
                        FontAwesomeIcons.solidComment,
                        color: buttonColor,
                        //size: 17,
                      ),
                    ),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            textBaseline: TextBaseline.ideographic,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title,
                              const SizedBox(
                                width: 40,
                              ),
                              playButton,
                              const SizedBox(
                                width: 20,
                              ),
                              playBrowser,
                              const SizedBox(
                                width: 20,
                              ),
                              openComment,
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data[_currentServer].listEpisode.length,
              ),
            ),
          ),
        ),
        Divider(
          indent: 20,
          endIndent: 20,
          height: 0,
          thickness: 1,
          color: Theme.of(context).colorScheme.secondary.withAlpha(80),
        ),
        selectServer(),
      ],
    );
  }

  void _openComment(final AnimeWorldSpecificAnime anime, final AnimeWorldEpisode episode) {
    commentMap[episode.title] ??= AnimeWorldScraper().getComment(anime.comment, episode.commentID, episode.referer);
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => CommentWidget(comments: commentMap[episode.title]!, name: anime.title),
        transitionsBuilder: transitionBuilder));
  }

  void _playEpisode(final AnimeWorldEpisode episode, final AnimeWorldSpecificAnime anime) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => AppVideoPlayer(
              episode: episode,
              nameServer: _nameServer,
              animeName: anime.title,
            ),
        transitionsBuilder: transitionBuilder));
    if (_isAdded) {
      _updateDB(episode, anime);
    }
    _updateEpisodeOnlineDB(anime, episode);
  }

  void _playBrowserVideo(final AnimeWorldEpisode episode, final AnimeWorldSpecificAnime anime) async {
    late final DirectUrlVideo url;
    try {
      url = await AnimeWorldScraper().getUrlVideo(episode, _nameServer);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Errore: ${e.toString()}', toastLength: Toast.LENGTH_LONG);
      return;
    }
    var uri = Uri.tryParse(url.urlVideo);
    if (uri == null) {
      Fluttertoast.showToast(msg: 'Errore nell\'ottenimento del link', toastLength: Toast.LENGTH_LONG);
      return;
    }
    switch (CustomPlayer.player) {
      case Player.browser:
        final launched = await launchUrl(
          uri,
          webViewConfiguration: WebViewConfiguration(headers: url.headers),
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          Fluttertoast.showToast(msg: 'Errore nell\'apertura del browser', toastLength: Toast.LENGTH_LONG);
          return;
        }
        break;
      case Player.vlc:
        final vlcUrl = Uri.parse('vlc://${uri.toString()}');
        final launched = await launchUrl(vlcUrl,
            webViewConfiguration: WebViewConfiguration(headers: url.headers), mode: LaunchMode.externalApplication);
        if (!launched) {
          Fluttertoast.showToast(
              msg: 'Errore nell\'apertura di VLC (verifica di averlo installato)', toastLength: Toast.LENGTH_LONG);
          return;
        }
        break;
      case Player.infuse:
        final infuseUri = Uri.parse('infuse://x-callback-url/play?x-success=miruanime://&url=${uri.toString()}');
        final launched = await launchUrl(
          infuseUri,
          webViewConfiguration: WebViewConfiguration(headers: url.headers),
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          Fluttertoast.showToast(
              msg: 'Errore nell\'apertura di Infuse (verifica di averlo installato)', toastLength: Toast.LENGTH_LONG);
          return;
        }
        break;
    }
    if (_isAdded) {
      _updateDB(episode, anime);
    }
    _updateEpisodeOnlineDB(anime, episode);
  }

  void _updateDB(final AnimeWorldEpisode episode, final AnimeWorldSpecificAnime data) {
    _animeSaved = AnimeDatabase(
        id: _animeSaved.id,
        animeID: data.animeID,
        title: data.title,
        animeIsFinished: data.state == AnimeState.finish,
        animeUrl: _url,
        imgUrl: data.image,
        currentEpisode: episode.title,
        time: DateTime.now().toString(),
        userFinishedToWatch: episode.isFinal && data.state == AnimeState.finish);
    _box.put(_animeSaved, mode: PutMode.update);
  }

  void _manageStorage(final AnimeWorldSpecificAnime data) {
    if (!_isAdded) {
      setState(() {
        _animeSaved = AnimeDatabase(
            animeID: data.animeID,
            title: data.title,
            animeIsFinished: data.state == AnimeState.finish,
            animeUrl: _url,
            imgUrl: data.image,
            currentEpisode: '-',
            time: DateTime.now().toString(),
            userFinishedToWatch: false);
        _isAdded = true;
      });
      _box.put(_animeSaved);
      _updateOnlineDB(
          anilistId: data.anilistLink,
          myanimelistId: data.myanimelistLink,
          anilistStatus: AnilistStatus.planning,
          malStatus: MalStatus.planning);
    } else {
      _box.remove(_animeSaved.id);
      setState(() {
        _isAdded = false;
      });
      _updateOnlineDB(
          anilistId: data.anilistLink,
          myanimelistId: data.myanimelistLink,
          anilistStatus: AnilistStatus.paused,
          malStatus: MalStatus.paused);
    }
  }

  void _updateEpisodeOnlineDB(final AnimeWorldSpecificAnime data, final AnimeWorldEpisode episode) {
    var progress = int.tryParse(episode.title);
    progress ??= int.tryParse(episode.title.split('-').last);
    final isFinal = episode.isFinal && data.state == AnimeState.finish;
    _updateOnlineDB(
        anilistId: data.anilistLink,
        myanimelistId: data.myanimelistLink,
        progress: progress,
        anilistStatus: isFinal ? AnilistStatus.completed : AnilistStatus.current,
        malStatus: isFinal ? MalStatus.completed : MalStatus.current);
  }

  void _updateOnlineDB(
      {required final String? anilistId,
      required final String? myanimelistId,
      final int? progress,
      required final AnilistStatus anilistStatus,
      required final MalStatus malStatus}) async {
    if (Anilist.isLogged && anilistId != null) {
      final id = Uri.parse(anilistId).pathSegments.last;
      Anilist().updateUserDataAnimeStatus(id: id, status: anilistStatus, progress: progress);
    }
    if (MyAnimeList.isLogged && myanimelistId != null) {
      final id = Uri.parse(myanimelistId).pathSegments.last;
      MyAnimeList().updateUserList(id: id, status: malStatus, progress: progress);
    }
  }
}

class _Badge extends StatelessWidget {
  final String voto;
  const _Badge({required this.voto});

  @override
  Widget build(BuildContext context) {
    final rating = voto != 'N/A' ? voto.split('/')[0] : '-';
    return Container(
      height: 30,
      width: 50,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.darkBlue,
            AppColors.darkPurple,
            AppColors.purple,
          ], stops: [
            0.15,
            0.65,
            1
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))),
      child: Center(
          child: Text(
        rating,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      )),
    );
  }
}
