import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:miru_anime/app_theme/theme.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
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
import 'package:resize/resize.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final send = IsolateNameServer.lookupPortByName('downloader_send_port');
  if (send != null) send.send([id, status, progress]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final futures = await Future.wait(<Future<dynamic>>[
    FlutterDownloader.initialize(),
    ObjectBox.init(),
    AppSettings.isLogged(AppSettings.anilistSetting),
    AppSettings.initializeTheme(),
    AppSettings.isLogged(AppSettings.malSetting),
  ]);
  FlutterDownloader.registerCallback(downloadCallback);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  Anilist.isLogged = futures[2];
  MyAnimeList.isLogged = futures[4];
  final TypeTheme theme = futures[3];
  if(theme == TypeTheme.light)
    SystemChrome.setSystemUIOverlayStyle(statusBarLight);
  else
    SystemChrome.setSystemUIOverlayStyle(statusBarDark);
  runApp(MiruAnimeApp(themeType: theme));
}

class MiruAnimeApp extends StatelessWidget {
  final TypeTheme themeType;

  const MiruAnimeApp({Key? key, required this.themeType}) : super(key: key);

  // This widget is the root of this application
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppTheme>(
      create: (_) => AppTheme(themeType),
      child: Resize(
        builder: () {
          return Consumer<AppTheme>(
            builder: (_, final app, __) {
              return MaterialApp(
                restorationScopeId: 'MiruAnime',
                title: 'Miru Anime',
                theme: app.theme,
                home: const HomePage(),
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
        }
      ),
    );
  }
}