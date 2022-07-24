import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/models/server.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/globals/server_types.dart';
import 'package:miru_anime/widgets/title_close_button.dart';
import 'package:wakelock/wakelock.dart';

class AppVideoPlayer extends StatefulWidget {
  static const route = '/videoplayer';
  final AnimeWorldEpisode episode;
  final ServerName nameServer;
  final String animeName;
  const AppVideoPlayer({Key? key,
    required this.episode,
    required this.nameServer,
    required this.animeName
  }) : super(key: key);

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {

  AnimeWorldEpisode get _episode => widget.episode;
  ServerName get _name => widget.nameServer;
  String get _animeName => widget.animeName;
  late final Future<void> _url;
  late final BetterPlayerController _controller;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.contain,
        autoPlay: true,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        showPlaceholderUntilPlay: true,
        //placeholderOnTop: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 16/9,
        autoDispose: true,
        errorBuilder: (_, final errorMessage) =>
            _errorWidget(errorMessage.toString()),
      ),
    );
    _url = AnimeWorldScraper().getUrlVideo(_episode, _name).then((final value) {
      _controller.setupDataSource(
        BetterPlayerDataSource.network(
          value.urlVideo,
          headers: value.headers,
        ),
      );
      if(mounted) _controller.addEventsListener(changeAspectRatio);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final color = Theme.of(context).colorScheme.secondary;
    _controller.setBetterPlayerControlsConfiguration(
      BetterPlayerControlsConfiguration(
        //pipMenuIcon: Icons.picture_in_picture_alt_sharp,
        enableAudioTracks: false,
        enablePip: false,
        enableSubtitles: false,
        controlBarColor: Colors.black.withOpacity(0.55),
        progressBarBufferedColor: AppColors.background,
        controlsHideTime: const Duration(milliseconds: 10),
        enableQualities: true,
        loadingColor: color,
        progressBarPlayedColor: color,
        progressBarHandleColor: color,
        overflowMenuIconsColor: color,
        overflowModalColor: AppColors.white,
        overflowModalTextColor: Colors.black,
        //liveTextColor: Colors.black,
        //iconsColor: Colors.redAccent[700],
        iconsColor: AppColors.white,
      ),
    );
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
    //_controller.removeEventsListener(changeAspectRatio); We disposing the controller the next line so the listener should be removed with that function
    _controller.dispose();
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
              child: FutureBuilder<void>(
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
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
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
        thumbVisibility: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            const Text(
              'The video URL is broken. Maybe the site has changed its API infrastructure or try to change the server (Userload has several problem for copyright), if the problem persist send me the following error message so i can solve the problem:',
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
              _controller.betterPlayerDataSource?.url ?? '',
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
