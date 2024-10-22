import 'package:flutter/services.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';

import '../../globals/utils/random_string.dart';

class MyAnimeListClient extends OAuth2Client {

  MyAnimeListClient({required super.redirectUri, required super.customUriScheme})
      : super(
      authorizeUrl: 'https://myanimelist.net/v1/oauth2/authorize',
      tokenUrl: 'https://myanimelist.net/v1/oauth2/token',
      refreshUrl: 'https://myanimelist.net/v1/oauth2/token',
  );

  @override
  Future<AccessTokenResponse> getTokenWithAuthCodeFlow(
      {required String clientId,
        List<String>? scopes,
        String? clientSecret,
        bool enablePKCE = true,
        bool enableState = true,
        String? state,
        String? codeVerifier,
        Function? afterAuthorizationCodeCb,
        Map<String, dynamic>? authCodeParams,
        Map<String, dynamic>? accessTokenParams,
        Map<String, String>? accessTokenHeaders,
        httpClient,
        BaseWebAuth? webAuthClient,
        Map<String, dynamic>? webAuthOpts}) async {
    AccessTokenResponse? tknResp;

    String? codeChallenge;

    if (enablePKCE) {
      codeVerifier = randomString(43);
      codeChallenge = codeVerifier;
    }

    try {
      var authResp = await requestAuthorization(
          webAuthClient: webAuthClient,
          clientId: clientId,
          scopes: scopes,
          codeChallenge: codeChallenge,
          enableState: enableState,
          state: state,
          customParams: authCodeParams,
          webAuthOpts: webAuthOpts);

      if (authResp.isAccessGranted()) {
        if (afterAuthorizationCodeCb != null) {
          afterAuthorizationCodeCb(authResp);
        }

        tknResp = await requestAccessToken(
            httpClient: httpClient,
            //If the authorization request was successfull, the code must be set
            //otherwise an exception is raised in the OAuth2Response constructor
            code: authResp.code!,
            clientId: clientId,
            scopes: scopes,
            clientSecret: clientSecret,
            codeVerifier: codeVerifier,
            customParams: accessTokenParams,
            customHeaders: accessTokenHeaders);
      } else {
        tknResp = AccessTokenResponse.errorResponse();
      }
    } on PlatformException {
      tknResp = AccessTokenResponse.errorResponse();
    }
    return tknResp;
  }
}