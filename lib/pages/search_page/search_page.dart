import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/models/anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/pages/drawer_page/drawer.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gridview_anime.dart';
import 'package:miru_anime/widgets/shimmer_gridview_anime.dart';

class SearchPage extends StatefulWidget {
  static const route = '/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final delay = const Duration(milliseconds: 450);
  Timer? timer;
  static bool searchActivated = false;
  static late Future<List<Anime>> listAnime;
  String? _text;
  final _controller = ScrollController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerMenu(
        route: SearchPage.route,
        scrollController: _controller,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            _searchBar(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Expanded(child: _futureBuilder()),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Builder(builder: (context) {
            return IconButton(
              iconSize: 22,
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(FontAwesomeIcons.bars, color: Theme.of(context).colorScheme.secondary,),
              splashRadius: 25,
            );
          }),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 55,
            child: Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 19,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      //const Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          autocorrect: false,
                          autofocus: true,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hoverColor: Theme.of(context).colorScheme.onSurface,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 10,right: 10),
                            hintText: 'Cerca un titolo...',
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey,
                              letterSpacing: 0.15
                            ),
                          ),
                          cursorColor: Theme.of(context).colorScheme.onSurface,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (String text) {
                            if(_text == text.trim()) {
                              return;
                            }
                            if(timer?.isActive ?? false) {
                              timer!.cancel();
                            }
                            text = text.replaceAll(RegExp(r'\s+'), ' ');
                            if(!mounted) {
                              return;
                            }
                            listAnime = AnimeWorldScraper().getSearchList(text);
                            _text = text.trim();
                            setState(() {
                              searchActivated = true;
                            });
                          },
                          onChanged: (String text) {
                            if(_text==text.trim()) {
                              return;
                            }
                            if(text.trim().isEmpty) {
                              return;
                            }
                            if(timer?.isActive ?? false) {
                              timer!.cancel();
                            }
                            timer = Timer(delay, () {
                              text = text.replaceAll(RegExp(r'\s+'), ' ');
                              if(!mounted) {
                                return;
                              }
                              listAnime = AnimeWorldScraper().getSearchList(text);
                              _text = text.trim();
                              setState(() {
                                searchActivated = true;
                              });
                            });
                          },
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).pop(),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            FontAwesomeIcons.circleXmark,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _futureBuilder(){
    if(!searchActivated) {
      return Container();
    }
    return FutureBuilder<List<Anime>>(
      future: listAnime,
      builder: (final context, final snap){
        switch (snap.connectionState) {
          case ConnectionState.done:
            return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) : GridViewAnime(animeList: snap.data!, controller: _controller,);
          default:
            return const ShimmerGridAnime();
        }
      },
    );
  }
}
