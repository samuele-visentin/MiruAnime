import 'package:flutter/material.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/widgets/title_close_button.dart';

class UnderlineTitleWithCloseButton extends StatelessWidget {
  final String text;
  final double indent;
  final double endIndent;
  const UnderlineTitleWithCloseButton({
    Key? key,
    required this.text,
    this.endIndent = 20,
    this.indent = 20
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        TitleWithCloseButton(text: text),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10),),
        Divider(
          color: AppColors.purple,
          endIndent: endIndent,
          indent: indent,
          thickness: 1.5,
          height: 0,
        ),
      ],
    );
  }
}
