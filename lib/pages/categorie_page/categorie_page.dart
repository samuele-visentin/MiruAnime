import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/rounded_label.dart';

import '../../widgets/underline_title_close_button.dart';

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
          child: RoundedLabel(name: name,)
        ),
      );
    }

    return AppScaffold(
        route: route,
        child: Column(
          children: [
            const UnderlineTitleWithCloseButton(text: 'Categorie'),
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
