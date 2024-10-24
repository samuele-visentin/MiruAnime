import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';

class GenrePage extends StatefulWidget {
  static const route = '/genres';

  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();

  static const _baseUrl = '${AnimeWorldEndPoints.sitePrefixS}genre/';

  static const Map<String, Map<String, String>> _data = {
    'Arti Marziali': {
      'svgAssetPath': 'assets/genres/martial_arts.svg',
      'url': '${_baseUrl}arti-marziali',
    },
    'Automobilistico': {
      'svgAssetPath': 'assets/genres/cars.svg',
      'url': '${_baseUrl}veicoli',
    },
    'Drammatico': {
      'svgAssetPath': 'assets/genres/drama.svg',
      'url': '${_baseUrl}drama',
    },
    'Harem': {
      'svgAssetPath': 'assets/genres/harem.svg',
      'url': '${_baseUrl}harem',
    },
    'Magico': {
      'svgAssetPath': 'assets/genres/magic.svg',
      'url': '${_baseUrl}magic',
    },
    'Musical': {
      'svgAssetPath': 'assets/genres/musical.svg',
      'url': '${_baseUrl}music',
    },
    'Romantico': {
      'svgAssetPath': 'assets/genres/romance.svg',
      'url': '${_baseUrl}romance',
    },
    'Seinen': {
      'svgAssetPath': 'assets/genres/seinen.svg',
      'url': '${_baseUrl}seinen',
    },
    'Shounen': {
      'svgAssetPath': 'assets/genres/shounen.svg',
      'url': '${_baseUrl}shounen',
    },
    'Spazio': {
      'svgAssetPath': 'assets/genres/space.svg',
      'url': '${_baseUrl}space',
    },
    'Superpoteri': {
      'svgAssetPath': 'assets/genres/superpowers.svg',
      'url': '${_baseUrl}super-power',
    },
    'Yuri': {
      'svgAssetPath': 'assets/genres/yuri.svg',
      'url': '${_baseUrl}yuri',
    },
    'Avventura': {
      'svgAssetPath': 'assets/genres/adventure.svg',
      'url': '${_baseUrl}adventure',
    },
    'Commedia': {
      'svgAssetPath': 'assets/genres/comedy.svg',
      'url': '${_baseUrl}commedia',
    },
    'Ecchi': {
      'svgAssetPath': 'assets/genres/ecchi.svg',
      'url': '${_baseUrl}ecchi',
    },
    'Hentai': {
      'svgAssetPath': 'assets/genres/hentai.svg',
      'url': '${_baseUrl}hentai',
    },
    'Mecha': {
      'svgAssetPath': 'assets/genres/mecha.svg',
      'url': '${_baseUrl}mecha',
    },
    'Parodia': {
      'svgAssetPath': 'assets/genres/parody.svg',
      'url': '${_baseUrl}parody',
    },
    'Samurai': {
      'svgAssetPath': 'assets/genres/samurai.svg',
      'url': '${_baseUrl}samurai',
    },
    'Sentimentale': {
      'svgAssetPath': 'assets/genres/sentimental.svg',
      'url': '${_baseUrl}sentimental',
    },
    'Shounen Ai': {
      'svgAssetPath': 'assets/genres/shounen_ai.svg',
      'url': '${_baseUrl}shounen-ai',
    },
    'Thriller': {
      'svgAssetPath': 'assets/genres/thriller.svg',
      'url': '${_baseUrl}thriller',
    },
    'Azione': {
      'svgAssetPath': 'assets/genres/action.svg',
      'url': '${_baseUrl}action',
    },
    'Demenziale': {
      'svgAssetPath': 'assets/genres/demential.svg',
      'url': '${_baseUrl}dementia',
    },
    'Fantasy': {
      'svgAssetPath': 'assets/genres/fantasy.svg',
      'url': '${_baseUrl}fantasy',
    },
    'Horror': {
      'svgAssetPath': 'assets/genres/horror.svg',
      'url': '${_baseUrl}horror',
    },
    'Militare': {
      'svgAssetPath': 'assets/genres/military.svg',
      'url': '${_baseUrl}military',
    },
    'Poliziesco': {
      'svgAssetPath': 'assets/genres/crime.svg',
      'url': '${_baseUrl}police',
    },
    'Fantascienza': {
      'svgAssetPath': 'assets/genres/scifi.svg',
      'url': '${_baseUrl}sci-fi',
    },
    'Shoujo': {
      'svgAssetPath': 'assets/genres/shoujo.svg',
      'url': '${_baseUrl}shoujo',
    },
    'Slice of Life': {
      'svgAssetPath': 'assets/genres/slice_of_life.svg',
      'url': '${_baseUrl}slice-of-life',
    },
    'Sports': {
      'svgAssetPath': 'assets/genres/sports.svg',
      'url': '${_baseUrl}sports',
    },
    'Vampiri': {
      'svgAssetPath': 'assets/genres/vampires.svg',
      'url': '${_baseUrl}vampire',
    },
    'Bambini': {
      'svgAssetPath': 'assets/genres/kids.svg',
      'url': '${_baseUrl}bambini',
    },
    'Demoni': {
      'svgAssetPath': 'assets/genres/demons.svg',
      'url': '${_baseUrl}demoni',
    },
    'Gioco': {
      'svgAssetPath': 'assets/genres/game.svg',
      'url': '${_baseUrl}game',
    },
    'Josei': {
      'svgAssetPath': 'assets/genres/josei.svg',
      'url': '${_baseUrl}josei',
    },
    'Mistero': {
      'svgAssetPath': 'assets/genres/mistery.svg',
      'url': '${_baseUrl}mistery',
    },
    'Psicologico': {
      'svgAssetPath': 'assets/genres/psychological.svg',
      'url': '${_baseUrl}psychological',
    },
    'Scolastico': {
      'svgAssetPath': 'assets/genres/school.svg',
      'url': '${_baseUrl}school',
    },
    'Shoujo Ai': {
      'svgAssetPath': 'assets/genres/shoujo_ai.svg',
      'url': '${_baseUrl}shoujo-ai',
    },
    'Soprannaturale': {
      'svgAssetPath': 'assets/genres/supernatural.svg',
      'url': '${_baseUrl}supernatural',
    },
    'Storico': {
      'svgAssetPath': 'assets/genres/historical.svg',
      'url': '${_baseUrl}historical',
    },
    'Yaoi': {
      'svgAssetPath': 'assets/genres/yaoi.svg',
      'url': '${_baseUrl}yaoi',
    },
  };
}

class _GenrePageState extends State<GenrePage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        route: GenrePage.route,
        scrollController: scrollController,
        child: Column(
          children: [
            const UnderlineTitleWithCloseButton(text: 'Generi'),
            Expanded(
              child: CupertinoScrollbar(
                controller: scrollController,
                child: GridView.builder(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (_, index) {
                    final genere = GenrePage._data.entries.elementAt(index);
                    return genreCard(
                        genreTitle: genere.key,
                        url: genere.value['url']!,
                        svgAssetPath: genere.value['svgAssetPath']!);
                  },
                  itemCount: GenrePage._data.length,
                ),
              ),
            )
          ],
        ));
  }

  Widget genreCard({
    required final String genreTitle,
    required final String svgAssetPath,
    required final String url,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => GenericPage(
                  url: '$url?page=',
                  name: genreTitle,
                  route: '',
                ),
            transitionsBuilder: transitionBuilder));
      },
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            svgAssetPath,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
            height: 80,
            semanticsLabel: genreTitle,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(genreTitle,
                softWrap: false, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
