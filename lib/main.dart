import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miru_anime/app_theme/theme.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:miru_anime/backend/database/custom_player.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/backend/sites/anilist/anilist.dart';
import 'package:miru_anime/backend/sites/animeworld/anime_section.dart';
import 'package:miru_anime/backend/sites/myanimelist/myanimelist.dart';
import 'package:miru_anime/pages/advance_search/advance_search.dart';
import 'package:miru_anime/pages/categorie_page/categorie_page.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/pages/genre_page/genre_page.dart';
import 'package:miru_anime/pages/home_page/home_page.dart';
import 'package:miru_anime/pages/news_page/news_page.dart';
import 'package:miru_anime/pages/search_page/search_page.dart';
import 'package:miru_anime/pages/settings_page/settings_page.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/pages/upcoming_page/upcoming_page.dart';
import 'package:miru_anime/pages/user_list_page/user_anime_list.dart';
import 'package:miru_anime/utils/no_scroll_behavior.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = (await Future.wait([
    ObjectBox.init(),
    Anilist.getSetting(),
    MyAnimeList.getSetting(),
    CustomPlayer.getSetting(),
    dotenv.load(fileName: '.env'),
    AppSettings.initializeTheme()
  ])).last as TypeTheme;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(statusBarDark);
  runApp(
    ChangeNotifierProvider<AppTheme>(
      create: (_) => AppTheme(theme),
      child: const MiruAnimeApp(),
    )
  );
}

class MiruAnimeApp extends StatelessWidget {

  const MiruAnimeApp({super.key});

  // This widget is the root of this application
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Consumer<AppTheme>(
          builder: (_, final app, __) {
            return MaterialApp(
              restorationScopeId: 'MiruAnime',
              title: 'Miru Anime',
              home: child,
              theme: themeAppPurple,
              darkTheme: themeAppAmoled,
              themeMode: app.mode,
              scrollBehavior: const NoScrollBehavior(),
              onGenerateRoute: (final settings) {
                switch(settings.name!) {
                  case HomePage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const HomePage(),
                        transitionsBuilder: transitionBuilder
                    );
                  case SearchPage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const SearchPage(),
                        transitionsBuilder: transitionBuilder
                    );
                  case SettingsPage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const SettingsPage(),
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
                  case NewsPage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const NewsPage(),
                        transitionsBuilder: transitionBuilder
                    );
                  case UpcomingPage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const UpcomingPage(),
                        transitionsBuilder: transitionBuilder
                    );
                  case UserAnimeListPage.route:
                    return PageRouteBuilder(
                        settings: settings,
                        pageBuilder: (_,__,___) => const UserAnimeListPage(),
                        transitionsBuilder: transitionBuilder
                    );
                }
                return null;
              },
            );
          },
        );
      },
      child: const HomePage(),
    );
  }
}