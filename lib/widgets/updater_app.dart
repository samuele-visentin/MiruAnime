import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdaterWidget {
  static Widget androidAlertDialog(final BuildContext context) => AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    backgroundColor: AppColors.white,
    contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
    title: const Text(
      'Nuova versione disponibile!',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        letterSpacing: double.minPositive,
      ),
    ),
    content: const CupertinoScrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Scarica la nuova versione da GitHub e installala senza cancellare la versione corrente',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      TextButton(
        //highlightColor: alphaAccent,
        //splashColor: alphaAccent,
        child: const Text(
          'Apri GitHub',
          style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          launchUrlString('https://github.com/samuele-visentin/Flutter_MiruAnime/releases', mode: LaunchMode.externalApplication);
          Navigator.of(context).pop();
        },
      )
    ],
  );

  static Widget iosAlertDialog(final BuildContext context) => CupertinoAlertDialog(
    title: const Text(
      'Nuova versione disponibile!',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: double.minPositive,
      ),
    ),
    content: const CupertinoScrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Scarica la nuova versione da GitHub e installala senza cancellare la versione corrente',
            ),
          ],
        ),
      ),
    ),
    actions: [
      CupertinoDialogAction(
        isDefaultAction: true,
        child: const Text(
          'Apri GitHub',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white),
        ),
        onPressed: () {
          launchUrlString('https://github.com/samuele-visentin/Flutter_MiruAnime/releases', mode: LaunchMode.externalApplication);
          Navigator.of(context).pop();
        },
      )
    ],
  );
}