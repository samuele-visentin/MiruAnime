import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/backend/database/store.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/pages/user_list_page/sort_filter.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/dropdown_alert.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';
import 'package:miru_anime/widgets/title_close_button.dart';
import 'package:resize/resize.dart';

import '../../backend/database/anime_saved.dart';
import '../../objectbox.g.dart';
import '../../utils/transition.dart';

class UserAnimeListPage extends StatefulWidget {
  static const route = '/userlist';
  const UserAnimeListPage({super.key});

  @override
  State<UserAnimeListPage> createState() => _UserAnimeListPageState();
}

class _UserAnimeListPageState extends State<UserAnimeListPage> {

  late final StreamSubscription<Query<AnimeDatabase>> _sub;
  List<AnimeDatabase> _userListOngoing = [];
  List<AnimeDatabase> _userListFinished = [];

  @override
  void initState() {
    super.initState();
    _sub = ObjectBox.store.box<AnimeDatabase>().query().watch(triggerImmediately: true).listen((event) {
      final list = event.find();
      _userListOngoing = list.where((element) => !element.userFinishedToWatch).toList();
      _userListFinished = list.where((element) => element.userFinishedToWatch).toList();
      _sort();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: UserAnimeListPage.route,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Stack(
              alignment: Alignment.center,
              children: [
                const TitleWithCloseButton(text: 'La mia lista'),
                Positioned(
                  right: 25,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => DropdownAlert(
                         filterMap: sortFilter,
                          type: DropdownAlertType.radio,
                          labelPefix: 'Ordine',
                          fun: _sort,
                        )
                      );
                    },
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        FontAwesomeIcons.sort,
                        size: 19,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.onPrimary,
              labelColor: Theme.of(context).colorScheme.onSurface,
              labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 12.sp
              ),
              tabs: const [
                Tab(text: 'In corso',),
                Tab(text: 'Finiti')
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _GridViewAnime(
                    list: _userListOngoing,
                    key: const PageStorageKey('listOngoing'),
                  ),
                  _GridViewAnime(
                    list: _userListFinished,
                    key: const PageStorageKey('listFinished'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  void _sort() {
    switch(sortFilter.entries.firstWhere((element) => element.value['selected'] == true).key) {
      case SortType.recent:
        setState(() {
          _userListFinished.sort((final a, final b) => b.time.compareTo(a.time));
          _userListOngoing.sort((final a, final b) => b.time.compareTo(a.time));
        });
        break;
      case SortType.oldest:
        setState(() {
          _userListOngoing.sort((final a, final b) => a.time.compareTo(b.time));
          _userListFinished.sort((final a, final b) =>
              a.time.compareTo(b.time));
        });
        break;
      case SortType.a_z:
        setState(() {
          _userListOngoing.sort((final a, final b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          _userListFinished.sort((final a, final b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        });
        break;
      case SortType.z_a:
        setState(() {
          _userListOngoing.sort((final a, final b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
          _userListFinished.sort((final a, final b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        });
        break;
    }
  }
}

class _GridViewAnime extends StatelessWidget {
  final List<AnimeDatabase> list;
  const _GridViewAnime({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if(list.isEmpty) return Center(child: Text('Nessun anime', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),);
    return CupertinoScrollbar(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 150/230,
            mainAxisSpacing: 20, crossAxisSpacing: 15
        ),
        itemBuilder: (_,final index) {
          final anime = list[index];
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(9)
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_,__,___)=> SpecificAnimePage(url: anime.animeUrl),
                  transitionsBuilder: transitionBuilder
                )
              ),
              onLongPress: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_,__,___) => ViewImage(url: anime.imgUrl),
                  transitionsBuilder: transitionBuilder
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ThumbnailAnime(
                    image: anime.imgUrl,
                    width: double.infinity,
                    height: 165,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: Text(
                      anime.title,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 11.sp,
                        color: Theme.of(context).colorScheme.onSurface
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text(
                      'Ep: ${anime.currentEpisode}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 9.sp,
                        color: Theme.of(context).colorScheme.onSurface
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

