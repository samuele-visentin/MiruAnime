import 'package:flutter/cupertino.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xff81858a),
        highlightColor: const Color(0xffeeeeee),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: _ShimmerBox(
              height: height,
              width: width,
              radius: radius,
            ),
          ),
        )
    );
  }
}


class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.height,
    required this.width,
    this.radius = 8
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColors.grey
      ),
    );
  }
}
