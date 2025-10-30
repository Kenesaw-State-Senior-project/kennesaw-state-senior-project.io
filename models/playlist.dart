// lib/models/playlist.dart
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/api/spotify_api.dart';
import 'package:mobile_app/models/playlist_node.dart';
import 'package:mobile_app/models/track.dart';
import 'package:mobile_app/providers/music_provider.dart';
import 'package:provider/provider.dart';

class Playlist<T> {
  PlaylistNode<T>? head;
  PlaylistNode<T>? tail;
  String name = "";
  List<Track> trackList = [];

  Playlist(this.name) {
    head = null;
    tail = null;
  }

  // adds a song/track to the end of the playlist
  void addSong(T track) {
    final newNode = PlaylistNode<T>(track);
    trackList.add(track as Track);
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
    trackList.remove(track);
  }

  void printPlaylist() {
    PlaylistNode<T>? current = head;
    int count = 0;
    while (current != null) {
      print(trackList[count].name);
      current = current.next;
      count += 1;
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

  Track getTrack(int index) {
    PlaylistNode<T>? current = head;
    for (int i = 0; i < index - 1; i++) {
      current = current?.next;
    }
    return current?.value as Track;
  }

  bool isEmpty() {
    if (trackList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
