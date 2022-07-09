import 'package:oauth2_client/oauth2_client.dart';

class MyAnimeListClient extends OAuth2Client {

  MyAnimeListClient({required String redirectUri, required String customUriScheme})
      : super(
      authorizeUrl: 'https://myanimelist.net/v1/oauth2/authorize',
      tokenUrl: 'https://myanimelist.net/v1/oauth2/authorize',
      redirectUri: redirectUri,
      customUriScheme: customUriScheme) {
    accessTokenRequestHeaders = {'Accept': 'application/json', 'Content-Type' : 'application/json'};
  }
}