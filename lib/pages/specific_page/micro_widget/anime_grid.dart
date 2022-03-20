import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/models/anime.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';

class AnimeGridView extends StatelessWidget {
  final List<Anime> listAnime;
  const AnimeGridView({Key? key, required this.listAnime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(listAnime.isEmpty){
      return const Center(
        child: Text('Nessun anime', style: TextStyle(fontSize: 18)),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
      child: CupertinoScrollbar(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemCount: listAnime.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 155/210,
              mainAxisSpacing: 15, crossAxisSpacing: 15
          ),
          itemBuilder: (final context, final index) {
            final anime = listAnime[index];
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
                      height: 210,
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
    );
  }
}
