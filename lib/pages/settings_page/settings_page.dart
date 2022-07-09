import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miru_anime/app_theme/theme.dart';
import 'package:miru_anime/backend/sites/anilist/anilist.dart';
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
  var anilistIsLogged = Anilist.isLogged;

  @override
  void initState() {
    super.initState();
    _typeTheme = Provider.of<AppTheme>(context, listen: false).type;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: SettingsPage.route,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UnderlineTitleWithCloseButton(text: 'Opzioni'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: _selectTheme(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: _cancelAllTask(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Visibility(
                  visible: !anilistIsLogged,
                  replacement: _anilistSignOut(),
                  child: _anilistLogIn(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _anilistSignOut() {
    return GestureDetector(
      onTap: () {
        Anilist().logOut();
        setState(() {
          anilistIsLogged = !anilistIsLogged;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 30,
        child: Text(
          'Sing Out Anilist',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _anilistLogIn() {
    return GestureDetector(
      onTap: () async {
        await Anilist().logIn();
        setState(() {
          anilistIsLogged = !anilistIsLogged;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 30,
        child: Text(
          'Log In Anilist',
          style: Theme.of(context).textTheme.bodyMedium,
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
