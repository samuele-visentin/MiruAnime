import 'package:miru_anime/app_theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {

  static const themeSetting = 'appTheme';
  static const anilistSetting = 'anilist';
  static const malSetting = 'mal';

  static void saveInt(final String key, final int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static void saveString(final String key, final String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static void saveBool(final String key, final bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<Object?> _readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<TypeTheme> initializeTheme() async {
    final data = await _readData(themeSetting) as int?;
    return data != null ? TypeTheme.values[data] : TypeTheme.purple;
  }


  static Future<bool> isLogged(final String setting) async {
    final data = await _readData(setting) as bool?;
    return data ?? false;
  }
}