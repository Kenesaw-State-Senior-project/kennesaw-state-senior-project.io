// New file: lib/services/spotify_player.dart - Handles Spotify playback using SDK
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/track.dart'; // For previewURL

class SpotifyPlayer {
  static bool _isInitialized = false;
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> initialize() async {
    if (kIsWeb) {
      print('Web: Using previews only—no SDK remote control');
      return;
    }
    if (!_isInitialized) {
      try {
        await SpotifySdk.connectToSpotifyRemote(
          clientId: 'cf72b6dcb97f43bfba40c07c968a429e',
          redirectUrl: 'http://127.0.0.1:8080',
        );
        _isInitialized = true;
      } on PlatformException catch (e) {
        print('SDK Init Error: ${e.message}');
      }
    }
  }

  static Future<void> playTrack(Track track) async {
    // takes Track for preview
    await initialize();
    if (kIsWeb || !_isInitialized) {
      // Web or init failed: Play preview
      if (track.previewURL.isNotEmpty) {
        try {
          await _audioPlayer.play(UrlSource(track.previewURL));
          print('Playing preview: ${track.name}');
        } catch (e) {
          print('Preview error: $e');
        }
      } else {
        print('No preview for ${track.name}');
      }
      return;
    }
    // mobile SDK playback
    try {
      await SpotifySdk.play(spotifyUri: track.uri);
      print('SDK Playing: ${track.uri}');
    } on PlatformException catch (e) {
      print('SDK Play Error: ${e.message}');
      // Fallback to preview
      if (track.previewURL.isNotEmpty) {
        await _audioPlayer.play(UrlSource(track.previewURL));
      }
    }
  }

  static Future<void> pause() async {
    if (kIsWeb) {
      await _audioPlayer.pause();
      return;
    }
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      print('Pause error: ${e.message}');
    }
  }

  static Future<void> resume() async {
    if (kIsWeb) {
      await _audioPlayer.resume();
      return;
    }
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      print('Resume error: ${e.message}');
    }
  }
}
