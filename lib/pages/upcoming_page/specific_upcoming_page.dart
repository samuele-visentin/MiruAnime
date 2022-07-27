import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/models/upcoming_anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/shimmer_gridview_anime.dart';

import '../../widgets/gridview_anime.dart';
import '../../widgets/title_close_button.dart';

class SpecificUpcomingPage extends StatefulWidget {
  final String name;
  final String url;
  const SpecificUpcomingPage({Key? key, required this.name, required this.url}) : super(key: key);

  @override
  State<SpecificUpcomingPage> createState() => _SpecificUpcomingPageState();
}

class _SpecificUpcomingPageState extends State<SpecificUpcomingPage> {

  late Future<UpComingAnime> future;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    future = AnimeWorldScraper().getUpcomingAnime(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: '', 
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          TitleWithCloseButton(text: widget.name),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Expanded(
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Anime'),
                      Tab(text: 'OVA'),
                      Tab(text: 'ONA'),
                      Tab(text: 'Special'),
                      Tab(text: 'Movie'),
                    ],
                    indicatorColor: Theme.of(context).colorScheme.onPrimary,
                    labelColor: Theme.of(context).colorScheme.onBackground,
                    labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700
                    ),
                    unselectedLabelColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.65),
                  ),
                  Expanded(
                    child: FutureBuilder<UpComingAnime>(
                      future: future,
                      builder: (_, snap){
                        switch(snap.connectionState){
                          case ConnectionState.done:
                            return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) :
                              _successfulPage(snap.data!);
                          default:
                            return const ShimmerGridAnime();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _successfulPage(final UpComingAnime data) {
    return TabBarView(
      children: [
        GridViewAnime(
          animeList: data.tv,
          key: const PageStorageKey('gridTV'),
        ),
        GridViewAnime(
          animeList: data.ova,
          key: const PageStorageKey('gridOVA'),
        ),
        GridViewAnime(
          animeList: data.ona,
          key: const PageStorageKey('gridONA'),
        ),
        GridViewAnime(
          animeList: data.special,
          key: const PageStorageKey('gridSPECIAL'),
        ),
        GridViewAnime(
          animeList: data.movie,
          key: const PageStorageKey('gridMOVIE'),
        ),
      ],
    );
  }
}
