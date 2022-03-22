import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/constants/app_colors.dart';

class TitleWithCloseButton extends StatelessWidget {
  final String text;
  const TitleWithCloseButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 25,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    FontAwesomeIcons.circleXmark,
                    size: 19,
                    color: AppColors.purple,
                  ),
                ),
              ),
              Text(text, style: Theme.of(context).textTheme.bodyText1,),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10),),
        const Divider(
          color: AppColors.purple,
          endIndent: 20,
          indent: 20,
          thickness: 1.5,
          height: 0,
        ),
      ],
    );
  }
}
