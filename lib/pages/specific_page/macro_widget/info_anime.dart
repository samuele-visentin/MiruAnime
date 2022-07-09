import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/models/specific_page.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';

class InfoAnime extends StatelessWidget {
  final DetailAnime info;
  final String nextEpisode;
  const InfoAnime({Key? key, required this.info, required this.nextEpisode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Visibility(
            visible: nextEpisode != '',
            child: Row(
              children: [
                Text(
                  'Prossimo episodio: ',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  nextEpisode,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Categoria: ${info.categoria}', style: Theme.of(context).textTheme.caption,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _RowInfo(
            url: info.audio.url,
            name: 'Audio',
            value: info.audio.name
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Data di uscita: ${info.releaseDate}', style: Theme.of(context).textTheme.caption,),
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
          Text('Voto: ${info.voto}', style: Theme.of(context).textTheme.caption,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Durata: ${info.durata}', style: Theme.of(context).textTheme.caption,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Episodi: ${info.numberEpisode}', style: Theme.of(context).textTheme.caption,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _RowInfo(
              url: info.status.url,
              name: 'Stato',
              value: info.status.name
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Visualizzazioni: ${info.views}', style: Theme.of(context).textTheme.caption,),
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
          style: Theme.of(context).textTheme.bodySmall,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_,__,___) => GenericPage(
              url: '${AnimeWorldEndPoints.sitePrefixNoS}$url&page=',
              name: value,
              route: ''
            ),
            transitionsBuilder: transitionBuilder
          )),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
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
        Text('$name: ', style: Theme.of(context).textTheme.bodySmall,),
        for (final item in list)
          GestureDetector(
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_,__,___) => GenericPage(
                      url: item.url.contains('?') ? '${AnimeWorldEndPoints.sitePrefixNoS}${item.url}&page=' :
                          '${AnimeWorldEndPoints.sitePrefixNoS}${item.url}?page=',
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
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(', ', style: Theme.of(context).textTheme.bodySmall)
                ],
              )
          )
      ],
    );
  }
}


