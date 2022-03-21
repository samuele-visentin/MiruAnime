import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/backend/sites/animeworld/anime_section.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/advance_search/advance_search.dart';
import 'package:miru_anime/pages/categorie_page/categorie_page.dart';
import 'package:miru_anime/pages/genre_page/genre_page.dart';
import 'package:miru_anime/pages/home_page/home_page.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';

class AppDrawerMenu extends StatelessWidget {
  final String route;
  const AppDrawerMenu({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent
          ),
          child: ListView(
            children: [
              _TileDrawer(
                name: 'Home',
                route: HomePage.route,
                currentRoute: route,
                icon: FontAwesomeIcons.house,
              ),
              _TileDrawer(
                name: 'Nuove aggiunte',
                route: AnimeSection.newAdded.route,
                currentRoute: route,
                icon: FontAwesomeIcons.plus,
              ),
              _TileDrawer(
                name: 'Ultimi episodi',
                route: AnimeSection.last.route,
                currentRoute: route,
                icon: FontAwesomeIcons.tv
              ),
              _TileDrawer(
                name: 'Anime in corso',
                icon: FontAwesomeIcons.spinner,
                currentRoute: route,
                route: AnimeSection.ongoing.route,
              ),
              _TileDrawer(
                name: 'Generi',
                icon: FontAwesomeIcons.barsStaggered,
                currentRoute: route,
                route: GenrePage.route,
              ),
              _TileDrawer(
                name: 'Categorie',
                icon: FontAwesomeIcons.listUl,
                currentRoute: route,
                route: CategoriesPage.route,
              ),
              _TileDrawer(
                name: 'Ricerca avanzata',
                icon: FontAwesomeIcons.magnifyingGlassPlus,
                currentRoute: route,
                route: AdvanceSearch.route,
              ),
              _TileDrawer(
                name: 'Casuale',
                icon: FontAwesomeIcons.shuffle,
                currentRoute: route,
                route: SpecificAnimePage.randomAnimeRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _TileDrawer extends StatelessWidget {
  final String name;
  final String currentRoute;
  final String route;
  final IconData icon;

  const _TileDrawer({
    Key? key,
    required this.name,
    required this.route,
    required this.currentRoute,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentRoute == route) {
      return Container(
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(color: AppColors.purple, width: 5))),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.20),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18)),
            ),
            child: ListTile(
              onTap: () => Navigator.of(context).pop(),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(name,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.white)
              ),
              leading: FaIcon(
                icon,
                size: 20,
                color: AppColors.purple,
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: (){
          if(route == HomePage.route) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).popAndPushNamed(route);
          }
        },
        title: Text(name,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.white)
        ),
        leading: FaIcon(
          icon,
          size: 20,
          color: AppColors.purple,
        ),
      ),
    );
  }
}

