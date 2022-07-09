import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:http/http.dart' as http;

class AnilistClient extends OAuth2Client {

  AnilistClient({required String redirectUri, required String customUriScheme})
      : super(
      authorizeUrl: 'https://anilist.co/api/v2/oauth/authorize',
      tokenUrl: 'https://anilist.co/api/v2/oauth/authorize',
      redirectUri: redirectUri,
      customUriScheme: customUriScheme) {
    accessTokenRequestHeaders = {'Accept': 'application/json', 'Content-Type' : 'application/json'};
  }

  @override
  Future<AccessTokenResponse> getTokenWithImplicitGrantFlow(
      {required String clientId,
        List<String>? scopes,
        bool enableState = true,
        String? state,
        httpClient,
        BaseWebAuth? webAuthClient,
        Map<String, dynamic>? webAuthOpts}) async {
    httpClient ??= http.Client();
    webAuthClient ??= this.webAuthClient;

    final authorizeUrl = getAuthorizeUrl(
        clientId: clientId,
        responseType: 'token',
        scopes: scopes,
        enableState: enableState,
        state: state,
        redirectUri: null);

    // Present the dialog to the user
    final result = await webAuthClient.authenticate(
        url: authorizeUrl,
        callbackUrlScheme: customUriScheme,
        redirectUrl: redirectUri,
        opts: webAuthOpts);

    final fragment = Uri.splitQueryString(Uri.parse(result).fragment);

    return AccessTokenResponse.fromMap({
      'access_token': fragment['access_token'],
      'token_type': fragment['token_type'],
      'scope': fragment['scope'] ?? scopes,
      'expires_in': fragment['expires_in'],
      'http_status_code': 200
    });
  }
}