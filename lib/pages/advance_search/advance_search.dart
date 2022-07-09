import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/sites/animeworld/search_filter.dart';
import 'package:miru_anime/pages/generic_section/generic_page.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/rounded_label.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:miru_anime/widgets/dropdown_alert.dart';

class AdvanceSearch extends StatefulWidget {
  static const route = '/advanceSearch';
  const AdvanceSearch({Key? key}) : super(key: key);

  @override
  State<AdvanceSearch> createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {

  List<Map<Object, Map<String, Object>>> get _filterMaps => [
    mapAnimeWorldGenresFilter,
    mapAnimeWorldLanguageFilter,
    mapAnimeWorldOrderFilter,
    mapAnimeWorldStatusFilter,
    mapAnimeWorldSeasonFilter,
    mapAnimeWorldTypeFilter,
    mapAnimeWorldYearsFilter,
    mapAnimeWorldSoundFilter,
    mapAnimeWorldStudioFilter,
  ];

  Iterable<String> parseMap(final Map<Object, Map<String, Object>> map) =>
      map.values.where((final x) => x['selected'] as bool).map((final x) => x['query'] as String);

  String get _queryParamsChain =>
      _filterMaps.map(parseMap).expand((final element) => element).join('');

  void _resetFilters() {
    setState(() {
      for (var map in _filterMaps) {
        for (var x in map.values) {
          x['selected'] = false;
        }
      }
      _filterMaps[2][AnimeWorldOrderFilter.standard]!['selected'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: AdvanceSearch.route,
      child: SafeArea(
        child: Column(
          children: [
            const UnderlineTitleWithCloseButton(text: 'Ricerca avanzata'),
            Expanded(
              child: CupertinoScrollbar(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10,),),
                    _filterButton(label: 'Generi', map: mapAnimeWorldGenresFilter),
                    _filterButton(label: 'Anno', map: mapAnimeWorldYearsFilter),
                    _filterButton(
                      label: 'Stato',
                      map: mapAnimeWorldStatusFilter,
                      type: DropdownAlertType.radio,
                    ),
                    _filterButton(
                      label: 'Ordine',
                      map: mapAnimeWorldOrderFilter,
                      type: DropdownAlertType.radio,
                    ),
                    _filterButton(
                        label: 'Stagione', map: mapAnimeWorldSeasonFilter),
                    _filterButton(
                        label: 'Sottotitoli', map: mapAnimeWorldLanguageFilter),
                    _filterButton(
                        label: 'Audio',
                        map: mapAnimeWorldSoundFilter
                    ),
                    _filterButton(label: 'Tipo', map: mapAnimeWorldTypeFilter),
                    _filterButton(label: 'Studio', map: mapAnimeWorldStudioFilter),
                    _resetButton(),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    _searchBar(),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _searchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_,__,___) => GenericPage(
              url: '${AnimeWorldEndPoints.advanceSearch}$_queryParamsChain&page=',
              name: 'Ricerca avanzata',
              route: ''
            ),
            transitionsBuilder: transitionBuilder
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: 50,
          //margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(FontAwesomeIcons.magnifyingGlassPlus,
                    size: 16, color: Colors.black),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 35),
                  child: const Text(
                    'Ricerca avanzata',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _filterButton({
    required final String label,
    required final Map<Object, Map<String, Object>> map,
    final DropdownAlertType type = DropdownAlertType.checkbox,
  }) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => DropdownAlert(filterMap: map, type: type, labelPefix: label,),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: RoundedLabel(name: label),
      ),
    );
  }

  Widget _resetButton() {
    return GestureDetector(
      onTap: () {
        _resetFilters();
        // TODO: Implementare una logica di undo
        Fluttertoast.showToast(
          msg: 'Filtri cancellati',
          toastLength: Toast.LENGTH_LONG
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: 50,
          //margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(FontAwesomeIcons.replyAll,
                    size: 16, color: Colors.black),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 35),
                  child: const Text(
                    'Resetta filtri',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
