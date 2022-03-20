import 'package:flutter/material.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';

class ShimmerAnimePage extends StatelessWidget {
  const ShimmerAnimePage({ Key? key }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ShimmerBox(height: 185, width: 135),
            Column(
              children: const [
                ShimmerBox(height: 20, width: 90),
                ShimmerBox(height: 20, width: 90)
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ShimmerBox(height: 22, width: 110),
            ShimmerBox(height: 22, width: 110),
            ShimmerBox(height: 22, width: 110)
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const ShimmerBox(height: 15, width: 300),
        const Expanded(
          child: SizedBox()
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            ShimmerBox(height: 15, width: 200),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5))
      ],
    );
  }
}