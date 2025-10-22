// updated search.dart - Integrated with MusicProvider for searchTrack
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/music_provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
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
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onChanged: (query) {
          print('Search query: $query');
        },
        onSubmitted: (query) {
          print('Submitted search query: $query');
          Provider.of<MusicProvider>(context, listen: false).searchTrack(query);
        },
      ),
    );
  }
}
