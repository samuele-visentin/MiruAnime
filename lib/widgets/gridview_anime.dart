import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import '../app_theme/app_colors.dart';
import '../backend/models/anime.dart';
import '../pages/specific_page/specific_anime.dart';
import '../utils/transition.dart';
import 'gallery/fullscreen_image.dart';
import 'gallery/thumbnail_anime.dart';

class GridViewAnime extends StatelessWidget {
  final List<Anime> animeList;
  final ScrollController? controller;
  final double width;
  final double height;
  final bool shinkWrap;
  final ScrollPhysics? scrollPhysics;

  const GridViewAnime({
    Key? key,
    required this.animeList,
    this.controller,
    this.width = 155,
    this.height = 225,
    this.shinkWrap = false,
    this.scrollPhysics = const BouncingScrollPhysics()
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(animeList.isEmpty){
      return Center(
        child: Text('Nessun anime', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: CupertinoScrollbar(
        controller: controller,
        child: GridView.builder(
            controller: controller,
            physics: scrollPhysics,
            shrinkWrap: shinkWrap,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemCount: animeList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: width/height,
                mainAxisSpacing: 25, crossAxisSpacing: 20
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
                onLongPress: (){
                  Navigator.of(context).push(
                      PageRouteBuilder(
                          pageBuilder: (_,__,___) => ViewImage(url: anime.thumbnail),
                          transitionsBuilder: transitionBuilder
                      ));
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
                            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: ThumbnailAnime(
                        height: double.infinity,
                        width: double.infinity,
                        image: anime.thumbnail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        anime.title,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.sp,
                          letterSpacing: 0.4,
                          color: AppColors.white
                        ),
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
    );
  }
}
