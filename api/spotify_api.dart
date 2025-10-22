import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/artist.dart';
import '../models/track.dart';

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

    if (response.statusCode != 200) {
      throw Exception('Failed to get access token: ${response.statusCode}');
    }

    final body = json.decode(response.body);
    return body['access_token'];
  }

  Future<List<Artist>> searchArtist(String keyword) async {
    final token = await _getAccessToken();

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(keyword)}&type=artist',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search artists: ${response.statusCode}');
    }

    formatArtistResponse(response);

    final data = json.decode(response.body);
    final List<dynamic> items = data['artists']['items'];
    return items.map((e) => Artist.fromJson(e)).toList();
  }

  Future<List<Track>> searchTrack(String keyword) async {
    final token = await _getAccessToken();

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(keyword)}&type=track',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search tracks: ${response.statusCode}');
    }

    formatTrackResponse(response);

    final data = json.decode(response.body);
    final List<dynamic> items = data['tracks']['items'];
    return items.map((e) => Track.fromJson(e)).toList();
  }

  Future<List<Track>> getTopTracks(String artistID) async {
    final token = await _getAccessToken();

    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/artists/$artistID/top-tracks?country=US',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get top tracks: ${response.statusCode}');
    }

    formatTrackResponse(response);

    final data = json.decode(response.body);
    final List<dynamic> items = data['tracks'];
    return items.map((e) => Track.fromJson(e)).toList();
  }

  void formatArtistResponse(http.Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      final List<String> artistNames = [];

      if (data['artists'] != null && data['artists']['items'] != null) {
        final List<dynamic> items = data['artists']['items'];
        for (var artist in items) {
          if (artist is Map<String, dynamic> && artist['name'] != null) {
            artistNames.add(artist['name']);
          }
        }
      }

      for (int count = 0; count < artistNames.length; count++) {
        print("Artist ${count + 1}: ${artistNames[count]}");
      }
    } else {
      print('Failed to load artist search results: ${response.statusCode}');
    }
  }

  void formatTrackResponse(http.Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      final List<String> trackNames = [];

      if (data['tracks'] != null && data['tracks']['items'] != null) {
        final List<dynamic> items = data['tracks']['items'];
        for (var track in items) {
          if (track is Map<String, dynamic> && track['name'] != null) {
            trackNames.add(track['name']);
          }
        }
      }

      for (int count = 0; count < trackNames.length; count++) {
        print("Track ${count + 1}: ${trackNames[count]}");
      }
    } else {
      print('Failed to load track search results: ${response.statusCode}');
    }
  }

  Future<String?> getArtistIdDirect(String artistName) async {
    final token = await _getAccessToken();
    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(artistName)}&type=artist&limit=1',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['artists'] != null && data['artists']['items'].isNotEmpty) {
        return data['artists']['items'][0]['id'];
      }
      return null;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
