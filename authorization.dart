// updated authorization.dart - full updated version with web auth parsing
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

Future<void> connectToSpotify() async {
  if (!kIsWeb) return; // skips on non-web

  try {
    final String authorizeUrl =
        'https://accounts.spotify.com/authorize?client_id=cf72b6dcb97f43bfba40c07c968a429e'
        '&response_type=token'
        '&redirect_uri=http://127.0.0.1:8080'
        '&scope=user-read-private,user-read-email,playlist-read-private,user-read-currently-playing'
        '&state=flutter_web_state';

    final result = await FlutterWebAuth2.authenticate(
      url: authorizeUrl,
      callbackUrlScheme: 'http',
      options: const FlutterWebAuth2Options(timeout: 30),
    );
    print('Web Auth Result: $result');

    // parse token from #fragment
    final uri = Uri.parse(result);
    if (uri.fragment.isNotEmpty) {
      final fragmentParams = <String, String>{};
      for (final param in uri.fragment.split('&')) {
        final parts = param.split('=');
        if (parts.length == 2) {
          fragmentParams[Uri.decodeComponent(parts[0])] = Uri.decodeComponent(
            parts[1],
          );
        }
      }
      final accessToken = fragmentParams['access_token'];
      if (accessToken != null) {
        print('Web Auth Success - Token: $accessToken');
      } else {
        print('No token in #fragment: ${uri.fragment}');
      }
    }
  } catch (e) {
    print('Web auth error: $e');
  }
}

Future<String?> getAccessToken() async {
  if (kIsWeb) {
    await connectToSpotify(); // triggers auth if needed
    return null; // placeholder
  }
  return null;
}