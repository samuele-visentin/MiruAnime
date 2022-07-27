import 'package:dio/dio.dart';
import 'package:miru_anime/backend/database/app_settings.dart';
import 'package:miru_anime/backend/models/anime_cast.dart';
import 'package:miru_anime/backend/sites/anilist/anilist_client.dart';
import 'package:miru_anime/backend/sites/anilist/anilist_status.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class Anilist {
  static var isLogged = false;
  static const _secret = '';
  static const _id = '';
  static const _url = 'https://graphql.anilist.co/';
  final _dio = Dio();

  static Future<void> getSetting() async {
    isLogged = await AppSettings.readBool(AppSettings.anilistSetting);
  }

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
        //redirectUri: 'miruanime://oauth',
        customUriScheme: 'miruanime'
    );
    return OAuth2Helper(
      client,
      clientId: _id,
      grantType: OAuth2Helper.IMPLICIT_GRANT,
      clientSecret: _secret,
      enablePKCE: false,
      enableState: true,
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
    mutation ($mediaId: Int) {
      SaveMediaListEntry (mediaId: $mediaId) {
        id
      }
    }
    ''';
    var variables = <String, dynamic>{
      'mediaId': id,
    };
    final json = await request(query, variables);
    const query2 = r'''
    mutation ($id: Int, $status: MediaListStatus, $progress: Int) {
      SaveMediaListEntry (id: $id, status: $status, progress: $progress) {
        id
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

  Future<List<AnimeCast>> getCastAnime(String? id) async {
    id = Uri.tryParse(id ?? '')?.pathSegments.last;
    if(id == null) {
      return <AnimeCast>[];
    }
    const query = r'''
    query($id: Int, $page: Int) {
      Media(id: $id) {
        characters(page: $page, perPage: 25, sort: FAVOURITES_DESC) {
          pageInfo {
            hasNextPage
          }
          edges { 
            node { 
              name {
                full
              }
              image {
                large
              }
            }
            role
          }
        }
      }
    }
    ''';
    final listCast = <AnimeCast>[];
    var page = 1;
    Map<String, dynamic> json;
    do {
      json = (await _dio.post(_url,
          options: Options(
              headers: {
                Headers.contentTypeHeader: 'application/json',
                Headers.acceptHeader: 'application/json',
              }),
          data: FormData.fromMap({
            'query': query,
            'variables': {
              'id': id,
              'page' : page++
            }
          })
      )).data;
      for (final Map<String,dynamic> edges in json['data']['Media']['characters']['edges']) {
        listCast.add(
            AnimeCast(
                animeCharImg: edges['node']['image']['large'],
                animeCharName: edges['node']['name']['full'],
                role: edges['role']
            )
        );
      }
    } while(json['data']['Media']['characters']['pageInfo']['hasNextPage']);
    return listCast;
  }
}
