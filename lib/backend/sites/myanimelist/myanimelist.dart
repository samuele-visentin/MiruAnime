import 'package:dio/dio.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:miru_anime/backend/sites/myanimelist/mal_status.dart';
import 'package:miru_anime/backend/sites/myanimelist/myanimelist_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class MyAnimeList {
  final _dio = Dio();
  static var isLogged = false;
  static const _clientID = 'clientID';

  Future<OAuth2Helper> getHelper() async {
    final client = MyAnimeListClient(
        redirectUri: 'miruanime://oauth',
        customUriScheme: 'miruanime'
    );
    return OAuth2Helper(
      client,
      clientId: _clientID,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      authCodeParams: {
        'code_challenge_method' : 'plain'
      }
    );
  }

  Future<void> logIn() async {
    final helper = await getHelper();
    final token = await helper.getToken();
    if (token?.accessToken == null)
      throw Exception('Failed to get token');
    AppSettings.saveBool(AppSettings.malSetting, true);
    MyAnimeList.isLogged = true;
  }

  void logOut() async {
    final helper = await getHelper();
    helper.removeAllTokens();
    AppSettings.saveBool(AppSettings.anilistSetting, false);
    MyAnimeList.isLogged = false;
  }

  Future<String> getToken() async {
    final helper = await getHelper();
    return (await helper.getToken())!.accessToken!;
  }

  void updateUserList({
    required final String id,
    required final MalStatus status,
    final int? progress,
  }) async {
    final token = await getToken();
    var data = 'status=${status.value}';
    if(progress != null) data += '&num_watched_episodes=$progress';
    await _dio.put('https://api.myanimelist.net/v2/anime/$id/my_list_status',
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'application/x-www-form-urlencoded',
          Headers.acceptHeader: 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: data
    );
  }
}