import 'package:dio/dio.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:miru_anime/backend/sites/anilist/anilist_client.dart';
import 'package:miru_anime/backend/sites/anilist/anilist_status.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class Anilist {
  static var isLogged = false;
  static const _secret = '';
  static const _id = '';
  static const _url = 'https://graphql.anilist.co/';
  final _dio = Dio();

  Future<Map<String, dynamic>> request(final String query,
      final Map<String, dynamic> variables) async {
    final token = await getToken();
    final request = await _dio.post(_url,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
        data: FormData.fromMap({
          'query': query,
          'variables': variables
        })
    );
    return request.data;
  }

  Future<OAuth2Helper> getHelper() async {
    final client = AnilistClient(
        redirectUri: 'miruanime://oauth',
        customUriScheme: 'miruanime'
    );
    return OAuth2Helper(
      client,
      clientId: _id,
      grantType: OAuth2Helper.IMPLICIT_GRANT,
      clientSecret: _secret,
      enablePKCE: false,
      enableState: true
    );
  }

  Future<void> logIn() async {
    final helper = await getHelper();
    final token = await helper.getToken();
    if (token?.accessToken == null)
      throw Exception('Failed to get token');
    Anilist.isLogged = true;
    AppSettings.saveBool(AppSettings.anilistSetting, true);
  }

  void logOut() async {
    final helper = await getHelper();
    helper.removeAllTokens();
    AppSettings.saveBool(AppSettings.anilistSetting, false);
    Anilist.isLogged = false;
  }

  Future<String> getToken() async {
    final helper = await getHelper();
    return (await helper.getToken())!.accessToken!;
  }

  void updateUserDataAnimeStatus({
    required final String id,
    required final AnilistStatus status,
    final int? progress,
  }) async {
    const query = r'''
    mutation ($mediaId: Int, $status: MediaListStatus) {
      SaveMediaListEntry (mediaId: $mediaId, status: $status) {
        id
      }
    }
    ''';
    var variables = <String, dynamic>{
      'mediaId': id,
      'status': 'CURRENT',
    };
    final json = await request(query, variables);
    const query2 = r'''
    mutation ($id: Int, $status: MediaListStatus, $progress: Int) {
      SaveMediaListEntry (id: $id, status: $status, progress: $progress) {
        id
        status
        progress
      }
    }
    ''';
    variables = {
      'id': json['data']['SaveMediaListEntry']['id'],
      'status': status.value,
    };
    if(progress != null) variables['progress'] = progress;
    await request(query2, variables);
  }
}
