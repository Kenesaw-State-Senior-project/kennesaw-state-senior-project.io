import 'package:spotify_sdk/spotify_sdk.dart';

Future<void> connectToSpotify() async {
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
      clientId: 'b006b52f30d74faca0a2f9ba67ada433', 
      redirectUrl: 'https://127.0.0.1:4767',
      scope: 'user-read-private,user-read-email',
    );
    print(result ? "Connected to Spotify" : "Failed to Connect");
  } catch (e) {
    print("Error connecting to Spotify: $e");
  }
}

Future<String?> getAccessToken() async {
  try {
    var accessToken = await SpotifySdk.getAccessToken(
      clientId: 'b006b52f30d74faca0a2f9ba67ada433', 
      redirectUrl: 'https://127.0.0.1:4767',
      scope: 'user-read-private,user-read-email',
    );
    print("Access Token: $accessToken");
    return accessToken;
  } catch (e) {
    print("Error getting access token: $e");
    return null;
  }
}
