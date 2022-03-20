import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';

class CategoriesPage extends StatelessWidget {
  static const route = '/categories';
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _section(final String name, final String url) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_,__,___) => GenericPage(url: url, name: name, route: ''),
                transitionsBuilder: transitionBuilder
              )
            );
          },
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            child: Center(child: Text(name, style: Theme.of(context).textTheme.bodyText1,)),
          ),
        ),
      );
    }

    return AppScaffold(
        route: route,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text('Categorie', style: Theme.of(context).textTheme.bodyText1,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _section('Anime', AnimeWorldEndPoints.anime),
                  _section('Movie', AnimeWorldEndPoints.movies),
                  _section('OVA', AnimeWorldEndPoints.ova),
                  _section('ONA', AnimeWorldEndPoints.ona),
                  _section('Special', AnimeWorldEndPoints.special),
                  _section('Music', AnimeWorldEndPoints.music),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20))
                ],
              ),
            ),
          ],
        )
    );
  }
}
