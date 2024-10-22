import 'package:oauth2_client/oauth2_client.dart';

class AnilistClient extends OAuth2Client {
  AnilistClient({required super.customUriScheme})
      : super(
      authorizeUrl: 'https://anilist.co/api/v2/oauth/authorize',
      tokenUrl: 'https://anilist.co/api/v2/oauth/authorize',
      redirectUri: '');
}