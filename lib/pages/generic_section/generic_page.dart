import 'package:flutter/material.dart';
import 'package:miru_anime/backend/models/anime.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/widgets/shimmer_gridview_anime.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/gridview_anime.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:miru_anime/widgets/default_error_page.dart';


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
      ++page;
      AnimeWorldScraper().getGenericPage('$url$page').then((value) async {
        if (!mounted) return;
        setState(() {
          animeList.addAll(value);
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
      scrollController: _controller,
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onRefresh: () async {
          page = 1;
          future = AnimeWorldScraper().getGenericPage('$url$page');
          setState(() {});
        },
        child: Column(
          children: [
            UnderlineTitleWithCloseButton(text: '$name  •  Page: $page'),
            Expanded(
              child: FutureBuilder<void>(
                future: future,
                builder: (_, final snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const ShimmerGridAnime();
                    case ConnectionState.done:
                      return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) :
                      GridViewAnime(animeList: animeList, controller: _controller);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
