import 'package:flutter/material.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';

class GenericShimmerPage extends StatelessWidget {
  const GenericShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ShimmerBox(height: 14, width: 170),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10),),
        const Divider(
          color: AppColors.purple,
          endIndent: 20,
          indent: 20,
          thickness: 2,
          height: 0,
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            crossAxisCount: 2,
            childAspectRatio: 155/225,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: const [
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
              ShimmerBox(height: 225, width: 155),
            ],
          ),
        )
      ],
    );
  }
}
