import 'dart:async';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/database/anime_saved.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/backend/models/anime.dart';
import 'package:miru_anime/backend/models/home_page.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/updater/app_updater.dart';
import 'package:miru_anime/objectbox.g.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_title_anime.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_with_badge.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_with_bottom_badge.dart';
import 'package:miru_anime/widgets/refresh_indicator.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';
import 'package:miru_anime/widgets/updater_app.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  static const route = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static Future<AnimeWorldHomePage>? _data;
  final PageController _pageController = PageController();
  int _activeTab = 0;
  bool _isEmpty = true;
  late final StreamSubscription<Query<AnimeDatabase>> _sub;
  List<Anime> _userList = <Anime>[];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _data ??= AnimeWorldScraper().getHomePage();
    _sub = ObjectBox.store.box<AnimeDatabase>().query(
        AnimeDatabase_.userFinishedToWatch.equals(false)
    ).watch(triggerImmediately: true).listen((event) {
      final list = (event.find()..sort((final a, final b) => b.time.compareTo(a.time)))
          .map((e) => Anime.fromDatabase(e)).toList();
      setState(() {
        _userList = list;
        _isEmpty = list.isEmpty;
      });
    });
    AppUpdater().checkNewVersions().then((final value) {
      if(value) {
        if(Platform.isIOS) {
          showCupertinoDialog(
            context: context,
            builder: (_) => UpdaterWidget.iosAlertDialog(context)
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => UpdaterWidget.androidAlertDialog(context)
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    ObjectBox.store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: HomePage.route,
      scrollController: _scrollController,
      paddingTop: false,
      child: AppRefreshIndicator(
        onRefresh: () async {
          _data = AnimeWorldScraper().getHomePage();
          setState(() {});
        },
        child: FutureBuilder<AnimeWorldHomePage>(
          future: _data,
          builder: (final _, final snap) {
            switch (snap.connectionState) {
              case ConnectionState.done:
                return snap.hasError ? SafeArea(bottom: false, child: DefaultErrorPage(error: snap.error.toString())) : _successfulWidget(snap.data!);
              default:
                return const _ShimmerWidget();
            }
          },
        ),
      )
    );
  }

  Widget _successfulWidget(final AnimeWorldHomePage data) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              const _CustomTitle(title: 'Top Anime'),
              _selectTop(),
              _topAnime(data.topAnime),
              const _CustomTitle(title: 'Raccomandati'),
              _Swiper(list: data.sliders),
              Visibility(
                visible: !_isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CustomTitle(title: 'Continua a guardare'),
                    _AnimeListViewWithBadge(list: _userList, prefixBadge: 'Ep: ',),
                  ],
                ),
              ),
              const _CustomTitle(title: 'In tendenza'),
              _AnimeListView(list: data.trending),
              const _CustomTitle(title: 'In corso'),
              _AnimeListView(list: data.ongoing),
              const _CustomTitle(title: 'Ultimi episodi'),
              _AnimeListView(list: data.all),
              const _CustomTitle(title: 'Sub ITA'),
              _AnimeListView(list: data.subITA),
              const _CustomTitle(title: 'Doppiati ITA'),
              _AnimeListView(list: data.dubbed),
              const _CustomTitle(title: 'Nuove aggiunte'),
              _AnimeListView(list: data.newAdded),
              _CustomTitle(title: data.upcomingTitle),
              _AnimeListView(list: data.upcoming),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ],
          ),
        ),
        //Status bar gradient color
        Positioned(
          top: 0,
          child: Container(
            height: MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).backgroundColor,
                    Theme.of(context).backgroundColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget _topAnime(final List<List<Anime>> data) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 520),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (final page) {
          setState(() => _activeTab = page);
        },
        children: [
          _RankedAnime(list: data[0], key: const PageStorageKey('dayTop'),),
          _RankedAnime(list: data[1], key: const PageStorageKey('weekTop'),),
          _RankedAnime(list: data[2], key: const PageStorageKey('monthTop'),),
        ],
      ),
    );
  }

  Widget _selectTop(){
    Widget _tab(final String label, final int tabNum){
      final bool isDisable = _activeTab != tabNum;
      return GestureDetector(
        onTap: () async => await _pageController.animateToPage(
          tabNum,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        ),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: !isDisable ? BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                width: 2
              ),
              borderRadius: BorderRadius.circular(50)
          ) : const BoxDecoration(),
          child: Text(
            label,
            style: TextStyle(
              color: isDisable
                  ? Theme.of(context).colorScheme.onBackground.withOpacity(0.65)
                  : Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tab('Today',0),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10.0),),
          _tab('Week',1),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10.0),),
          _tab('Month',2),
        ],
      ),
    );
  }
}

class _Swiper extends StatelessWidget {
  final List<Anime> list;
  const _Swiper({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemBuilder: (context, index) {
          final anime = list[index];
          return ThumbnailWithTitle(
            title: anime.title,
            image: anime.thumbnail,
            urlAnime: anime.link,
            width: 340,
            height: 140,
          );
        },
        itemHeight: 200,
        itemWidth: 340,
        itemCount: list.length,
        scale: 0.7,
      ),
    );
  }
}

class _RankedAnime extends StatelessWidget {
  final List<Anime> list;
  const _RankedAnime({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThumbnailWithBadge(
          title: list.first.title,
          thumbnail: list.first.thumbnail,
          link: list.first.link,
          width: MediaQuery.of(context).size.width * 0.85,
          height: 210,
          rank: list.first.rank!,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 245
            ),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 6),
              scrollDirection: Axis.horizontal,
              itemCount: list.length - 1,
              itemBuilder: (_, index) {
                final anime = list[index+1];
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.5),
                    child: ThumbnailWithBadge(
                      rank: anime.rank!,
                      thumbnail: anime.thumbnail,
                      link: anime.link,
                      title: anime.title,
                    )
                );
              },
            )
        ),
      ],
    );
  }
}



class _AnimeListView extends StatelessWidget {
  final List<Anime> list;
  const _AnimeListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 245
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 6),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, index) {
          final anime = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.5),
            child: ThumbnailWithTitle(
              title: anime.title,
              image: anime.thumbnail,
              urlAnime: anime.link,
            ),
          );
        },
      ),
    );
  }
}

class _AnimeListViewWithBadge extends StatelessWidget {
  final String prefixBadge;
  final List<Anime> list;
  const _AnimeListViewWithBadge({Key? key, required this.list, this.prefixBadge = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 245
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 6),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, index) {
          final anime = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.5),
            child: ThumbnailBottomBadge(
              title: anime.title,
              thumbnail: anime.thumbnail,
              link: anime.link,
              badge: '$prefixBadge${anime.info!}',
            ),
          );
        },
      ),
    );
  }
}

class _CustomTitle extends StatelessWidget {
  final String title;
  const _CustomTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Theme.of(context).colorScheme.secondary)
      ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          _title(),
          Shimmer.fromColors(
              baseColor: AppColors.baseColor,
              highlightColor: AppColors.highlightColor,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 210,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.grey
                  ),
                ),
              )),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _row(),
          _title(),
          _row(),
          _title(),
          _row()
        ],
      ),
    );
  }

  Widget _row() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 260
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_,__){
          return const ShimmerBox(
              height: 225,
              width: 155
          );
        },
      ),
    );
  }
  Widget _title() {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0,top: 10, bottom: 10),
      child: ShimmerBox(
        width: 200,
        height: 20,
      ),
    );
  }
}




