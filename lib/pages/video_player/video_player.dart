import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miru_anime/backend/sites/animeworld/models/server.dart';
import 'package:miru_anime/backend/sites/video_url.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/sites/server_parser.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/widgets/title_close_button.dart';
import 'package:wakelock/wakelock.dart';

class AppVideoPlayer extends StatefulWidget {
  static const route = '/videoplayer';
  final AnimeWorldEpisode episode;
  final ServerParser nameServer;
  final String animeName;
  const AppVideoPlayer({Key? key,
    required this.episode,
    required this.nameServer,
    required this.animeName
  }) : super(key: key);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {

  AnimeWorldEpisode get _episode => widget.episode;
  ServerParser get _name => widget.nameServer;
  String get _animeName => widget.animeName;
  late final Future<DirectUrlVideo> _url;
  late final BetterPlayerController _controller;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _url = AnimeWorldScraper().getUrlVideo(_episode, _name).then((value) {
      _controller = BetterPlayerController(
        BetterPlayerConfiguration(
          fit: BoxFit.contain,
          autoPlay: true,
          allowedScreenSleep: false,
          fullScreenByDefault: true,
          showPlaceholderUntilPlay: true,
          //placeholderOnTop: true,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          controlsConfiguration: BetterPlayerControlsConfiguration(
            //pipMenuIcon: Icons.picture_in_picture_alt_sharp,
            enableAudioTracks: false,
            enablePip: false,
            enableSubtitles: false,
            controlBarColor: Colors.black.withOpacity(0.55),
            progressBarBufferedColor: AppColors.background,
            controlsHideTime: const Duration(milliseconds: 10),
            enableQualities: false,
            loadingColor: AppColors.purple,
            progressBarPlayedColor: AppColors.purple,
            progressBarHandleColor: AppColors.purple,
            overflowMenuIconsColor: AppColors.purple,
            overflowModalColor: AppColors.white,
            overflowModalTextColor: Colors.black,
            //liveTextColor: Colors.black,
            //iconsColor: Colors.redAccent[700],
            iconsColor: AppColors.white,
          ),
          aspectRatio: 16/9,
          autoDispose: true,
          errorBuilder: (_, final errorMessage) =>
              _errorWidget(errorMessage.toString()),
        ),
        betterPlayerDataSource: BetterPlayerDataSource.network(
          value.urlVideo,
          headers: value.headers
        ),
      );
      _controller.addEventsListener(changeAspectRatio);
      return value;
    });
  }


  void changeAspectRatio(final BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      _controller.setOverriddenAspectRatio(
          _controller.videoPlayerController!.value.aspectRatio);
    }
  }

  @override
  void dispose() {
    Wakelock.disable();
    _url.whenComplete(() {
      _controller.removeEventsListener(changeAspectRatio);
      _controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TitleWithCloseButton(
                text:  '$_animeName - Episodio: ${_episode.title}',
              )
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            Expanded(
              child: FutureBuilder<DirectUrlVideo>(
                future: _url,
                builder: (_, snap) {
                  switch (snap.connectionState) {
                     case ConnectionState.done:
                      if(snap.hasError){
                        return _errorWidget(snap.error.toString());
                      }
                      return Column(
                        children: [
                          BetterPlayer(controller: _controller, key: _key),
                        ],
                      );
                    default:
                      return _loading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: AppColors.purple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorWidget(final String error){
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: AppColors.background,
      child: CupertinoScrollbar(
        isAlwaysShown: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            const Text(
              'The video URL is broken. Probably the site has changed its API infrastructure; try to change the server (Userload has several problem for copyright), if the problem persist send me the following error message so i can solve the problem:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                letterSpacing: -0.5,
                fontWeight: FontWeight.w600,
                color: AppColors.teal
              ),
            ),
            const SizedBox(height: 20),
            Text(
              error,
              style: const TextStyle(fontSize: 18, color: AppColors.functionalred),
            ),
            const SizedBox(height: 20),
            Text(
              _controller.betterPlayerDataSource!.url,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
