import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/constants/app_colors.dart';

class ThumbnailAnime extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  const ThumbnailAnime({
    Key? key,
    required this.image,
    this.height = 225,
    this.width = 155
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: image,
        width: width,
        height: height,
        fadeInCurve: Curves.fastOutSlowIn,
        placeholder: (_, __) => Container(
          decoration: const BoxDecoration(
            color: Color(0xff212121),
          ),
          width: width,
          height: height,
        ),
        errorWidget: (_, __, ___) => const Icon(
          Icons.error,
          size: 22,
          color: AppColors.functionalred,
        ),
      ),
    );
  }
}
