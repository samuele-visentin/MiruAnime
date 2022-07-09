import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';

class ShimmerAnimePage extends StatelessWidget {
  const ShimmerAnimePage({ Key? key }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(height: 185, width: 135),
              Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  SizedBox(
                    width: 150,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: SizedBox(
                          width: 36,
                          child: Icon(
                            FontAwesomeIcons.circleXmark,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  const ShimmerBox(height: 20, width: 90),
                  const ShimmerBox(height: 20, width: 90)
                ],
              ),
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
      ),
    );
  }
}