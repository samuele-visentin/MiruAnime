import 'package:flutter/material.dart';
import 'package:miru_anime/widgets/title_close_button.dart';

class UnderlineTitleWithCloseButton extends StatelessWidget {
  final String text;
  final double indent;
  final double endIndent;
  const UnderlineTitleWithCloseButton({
    super.key,
    required this.text,
    this.endIndent = 20,
    this.indent = 20
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWithCloseButton(text: text),
        const Padding(padding: EdgeInsets.symmetric(vertical: 6),),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
          endIndent: endIndent,
          indent: indent,
          thickness: 1.5,
          height: 0,
        ),
      ],
    );
  }
}
