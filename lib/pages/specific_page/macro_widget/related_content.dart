import 'package:flutter/material.dart';
import 'package:miru_anime/backend/models/anime.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/gridview_anime.dart';
import 'package:miru_anime/widgets/title_close_button.dart';

class RelatedContent extends StatelessWidget {
  final List<Anime> correlati;
  final List<Anime> simili;
  const RelatedContent({Key? key, required this.simili, required this.correlati}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: '',
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              const TitleWithCloseButton(text: 'Altri contenuti'),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              TabBar(
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                labelColor: Theme.of(context).colorScheme.onBackground,
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16
                ),
                tabs: const [
                  Tab(text: 'Correlati',),
                  Tab(text: 'Simili')
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GridViewAnime(
                      animeList: correlati,
                      key: const PageStorageKey('animeCorrelati'),
                    ),
                    GridViewAnime(
                      animeList: simili,
                      key: const PageStorageKey('animeSilimi'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
