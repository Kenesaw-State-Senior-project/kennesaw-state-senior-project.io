import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authorization.dart';

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
          // Trigger Search when user presses enter
          print('Submitted search query: $query');
        },
      ),
    );
  }

  // After Authentication
  Future<Map<String, dynamic>> searchSpotify(String query) async {
    final url = Uri.https('api.spotify.com', '/v1/search', {
      'q': query,
      'type': 'track, artist, album',
    });
    final String accessToken =
        getAccessToken() as String; // Replace with authentication key
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Process search results from JSON response
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load search results: ${response.statusCode}');
    }
  }
}
