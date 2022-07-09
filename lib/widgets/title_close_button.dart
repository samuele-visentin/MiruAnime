import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TitleWithCloseButton extends StatelessWidget {
  final String text;
  const TitleWithCloseButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 25,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(
                    FontAwesomeIcons.circleXmark,
                    size: 18,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,)
            ),
          ],
        ),
      ),
    );
  }
}
