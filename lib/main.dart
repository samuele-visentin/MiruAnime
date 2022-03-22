import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/backend/sites/animeworld/anime_section.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/constants/theme.dart';
import 'package:miru_anime/pages/advance_search/advance_search.dart';
import 'package:miru_anime/pages/categorie_page/categorie_page.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/pages/genre_page/genre_page.dart';
import 'package:miru_anime/pages/home_page/home_page.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/utils/no_scroll_behavior.dart';
import 'package:miru_anime/utils/transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    FlutterDownloader.initialize(debug: false),
    ObjectBox.init(),
  ]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
    )
  );
  runApp(const MiruAnimeApp());
}

class MiruAnimeApp extends StatelessWidget {
  const MiruAnimeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'MiruAnime',
      title: 'Miru Anime',
      theme: themeApp,
      home: const HomePage(),
      scrollBehavior: NoScrollBehavior(),
      onGenerateRoute: (settings) {
        switch(settings.name!) {
          case HomePage.route:
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => const HomePage(),
              transitionsBuilder: transitionBuilder
            );
          case '/newadded':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.newAdded.url,
                name: AnimeSection.newAdded.name,
                route: AnimeSection.newAdded.route
              ),
              transitionsBuilder: transitionBuilder
            );
          case '/lastepisode':
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_,__,___) => GenericPage(
                    url: AnimeSection.last.url,
                    name: AnimeSection.last.name,
                    route: AnimeSection.last.route
                ),
                transitionsBuilder: transitionBuilder
            );
          case '/ongoing':
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_,__,___) => GenericPage(
                    url: AnimeSection.ongoing.url,
                    name: AnimeSection.ongoing.name,
                    route: AnimeSection.ongoing.route
                ),
                transitionsBuilder: transitionBuilder
            );
          case '/anime':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.anime.url,
                name: AnimeSection.anime.name,
                route: AnimeSection.anime.url
              ),
                transitionsBuilder: transitionBuilder
            );
          case '/movie':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.movie.url,
                name: AnimeSection.movie.name,
                route: AnimeSection.movie.route,
              ),
                transitionsBuilder: transitionBuilder
            );
          case '/ova':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.ova.url,
                name: AnimeSection.ova.name,
                route: AnimeSection.ova.route,
              ),
                transitionsBuilder: transitionBuilder
            );
          case '/ona':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.ona.url,
                name: AnimeSection.ona.name,
                route: AnimeSection.ona.route,
              ),
                transitionsBuilder: transitionBuilder
            );
          case '/music':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.music.url,
                name: AnimeSection.music.name,
                route: AnimeSection.music.route,
              ),
                transitionsBuilder: transitionBuilder
            );
          case '/special':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => GenericPage(
                url: AnimeSection.special.url,
                name: AnimeSection.special.name,
                route: AnimeSection.special.route,
              ),
                transitionsBuilder: transitionBuilder
            );
          case GenrePage.route:
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_,__,___) => const GenrePage(),
                transitionsBuilder: transitionBuilder
            );
          case SpecificAnimePage.randomAnimeRoute:
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => const SpecificAnimePage(
                url: AnimeWorldEndPoints.random,
                isRandom: true
              ),
              transitionsBuilder: transitionBuilder
            );
          case CategoriesPage.route:
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => const CategoriesPage(),
              transitionsBuilder: transitionBuilder
            );
          case AdvanceSearch.route:
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_,__,___) => const AdvanceSearch(),
              transitionsBuilder: transitionBuilder
            );
        }
        return null;
      },
    );
  }
}