import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/models/upcoming_anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/pages/generic_section/generic_shimmer_page.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';

import '../../constants/app_colors.dart';
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
          TitleWithCloseButton(text: widget.name),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Expanded(
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Anime'),
                      Tab(text: 'OVA'),
                      Tab(text: 'ONA'),
                      Tab(text: 'Special'),
                      Tab(text: 'Movie'),
                    ],
                    labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800
                    ),
                    unselectedLabelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withAlpha(70)
                    ),
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
                            return const GenericShimmerPage();
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
