// lib/models/playlist_node.dart -fixed and encapsulated Node class
class PlaylistNode<T> {
  T? value;
  PlaylistNode<T>? next;
  PlaylistNode<T>? previous;

  PlaylistNode(this.value) {
    next = null;
    previous = null;
  }
}
