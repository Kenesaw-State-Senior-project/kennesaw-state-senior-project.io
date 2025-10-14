import 'package:flutter/material.dart';
import '../api/spotify_api.dart';
import '../models/artist.dart';
import '../models/track.dart';

class MusicProvider with ChangeNotifier {
  final SpotifyApi spotifyAPI;

  MusicProvider(this.spotifyAPI);

  List<Artist> _artists = [];
  List<Track> _tracks = [];
  bool _isLoading = false;

  List<Artist> get artists => _artists;
  List<Track> get tracks => _tracks;
  bool get isLoading => _isLoading;

  Future<void> searchArtist(String keyword) async {
    _isLoading = true;
    notifyListeners();

    _artists = await spotifyAPI.searchArtist(keyword);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> topTracks(String artistID) async {
    _isLoading = true;
    notifyListeners();

    _tracks = await spotifyAPI.getTopTracks(artistID);
    _isLoading = false;
    notifyListeners();
  }
}
