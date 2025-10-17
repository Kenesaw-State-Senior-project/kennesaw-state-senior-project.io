import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/authorization.dart';
import 'package:mobile_app/models/artist.dart';
import 'package:mobile_app/models/track.dart';
import 'package:spotify_sdk/models/track.dart' hide Track;
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
          print('Submitted search query: $query');

          searchSpotifyArtists(
            query,
            'b006b52f30d74faca0a2f9ba67ada433',
            'c54f7757c3a64b5792cc276a77e81b5b',
          );

          searchSpotifyTracks(
            query,
            'b006b52f30d74faca0a2f9ba67ada433',
            'c54f7757c3a64b5792cc276a77e81b5b',
          );

          //formatResponse(jsonDecode(query));
        },
      ),
    );
  }

  // After Authentication
  Future<Future<List<Artist>>> searchSpotifyArtists(
    String query,
    String clientID,
    String clientSecret,
  ) async {
    final api = SpotifyApi(clientID, clientSecret);

    return api.searchArtist(query);
  }

  Future<Future<List<Track>>> searchSpotifyTracks(
    String query,
    String clientID,
    String clientSecret,
  ) async {
    final api = SpotifyApi(clientID, clientSecret);

    return api.searchTrack(query);
  }
}
