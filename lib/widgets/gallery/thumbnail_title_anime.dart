import 'package:flutter/material.dart';
import 'package:miru_anime/pages/specific_page/specific_anime.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';

class ThumbnailWithTitle extends StatelessWidget {
  final String urlAnime;
  final String image;
  final String title;
  final double height;
  final double width;

  const ThumbnailWithTitle({
    Key? key,
    required this.title,
    required this.image,
    required this.urlAnime,
    this.height = 225,
    this.width = 155
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, //so if the user tab on empty field (like btw image and title) we also obtain the tap invoke
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_,__,___) => SpecificAnimePage(url: urlAnime),
            transitionsBuilder: transitionBuilder
          )
        );
      },
      onLongPress: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_,__,___) => ViewImage(url: image),
            transitionsBuilder: transitionBuilder
        ));
      },
      child: Column(
        children: [
          ThumbnailAnime(
            width: width,
            height: height,
            image: image,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          SizedBox(
            width: width,
            height: 35,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
