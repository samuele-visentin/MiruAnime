import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/models/news.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsPage extends StatefulWidget {
  static const route = '/news';
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  int page = 1;
  late Future<void> future;
  late final List<News> news;
  final ScrollController _controller = ScrollController();
  bool loading = false;
  int maxPage = 1;

  void _listener() {
    if(page == maxPage) return;
    if(_controller.position.maxScrollExtent <= _controller.position.pixels + 400) {
      if (loading) return;
      loading = true;
      ++page;
      AnimeWorldScraper().getNews('${AnimeWorldEndPoints.news}$page').then((value) async {
        if (!mounted) return;
        setState(() {
          news.addAll(value);
        });
        await Future.delayed(const Duration(milliseconds: 150)); //we wait so the build function can execute before the listener does another fetch
        loading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    future = AnimeWorldScraper().getNewsWithPage('${AnimeWorldEndPoints.news}$page').then((value){
      maxPage = value.maxPage;
      news = value.news;
      return;
    });
    _controller.addListener(_listener);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: NewsPage.route,
      scrollController: _controller,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UnderlineTitleWithCloseButton(
            text: 'News  •  Page: $page',
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: future,
              builder: (_, snap) {
                switch(snap.connectionState) {
                  case ConnectionState.done:
                    return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) : _successfulPage();
                  default:
                    return const _ShimmerNewsPage();
                }
              },
            )
          )
        ],
      )
    );
  }

  Widget _successfulPage() {
    return CupertinoScrollbar(
      controller: _controller,
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        itemCount: news.length,
        itemBuilder: (_, final index){
          final element = news[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical:12),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => launchUrl(Uri.parse(element.url)),
              onLongPress: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_,__,___) => ViewImage(url: element.img),
                  transitionsBuilder: transitionBuilder
              )),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.onBackground),
                  borderRadius: BorderRadius.circular(9)
                ),
                child: Row(
                  children: [
                    ThumbnailAnime(
                      image: element.img,
                      width: 156.5,
                      height: 170,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 4),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(padding: EdgeInsets.symmetric(vertical: 5),),
                                Text(
                                  element.title,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.secondary
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  element.body,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.15
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Positioned(
                              right: 1,
                              top: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  element.time,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 10
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerNewsPage extends StatelessWidget {
  const _ShimmerNewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      children: [
        ShimmerBox(height: 170, width: MediaQuery.of(context).size.width *0.9),
        ShimmerBox(height: 170, width: MediaQuery.of(context).size.width *0.9),
        ShimmerBox(height: 170, width: MediaQuery.of(context).size.width *0.9),
        ShimmerBox(height: 170, width: MediaQuery.of(context).size.width *0.9),
      ],
    );
  }
}

