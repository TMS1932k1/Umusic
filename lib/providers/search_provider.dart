import 'package:flutter/material.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';

class SearchProvider with ChangeNotifier {
  String _name = '';
  Song? _lastSong;
  bool _isMax = false;

  bool get isMax => _isMax;

  set isMax(bool value) => _isMax = value;

  set name(String name) {
    _name = name;
  }

  set lastSong(Song? song) {
    _lastSong = song;
  }

  // Get search songs
  Future<List<Song>> fetchSearch() async {
    return await getSongsWithName(
      _name,
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more songs
  Future<List<Song>> fetchGetMore() async {
    return await getSongsWithName(
      _name,
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }
}
