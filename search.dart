import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/artist.dart';
import 'dart:convert';
import 'api/spotify_api.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for Songs, Artists, or Albums',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onChanged: (query) {
          // Search Logic (Call Spotify API)
          print('Search query: $query');
        },
        onSubmitted: (query) {
              searchSpotify(
                    query,
                    'b006b52f30d74faca0a2f9ba67ada433',
                    'c54f7757c3a64b5792cc276a77e81b5b',
                  );

          print('Submitted search query: $query');

          //formatResponse(jsonDecode(query));
        },
      ),
    );
  }

  // After Authentication
  Future<Future<List<Artist>>> searchSpotify(
    String query,
    String clientID,
    String clientSecret,
  ) async {
    final api = SpotifyApi(clientID, clientSecret);
    final url = Uri.https('api.spotify.com', '/v1/search', {
      'q': query,
      'type': 'track, artist, album',
    });

    return api.searchArtist(query);
  }

  formatResponse(Map<String, dynamic> data) {
    //Extract track name
    String trackName = data['name'];

    // Extract artist name/s
    List<dynamic> artists = data['artists'];
    List<String> artistNames = artists
        .map((artist) => artist['name'] as String)
        .toList();
    String artistSTR = artistNames.join(', ');

    // Extract album art (ex. the largest image)
    List<dynamic> albumImages = data['album']['images'];
    String? albumArtURL;
    if (albumImages.isNotEmpty) {
      albumArtURL = albumImages[0]['url'];
    }

    print('Track Name: $trackName');
    print('Artist(s): $artistSTR');
    if (albumArtURL != null) {
      print('Album Art URL: $albumArtURL');
    }
  }
}
