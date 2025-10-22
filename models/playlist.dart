// lib/models/playlist.dart
import 'package:mobile_app/models/playlist_node.dart';

class Playlist<T> {
  PlaylistNode<T>? head;
  PlaylistNode<T>? tail;
  String name = "";

  Playlist(this.name) {
    head = null;
    tail = null;
  }

  // adds a song/track to the end of the playlist
  void addSong(T track) {
    final newNode = PlaylistNode<T>(track);
    if (head == null) {
      head = newNode;
      tail = newNode;
    } else {
      tail!.next = newNode;
      newNode.previous = tail;
      tail = newNode;
    }
  }

  // removes the first occurrence of the song/track by value comparison
  void removeSong(T track) {
    if (head == null) return; // empty playlist

    PlaylistNode<T>? current = head;
    while (current != null && current.value != track) {
      current = current.next;
    }

    if (current == null) return; // track not found

    // found the node to remove
    if (current.previous != null) {
      current.previous!.next = current.next;
    } else {
      head = current.next;
    }

    if (current.next != null) {
      current.next!.previous = current.previous;
    } else {
      tail = current.previous;
    }
  }

  void printPlaylist() {
    PlaylistNode<T>? current = head;
    while (current != null) {
      print(current.value);
      current = current.next;
    }
  }

  int get length {
    int count = 0;
    PlaylistNode<T>? current = head;
    while (current != null) {
      count++;
      current = current.next;
    }
    return count;
  }

  void clear() {
    head = null;
    tail = null;
  }
}
