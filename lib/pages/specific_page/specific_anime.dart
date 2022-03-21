import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/backend/database/anime_saved.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/backend/sites/animeworld/models/server.dart';
import 'package:miru_anime/backend/sites/animeworld/models/specific_page.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/sites/server_parser.dart';
import 'package:miru_anime/backend/sites/video_url.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/objectbox.g.dart';
import 'package:miru_anime/pages/specific_page/micro_widget/comment_widget.dart';
import 'package:miru_anime/pages/specific_page/micro_widget/info_anime.dart';
import 'package:miru_anime/pages/specific_page/micro_widget/description.dart';
import 'package:miru_anime/pages/specific_page/shimmer_page.dart';
import 'package:miru_anime/pages/video_player/video_player.dart';
import 'package:miru_anime/pages/specific_page/micro_widget/anime_grid.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificAnimePage extends StatefulWidget {
  static const randomAnimeRoute = '/random';
  static const route = '/specific';
  final String url;
  final bool isRandom;
  const SpecificAnimePage({Key? key, required this.url, this.isRandom = false})
      : super(key: key);

  @override
  _SpecificAnimePageState createState() => _SpecificAnimePageState();
}

class _SpecificAnimePageState extends State<SpecificAnimePage> {
  late String _url;
  late Future<AnimeWorldSpecificAnime> _anime;
  late AnimeDatabase _animeSaved;
  final PageController _pageController = PageController();
  int _activePage = 0;
  bool _isAdded = false;
  late final Box<AnimeDatabase> _box;
  late final StreamSubscription _sub;
  int _currentServer = 0;
  ServerParser _nameServer = ServerParser.none;
  final _port = ReceivePort();
  final List<AppDownloadTask> _task = [];

  Future<AnimeWorldSpecificAnime> getFuture() {
    return AnimeWorldScraper().getSpecificAnimePage(_url).then((value) {
      if (value.servers.isNotEmpty) {
        final index = value.servers
            .indexWhere((element) => element.name == ServerParser.animeworld);
        if (!index.isNegative) {
          final animeworldServer = value.servers[index];
          value.servers.removeAt(index);
          value.servers.insert(0, animeworldServer);
        }
        _nameServer = value.servers.first.name;
      }
      _sub = _box
          .query(AnimeDatabase_.animeID.equals(value.animeID))
          .watch(triggerImmediately: true)
          .listen((event) {
        final anime = event.findUnique();
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

  Future<void> getRandom() async {
    final url = (await Dio().get(_url))
        .redirects
        .first
        .location
        .replace(scheme: 'https')
        .toString();
    setState(() {
      _url = url;
    });
  }

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    if (widget.isRandom) {
      _anime = getRandom().then((_) {
        return getFuture();
      });
    } else {
      _anime = getFuture();
    }
    _box = ObjectBox.store.box<AnimeDatabase>();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final String id = data[0];
      final DownloadTaskStatus status = data[1];
      //final int progress = data[2];
      final index = _task.indexWhere((element) => element.id == id);
      if(index.isNegative) return;
      if(!mounted) return;
      setState((){
        _task[index].status = status;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _anime.whenComplete(() {
      _sub.cancel();
    });
    _pageController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
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
            return RefreshIndicator(
              color: AppColors.purple,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              backgroundColor: AppColors.darkBlue,
              onRefresh: () async {
                _anime = AnimeWorldScraper().getSpecificAnimePage(_url);
                setState(() {});
              },
              child: DefaultErrorPage(error: snap.error.toString()),
            );
          }
          return _successfulPage(snap.data!);
        },
      ),
    );
  }

  Widget _successfulPage(final AnimeWorldSpecificAnime data) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 25),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ViewImage(url: data.image),
                    transitionsBuilder: transitionBuilder)),
                child: ThumbnailAnime(
                  width: 145,
                  height: 200,
                  image: data.image,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                              child: IconButton(
                                iconSize: 17,
                                splashRadius: 20,
                                onPressed: () => _manageStorage(data),
                                icon: Icon(
                                  _isAdded
                                      ? FontAwesomeIcons.minus
                                      : FontAwesomeIcons.plus,
                                  color: AppColors.purple,
                                  //size: 17,
                                ))),
                        ),
                        IconButton(
                          splashRadius: 20,
                          iconSize: 17,
                          icon: const Icon(
                            FontAwesomeIcons.share,
                            color: AppColors.purple,
                            //size: 17,
                          ),
                          onPressed: () {
                            Share.share(_url);
                          },
                        ),
                        _badge(data.info.voto),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 8.0, right: 8.0),
                      child: Center(
                        child: SizedBox(
                          height: 150,
                          child: Text(
                            data.title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        const Divider(
          indent: 8,
          endIndent: 8,
          thickness: 1.5,
          height: 0,
          color: AppColors.grey,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
        ),
        _selectPage(),
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
          child: PageView(
            onPageChanged: (index) => setState(() {
              _activePage = index;
            }),
            controller: _pageController,
            children: [
              _episodeWidget(data),
              Description(description: data.description),
              InfoAnime(
                info: data.info,
                nextEpisode: data.nextEpisode,
              ),
              CommentWidget(
                  key: const PageStorageKey('AnimeComment'),
                  episodeID: null,
                  commentInfo: data.comment,
                  referer: null,
                  save: true),
              AnimeGridView(
                listAnime: data.simili,
                key: const PageStorageKey('animeSimili'),
              ),
              AnimeGridView(
                listAnime: data.correlati,
                key: const PageStorageKey('animeCorrelati'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _episodeWidget(final AnimeWorldSpecificAnime anime) {
    final List<AnimeWorldServer> data = anime.servers;
    Widget _selectServer() {
      return Row(
        textBaseline: TextBaseline.ideographic,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
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
                  size: 16,
                  color: _currentServer > 0
                      ? AppColors.purple
                      : AppColors.grey.withOpacity(0.35),
                )),
          ),
          SizedBox(
            width: 175,
            child: Text(
              _nameServer.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  fontFamily: 'Montserrat',
                  letterSpacing: -0.5),
            ),
          ),
          GestureDetector(
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
                  size: 16,
                  color: _currentServer < data.length - 1
                      ? AppColors.purple
                      : AppColors.grey.withOpacity(0.35),
                )),
          ),
        ],
      );
    }

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Non ci sono episodi',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.end,
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1.5),
            child: CupertinoScrollbar(
              child: ListView.builder(
                key: const PageStorageKey('EpsiodeWidget'),
                itemBuilder: (final context, final index) {
                  final episode = data[_currentServer].listEpisode[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 15, bottom: 12.0, top: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            textBaseline: TextBaseline.ideographic,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 125,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    'Episodio: ${episode.title}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      textBaseline: TextBaseline.ideographic,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Visibility(
                                visible: _nameServer != ServerParser.youtube,
                                replacement: const SizedBox(
                                  width: 17,
                                ),
                                child:SizedBox(
                                  width: 27,
                                  height: 20,
                                  child: IconButton(
                                    iconSize: 17,
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _playEpisode(episode, anime),
                                    icon:  const Icon(
                                      FontAwesomeIcons.play,
                                      color: AppColors.purple,
                                      //size: 17,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 27,
                                height: 20,
                                child: IconButton(
                                  iconSize: 20,
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _playBrowserVideo(episode),
                                  icon:  const Icon(
                                    FontAwesomeIcons.compass,
                                    color: AppColors.purple,
                                    //size: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Visibility(
                                replacement: const SizedBox(
                                  width: 17,
                                ),
                                visible: data[_currentServer].canDownload,
                                child: SizedBox(
                                  width: 27,
                                  height: 20,
                                  child: IconButton(
                                    iconSize: 17,
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _downloadEpisode(episode, anime),
                                    icon:  const Icon(
                                      FontAwesomeIcons.download,
                                      color: AppColors.purple,
                                      //size: 17,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Visibility(
                                visible: _task.any((element) => element.name == episode.title),
                                child: SizedBox(
                                  width: 27,
                                  height: 20,
                                  child: IconButton(
                                    iconSize: 17,
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _removeEpisode(episode),
                                    icon:  const Icon(
                                      FontAwesomeIcons.solidCircleXmark,
                                      color: AppColors.purple,
                                      //size: 17,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 27,
                                      height: 20,
                                      child: IconButton(
                                        iconSize: 17,
                                        splashRadius: 20,
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _openComment(anime, episode),
                                        icon:  const Icon(
                                          FontAwesomeIcons.solidComment,
                                          color: AppColors.purple,
                                          //size: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 0,
          thickness: 1,
        ),
        _selectServer(),
      ],
    );
  }

  void _openComment(
      final AnimeWorldSpecificAnime anime, final AnimeWorldEpisode episode) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              backgroundColor: AppColors.background,
              clipBehavior: Clip.antiAlias,
              child: CommentWidget(
                  commentInfo: anime.comment,
                  episodeID: '/${episode.commentID}',
                  referer: episode.referer),
            ));
  }

  void _playEpisode(
      final AnimeWorldEpisode episode, AnimeWorldSpecificAnime anime) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            AppVideoPlayer(
              episode: episode,
              nameServer: _nameServer,
              animeName: anime.title,
            ),
        transitionsBuilder: transitionBuilder));
    if (_isAdded) {
      _updateDB(episode, anime);
    }
  }

  void _playBrowserVideo(final AnimeWorldEpisode episode) async {
    final url = await AnimeWorldScraper().getUrlVideo(episode, _nameServer);
    if(url.urlVideo.isEmpty) throw 'url empty';
    launch(url.urlVideo, headers: url.headers);
  }
  

  Future<void> _downloadEpisode(final AnimeWorldEpisode episode, final AnimeWorldSpecificAnime anime) async {
    if(await Permission.storage.request() == PermissionStatus.denied){
      Fluttertoast.showToast(
          msg: 'Permessi negati, download cancellato',
          toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    final url = await AnimeWorldScraper().getUrlVideo(episode, _nameServer);
    if(url.urlVideo.contains('.m3u8')) {
      Fluttertoast.showToast(msg: 'Questo tipo di video non può essere scarcato');
      return;
    }
    Directory saveDir;
    if(!Platform.isIOS) {
      saveDir = (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first;
    } else {
      saveDir = await getApplicationDocumentsDirectory();
    }
    final id = await FlutterDownloader.enqueue(
      url: url.urlVideo,
      savedDir: saveDir.path,
      saveInPublicStorage: true,
      headers: url.headers,
      fileName: anime.title + ' episodio ' + episode.title + '.mp4'
    );
    setState(() {
      _task.add(AppDownloadTask(episode.title, DownloadTaskStatus.enqueued, id!));
    });
  }

  void _removeEpisode(final AnimeWorldEpisode episode) {
    final index = _task.indexWhere((element) => element.name == episode.title);
    FlutterDownloader.remove(taskId: _task[index].id);
    setState(() {
      _task.removeAt(index);
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    if(send != null) send.send([id, status, progress]);
  }

  void _updateDB(
      final AnimeWorldEpisode episode, final AnimeWorldSpecificAnime data) {
    _animeSaved = AnimeDatabase(
        id: _animeSaved.id,
        animeID: data.animeID,
        title: data.title,
        animeIsFinished: data.state == AnimeState.finish,
        animeUrl: _url,
        imgUrl: data.image,
        currentEpisode: 'Ep: ${episode.title}',
        time: DateTime.now().toString(),
        userFinishedToWatch:
            episode.isFinal && data.state == AnimeState.finish);
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
            currentEpisode: 'Ep: -',
            time: DateTime.now().toString(),
            userFinishedToWatch: false);
        _isAdded = true;
      });
      _box.put(_animeSaved);
    } else {
      _box.remove(_animeSaved.id);
      setState(() {
        _isAdded = false;
      });
    }
  }

  Widget _selectPage() {
    Widget _tab(final String title, final int page) {
      final _isDisable = _activePage != page;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GestureDetector(
          onTap: () {
            _pageController.animateToPage(page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            _isDisable ? Colors.transparent : AppColors.purple,
                        width: 1.5))),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  letterSpacing: -0.55,
                  color: _isDisable ? AppColors.grey : AppColors.white,
                  fontWeight: _isDisable ? FontWeight.w400 : FontWeight.w500,
                  fontSize: _isDisable ? 16.0 : 18.0),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _tab('Episodi', 0),
          _tab('Descrizione', 1),
          _tab('Info Anime', 2),
          _tab('Commenti', 3),
          _tab('Simili', 4),
          _tab('Correlati', 5),
        ],
      ),
    );
  }

  Widget _badge(final String voto) {
    final rating = voto != 'N/A' ? voto.split('/')[0] : '-';
    return Container(
      height: 30,
      width: 50,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            AppColors.darkBlue,
            AppColors.darkPurple,
            AppColors.purple,
          ], stops: [
            0.15,
            0.65,
            1
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(8.0)),
      child: Center(
          child: Text(
        rating,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .apply(color: AppColors.white),
        textAlign: TextAlign.center,
      )),
    );
  }
}
