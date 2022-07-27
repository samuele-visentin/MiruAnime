
import 'package:miru_anime/backend/database/app_settings.dart';

enum Player {
  browser,
  vlc,
  infuse
}

class CustomPlayer {
  static var player = Player.browser;

  static Future<void> getSetting() async {
    player = Player.values[(await AppSettings.readInt(AppSettings.playerSetting))];
  }

  static void saveSetting(final Player value) {
    player = value;
    AppSettings.saveInt(AppSettings.playerSetting, player.index);
  }
}