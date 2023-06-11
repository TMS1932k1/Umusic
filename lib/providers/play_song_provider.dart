import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';
import 'package:path/path.dart';

class PlaySongProvider with ChangeNotifier {
  Song? _currentSong;
  File? _currentFile;
  List<Artist> _currentArtists = [];
  List<Song> _playlist = [];
  List<File> _files = [];

  Song? get currentSong => _currentSong;
  File? get currentFile => _currentFile;
  List<Song> get playlist => _playlist;
  List<Artist> get currentArtists => [..._currentArtists];
  List<File> get files => [..._files];

  String? get urlImageSong =>
      _currentSong != null ? _currentSong!.urlImage : null;

  set currentFile(File? file) {
    _currentFile = file;
    notifyListeners();
  }

  set currentSong(Song? song) {
    _currentSong = song;
    notifyListeners();
  }

  set playlist(List<Song> playlist) {
    _playlist = playlist;
    notifyListeners();
  }

  set currentArtists(List<Artist> currentArtists) {
    _currentArtists = currentArtists;
    notifyListeners();
  }

  void setDataWithSong(Song song, List<Song>? playlist) {
    _currentSong = song;
    if (playlist != null) {
      _playlist = playlist;
    } else {
      _playlist.clear();
    }
    _currentFile = null;
    _files.clear();
  }

  void setDataWithFile(File file, List<File>? files) {
    _currentFile = file;
    if (files != null) {
      _files = files;
    } else {
      _files.clear();
    }
    _currentSong = null;
    _playlist.clear();
  }

  String? getUrlCurrent() {
    if (_currentFile != null) return _currentFile!.path;
    if (_currentSong != null) return _currentSong!.urlSong;
    return null;
  }

  String? getNameCurrent() {
    if (_currentFile != null) return basename(_currentFile!.path);
    if (_currentSong != null) return _currentSong!.name;
    return null;
  }

  void nextSong() {
    if (_currentSong != null && _playlist.isNotEmpty) {
      var currentIndex = _playlist.indexOf(_currentSong!);
      if (currentIndex++ < _playlist.length - 1) {
        _currentSong = _playlist[currentIndex];
      } else {
        _currentSong = _playlist[0];
      }
    }

    if (_currentFile != null && _files.isNotEmpty) {
      var currentIndex = _files.indexOf(_currentFile!);
      if (currentIndex++ < _files.length - 1) {
        _currentFile = _files[currentIndex];
      } else {
        _currentFile = _files[0];
      }
    }
    notifyListeners();
  }

  void backSong() {
    if (_currentSong != null && _playlist.isNotEmpty) {
      var currentIndex = _playlist.indexOf(_currentSong!);
      if (currentIndex-- > 0) {
        _currentSong = _playlist[currentIndex];
      } else {
        _currentSong = _playlist.last;
      }
    }

    if (_currentFile != null && _files.isNotEmpty) {
      var currentIndex = _files.indexOf(_currentFile!);
      if (currentIndex-- > 0) {
        _currentFile = _files[currentIndex];
      } else {
        _currentFile = _files.last;
      }
    }
    notifyListeners();
  }

  Future<void> fetchGetArtists() async {
    _currentArtists.clear();
    for (var id in _currentSong!.idSingers) {
      final artist = await getArtistWithId(id);
      if (artist != null) {
        _currentArtists.add(artist);
      }
    }
  }
}
