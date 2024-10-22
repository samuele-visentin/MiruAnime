import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_title_anime.dart';

class ThumbnailBottomBadge extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String link;
  final String badge;
  final double width;
  final double height;

  const ThumbnailBottomBadge({
    super.key,
    required this.badge,
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
          left: 0,
          top: 163,
          child: Container(
            width: 60,
            height: 22,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8)
                ),
                gradient: LinearGradient(
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
                badge,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
