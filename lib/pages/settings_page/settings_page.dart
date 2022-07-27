import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miru_anime/app_theme/theme.dart';
import 'package:miru_anime/backend/database/custom_player.dart';
import 'package:miru_anime/backend/sites/anilist/anilist.dart';
import 'package:miru_anime/backend/sites/myanimelist/myanimelist.dart';
import 'package:miru_anime/pages/settings_page/log_in_button.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_scaffold.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/setting_page';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TypeTheme _typeTheme;
  var _anilistIsLogged = Anilist.isLogged;
  var _malIsLogged = MyAnimeList.isLogged;
  var _player = CustomPlayer.player;

  @override
  void initState() {
    super.initState();
    _typeTheme = Provider.of<AppTheme>(context, listen: false).type;
  }

  @override
  Widget build(BuildContext context) {

    final selectPlayer = DropdownButton<Player>(
        value: _player,
        items: [
          DropdownMenuItem(
              value: Player.browser,
              child: Text('Browser', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium)
          ),
          DropdownMenuItem(
              value: Player.vlc,
              child: Text('VLC', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium)
          ),
          if(Platform.isIOS)
            DropdownMenuItem(
                value: Player.infuse,
                child: Text('Infuse', style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium)
          ),
        ],
        onChanged: (final value) {
          if (value == null) return;
          setState(() {
            _player = value;
          });
          CustomPlayer.saveSetting(value);
        }
    );

    final malButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Visibility(
        visible: !_malIsLogged,
        replacement: LogInButton(
          onTap: () {
            MyAnimeList().logOut();
            setState(() {
              _malIsLogged = false;
            });
          },
          imageAsset: 'MyAnimeList_Logo.png',
          text: 'MyAnimeList\nSign out',
        ),
        child: LogInButton(
          onTap: () async {
            try {
              await MyAnimeList().logIn();
            } catch(_) {
              Fluttertoast.showToast(
                  msg: 'Sign In non riuscito',
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_LONG
              );
              return;
            }
            setState(() {
              _malIsLogged = true;
            });
          },
          imageAsset: 'MyAnimeList_Logo.png',
          text: 'MyAnimeList\nSign In',
        ),
      ),
    );

    final anilistButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Visibility(
        visible: !_anilistIsLogged,
        replacement: LogInButton(
          onTap: () {
            Anilist().logOut();
            setState(() {
              _anilistIsLogged = false;
            });
          },
          imageAsset: 'AniList_logo.png',
          text: 'Anilist\nSign out',
        ),
        child: LogInButton(
          onTap: () async {
            try {
              await Anilist().logIn();
            } catch(_) {
              Fluttertoast.showToast(
                  msg: 'Sign In non riuscito',
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_LONG
              );
              return;
            }
            setState(() {
              _anilistIsLogged = true;
            });
          },
          imageAsset: 'AniList_logo.png',
          text: 'Anilist\nSign In',
        ),
      ),
    );

    return AppScaffold(
      route: SettingsPage.route,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UnderlineTitleWithCloseButton(text: 'Opzioni'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: _selectTheme(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: _cancelAllTask(),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                children: [
                  Text('Selezionare l\'applicazione esterna con cui aprire i video: ', style: Theme.of(context).textTheme.bodyMedium,),
                  selectPlayer
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            anilistButton,
            malButton
          ],
        ),
      ),
    );
  }


  Widget _cancelAllTask() {
    return GestureDetector(
      onTap: () {
        FlutterDownloader.cancelAll();
        Fluttertoast.showToast(
          msg: 'Tutti i download sono stati cancellati',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 30,
        child: Text(
          'Cancella tutti i download in corso',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _selectTheme() {
    return DropdownButton<TypeTheme>(
        value: _typeTheme,
        items: [
          DropdownMenuItem(
              value: TypeTheme.amoled,
              child: Text('OLED theme', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium)
          ),
          DropdownMenuItem(
              value: TypeTheme.purple,
              child: Text('Purple theme', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium)
          ),
          DropdownMenuItem(
              value: TypeTheme.light,
              child: Text('Light theme', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium)
          ),
        ],
        onChanged: (final value) {
          if (value == null) return;
          _typeTheme = value;
          if(value == TypeTheme.light)
            SystemChrome.setSystemUIOverlayStyle(statusBarLight);
          else
            SystemChrome.setSystemUIOverlayStyle(statusBarDark);
          Provider
              .of<AppTheme>(context, listen: false)
              .setTheme = value;
        }
    );
  }
}
