import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/backend/sites/animeworld/models/anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_title_anime.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';

class SearchPage extends StatefulWidget {
  static const route = '/search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final delay = const Duration(milliseconds: 450);
  Timer? timer;
  bool searchActivated = false;
  late Future<List<Anime>> listAnime;
  String? _text;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 55,
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 250,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 19,
                    color: AppColors.purple,
                  ),
                  //const Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      autocorrect: false,
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyText1!.apply(
                        color: Colors.black
                      ),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hoverColor: AppColors.purple,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10,right: 10),
                        hintText: 'Cerca un titolo...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                          letterSpacing: 0.15
                        ),
                      ),
                      cursorColor: AppColors.purple,
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
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        FontAwesomeIcons.circleXmark,
                        size: 20,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
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
        if(snap.connectionState != ConnectionState.done) {
          return _shimmerSearch();
        }
        if(snap.hasError) {
          return DefaultErrorPage(error: snap.error.toString());
        }
        return _successfulResult(snap.data!);
      },
    );
  }

  Widget _shimmerSearch(){
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 155/270),
      itemBuilder: (final context, final index){
        return Column(
          children: const [
            ShimmerBox(
              height: 225,
              width: 155,
            ),
            ShimmerBox(width: 150,height: 15,)
          ],
        );
      },
      itemCount: 6,
    );
  }

  Widget _successfulResult(final List<Anime> list){
    if(list.isEmpty) {
      return const Center(
        child: Text('Nessun anime trovato',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return CupertinoScrollbar(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 155/270,
            mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemBuilder: (final context, final index){
          final anime = list[index];
          return ThumbnailWithTitle(
            title: anime.title,
            image: anime.thumbnail,
            urlAnime: anime.link,
            width: double.infinity,
            height: 205,
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
