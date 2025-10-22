//lib/widgets/track_list.dart - widget to display tracks with play buttons/ calls playTrack with Track object
import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/spotify_player.dart';

class TrackList extends StatelessWidget {
  final List<Track> tracks;

  const TrackList({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          leading: Image.network(
            track.imgURL,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.music_note),
          ),
          title: Text(track.name),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => SpotifyPlayer.playTrack(track),
          ),
        );
      },
    );
  }
}
