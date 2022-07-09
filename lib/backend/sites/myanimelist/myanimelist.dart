import 'package:dio/dio.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:miru_anime/backend/sites/myanimelist/myanimelist_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class MyAnimeList {
  final _dio = Dio();
  static var isLogged = false;
  static const _clientID = '';

  void logIn() {
    final client = MyAnimeListClient(
        redirectUri: 'miruanime://oauth',
        customUriScheme: 'miruanime'
    );
    final helper = OAuth2Helper(
      client,
      clientId: _clientID,
      grantType: OAuth2Helper.IMPLICIT_GRANT,
    );
    helper.getToken();
    AppSettings.saveBool(AppSettings.malSetting, true);
    MyAnimeList.isLogged = true;
  }

}