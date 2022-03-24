import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/sites/animeworld/models/specific_page.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';

class InfoAnime extends StatelessWidget {
  final DetailAnime info;
  final String nextEpisode;
  const InfoAnime({Key? key, required this.info, required this.nextEpisode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Visibility(
            visible: nextEpisode != '',
            child: Row(
              children: [
                Text(
                  'Prossimo episodio: ',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  nextEpisode,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Categoria: ${info.categoria}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _RowInfo(
            url: info.audio.url,
            name: 'Audio',
            value: info.audio.name
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Data di uscita: ${info.releaseDate}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _RowInfo(
              url: info.season.url,
              name: 'Stagione',
              value: info.season.name
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _WrapContent(list: info.studio, name: 'Studio',),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _WrapContent(list: info.genre, name: 'Genere',),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Voto: ${info.voto}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Durata: ${info.durata}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Episodi: ${info.numberEpisode}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _RowInfo(
              url: info.status.url,
              name: 'Stato',
              value: info.status.name
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Visualizzazioni: ${info.views}', style: Theme.of(context).textTheme.subtitle2,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String url;
  final String name;
  final String value;
  const _RowInfo({Key? key, required this.url, required this.name, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$name: ',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_,__,___) => GenericPage(
              url: '${AnimeWorldEndPoints.sitePrefixNoS}$url&page=',
              name: '$name $value',
              route: ''
            ),
            transitionsBuilder: transitionBuilder
          )),
          child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: AppColors.purple,
            ),
          )
        )
      ],
    );
  }
}

class _WrapContent extends StatelessWidget {
  final List<Href> list;
  final String name;
  const _WrapContent({Key? key, required this.list, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 2,
      runSpacing: 4,
      children: [
        Text('$name: ', style: Theme.of(context).textTheme.subtitle2,),
        for (final item in list)
          GestureDetector(
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_,__,___) => GenericPage(
                      url: '${AnimeWorldEndPoints.sitePrefixNoS}${item.url}?page=',
                      name: item.name,
                      route: ''
                  ),
                  transitionsBuilder: transitionBuilder
              )),
              behavior: HitTestBehavior.opaque,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: AppColors.purple,
                    ),
                  ),
                  const Text(', ')
                ],
              )
          )
      ],
    );
  }
}


