import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String clientID;
  final String clientSecret;

  SpotifyApi(this.clientID, this.clientSecret);

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientID:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    final body = json.decode(response.body);
    return body['access_token'];
  }
}
