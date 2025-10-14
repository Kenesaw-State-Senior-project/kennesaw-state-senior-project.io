import 'dart:convert';
import 'package:mobile_app/authorization.dart';

import '../models/artist.dart';
import '../models/track.dart';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String clientID;
  final String clientSecret;

  SpotifyApi(this.clientID, this.clientSecret);

  Future<String> _getAccessToken() async {
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

  Future<List<Artist>> searchArtist(String keyword) async {
    final token = await _getAccessToken();

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$keyword&type=artist'),
      headers: {'Authorization': 'Bearer $token'},
    );

    formatResponse(response);

    final data = json.decode(response.body);
    final List<dynamic> items = data['artists']['items'];
    return items.map((e) => Artist.fromJson(e)).toList();
  }

  Future<List<Track>> getTopTracks(String artistID) async {
    final token = await getAccessToken();

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/artists/$artistID/top-tracks?country=ID',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = json.decode(response.body);
    final List<dynamic> items = data['tracks'];
    return items.map((e) => Track.fromJson(e)).toList();
  }

  formatResponse(final response) {
    if (response.statusCode == 200) {
      // Decode JSON
      Map<String, dynamic> data = json.decode(response.body);

      // Process search results from JSON response
      print("Search Successful: $data");

      final List<String> artistNames = [];

      if (data['artists'] != null && data['artists']['items'] != null) {
        final List<dynamic> items = data['artists']['items'];
        for (var artist in items) {
          if (artist is Map<String, dynamic> && artist['name'] != null) {
            artistNames.add(artist['name']);
          }
        }
      }

      String name = "";
      int count = 0;
      for (name in artistNames) {
        count += 1;
        print("Artist $count: $name");
      }

      /*
      // Extract Artist(s)
      List<dynamic> artists = data['artists'];
      List<String> artistName = artists
          .map((artist) => artist['name'] as String)
          .toList();
      String artistSTR = artistName.join(', ');

      // Extract album art (ex. the largets image)
      List<dynamic> albumImages = data['album']['images'];
      String? albumArtURL;
      if (albumImages.isNotEmpty) {
        albumArtURL = albumImages[0]['url'];
      }

      print('Track Name: $track');
      print('Artist(s): $artistSTR');
      if (albumArtURL != null) {
        print('Album Art URL: $albumArtURL');
      }*/
    } else {
      throw Exception('Failed to load search results: ${response.statusCode}');
    }  
  }
}
