import 'package:flutter/cupertino.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerBox({
    Key? key,
    required this.height,
    required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: _ShimmerBox(
              height: height,
              width: width,
            ),
          ),
        ),
        baseColor: const Color(0xff81858a),
        highlightColor: const Color(0xffeeeeee)
    );
  }
}


class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    Key? key,
    required this.height,
    required this.width,
    this.radius = 8
  }) : super(key: key);

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
