import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_title_anime.dart';

class ThumbnailWithBadge extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String link;
  final String rank;
  final double width;
  final double height;
  const ThumbnailWithBadge({
    super.key,
    required this.rank,
    required this.link,
    required this.thumbnail,
    required this.title,
    this.width = 125,
    this.height = 185
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThumbnailWithTitle(
          title: title,
          image: thumbnail,
          urlAnime: link,
          height: height,
          width: width,
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 33,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [
                  AppColors.darkBlue,
                  AppColors.darkPurple,
                  AppColors.purple,
                ],
                  stops: [
                    0.15,
                    0.65,
                    1
                  ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
            child: Center(
              child: Text(
                rank,
                style: Theme.of(context).textTheme.titleSmall!.apply(
                  color: AppColors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
