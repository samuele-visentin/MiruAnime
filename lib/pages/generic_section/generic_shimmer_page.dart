import 'package:flutter/material.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';

class GenericShimmerPage extends StatelessWidget {
  const GenericShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
    );
  }
}
