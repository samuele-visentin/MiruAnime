import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/models/anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/generic_section/generic_shimmer_page.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';


class GenericPage extends StatefulWidget {
  final String url;
  final String name;
  final String route;

  const GenericPage({
    Key? key,
    required this.url,
    required this.name,
    required this.route
  }) : super(key: key);

  @override
  State<GenericPage> createState() => _GenericPageState();
}

class _GenericPageState extends State<GenericPage> {

  int page = 1;
  late Future<void> future;
  late final List<Anime> animeList;
  final ScrollController _controller = ScrollController();
  String get url => widget.url;
  String get name => widget.name;
  String get route => widget.route;
  bool loading = false;
  int maxPage = 1;

  @override
  void initState() {
    super.initState();
    future = AnimeWorldScraper().getGenericPageInfo('$url$page').then((value) {
      maxPage = value.maxPage;
      animeList = value.list;
      return;
    });
    _controller.addListener(_listener);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  void _listener() {
    if(page == maxPage) return;
    if(_controller.position.maxScrollExtent <= _controller.position.pixels + 400) {
      if (loading) return;
      loading = true;
      AnimeWorldScraper().getGenericPage('$url$page').then((value) async {
        if (!mounted) return;
        setState(() {
          animeList.addAll(value);
          ++page;
        });
        await Future.delayed(const Duration(milliseconds: 150)); //we wait so the build function can execute before the listener does another fetch
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: route,
      child: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          future = AnimeWorldScraper().getGenericPage('$url$page');
          setState(() {});
        },
        child: FutureBuilder<void>(
          future: future,
          builder: (_, final snap) {
            switch (snap.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const GenericShimmerPage();
              case ConnectionState.done:
                return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) : successfulPage();
            }
          },
        ),
      ),
    );
  }

  Widget successfulPage() {
    if(animeList.isEmpty){
      return const Center(
        child: Text('Nessun anime', style: TextStyle(fontSize: 18)),
      );
    }
    return Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Text('$name  •  Page: $page', style: Theme.of(context).textTheme.bodyText1,),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10),),
        const Divider(
          color: AppColors.purple,
          endIndent: 20,
          indent: 20,
          thickness: 1.5,
          height: 0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: CupertinoScrollbar(
              controller: _controller,
              child: GridView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                itemCount: animeList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 155/225,
                    mainAxisSpacing: 15, crossAxisSpacing: 15
                ),
                itemBuilder: (final context, final index) {
                  final anime = animeList[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque, //so if the user tab on empty field (like btw image and title) we also obtain the tap invoke
                    onTap: () {
                      Navigator.of(context).push(
                          PageRouteBuilder(
                              pageBuilder: (_,__,___) => SpecificAnimePage(url: anime.link),
                              transitionsBuilder: transitionBuilder
                          )
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.purple.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: ThumbnailAnime(
                            height: 225,
                            width: 155,
                            image: anime.thumbnail,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            anime.title,
                            style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w800, fontSize: 13),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                }),
            ),
          ),
        ),
      ],
    );
  }

}
