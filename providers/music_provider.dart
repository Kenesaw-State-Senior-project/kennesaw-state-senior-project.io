// lib/providers/music_provider.dart - Updated with Playlist integration
import 'package:flutter/material.dart';
import '../api/spotify_api.dart';
import '../models/artist.dart';
import '../models/track.dart';
import '../models/playlist.dart';

class MusicProvider with ChangeNotifier {
  final SpotifyApi spotifyAPI;

  MusicProvider(this.spotifyAPI);

  List<Artist> _artists = [];
  List<Track> _tracks = [];
  bool _isLoading = false;
  Playlist<Track> _currentPlaylist = Playlist<Track>('Current Playlist');

  List<Artist> get artists => _artists;
  List<Track> get tracks => _tracks;
  bool get isLoading => _isLoading;
  Playlist<Track> get currentPlaylist =>
      _currentPlaylist; // getter for playlist

  Future<void> searchArtist(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      _artists = await spotifyAPI.searchArtist(keyword);
    } catch (e) {
      print('Error searching artists: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchTrack(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tracks = await spotifyAPI.searchTrack(keyword);
    } catch (e) {
      print('Error searching tracks: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> topTracks(String artistID) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tracks = await spotifyAPI.getTopTracks(artistID);
    } catch (e) {
      print('Error getting top tracks: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  //add selected track to current playlist
  void addToPlaylist(Track track) {
    _currentPlaylist.addSong(track);
    notifyListeners();
    print(
      'Added "${track.name}" to playlist. Total songs: ${_currentPlaylist.length}',
    );
  }

  //remove track from current playlist
  void removeFromPlaylist(Track track) {
    _currentPlaylist.removeSong(track);
    notifyListeners();
    print(
      'Removed "${track.name}" from playlist. Total songs: ${_currentPlaylist.length}',
    );
  }

  // print/view current playlist
  void printCurrentPlaylist() {
    print('Playlist "${_currentPlaylist.name}":');
    _currentPlaylist.printPlaylist();
  }

  // clear current playlist
  void clearPlaylist() {
    _currentPlaylist.clear();
    notifyListeners();
  }

  Track traversePlaylist(int index) {
    return currentPlaylist.getTrack(index);
  }
  
}
