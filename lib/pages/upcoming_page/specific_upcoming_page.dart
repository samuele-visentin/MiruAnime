import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/models/upcoming_anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/pages/generic_section/generic_shimmer_page.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';

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
                  const TabBar(
                    tabs: [
                      Tab(text: 'Anime'),
                      Tab(text: 'OVA'),
                      Tab(text: 'ONA'),
                      Tab(text: 'Special'),
                      Tab(text: 'Movie'),
                    ],
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

/*class _CustomTab extends StatelessWidget {
  final String name;
  final int page;
  final PageController controller;
  final bool check;
  const _CustomTab({Key? key, required this.name, required this.page, required this.controller, required this.check}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        controller.animateToPage(page, duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: check ? const BoxDecoration(
            border: Border(bottom: BorderSide(
              color: AppColors.purple,
              width: 1.5
            ))
          ) : null,
          child: Text(
            name,
            style: check ? Theme.of(context).textTheme.subtitle1 : Theme.of(context).textTheme.subtitle1!.copyWith(
              //fontWeight: FontWeight.w400,
              color: AppColors.white.withOpacity(0.7)
            ),
          )
        ),
      ),
    );
  }
}*/


