// lib/models/playlist_node.dart -fixed and encapsulated Node class
class PlaylistNode<Track> {
  Track? value;
  PlaylistNode<Track>? next;
  PlaylistNode<Track>? previous;

  PlaylistNode(this.value) {
    next = null;
    previous = null;
  }
}
