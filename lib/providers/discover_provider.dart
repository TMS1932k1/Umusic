import 'package:flutter/material.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/models/genre.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';

class DiscoverProvider with ChangeNotifier {
  List<Song> _popularSongs = [];
  List<Song> _lastestSongs = [];
  List<Song> _downloadSongs = [];
  List<Artist> _artists = [];
  List<Genre> _genres = [];

  List<Song> get popularSongs => [..._popularSongs];
  List<Song> get lastestSongs => [..._lastestSongs];
  List<Song> get downloadSongs => [..._downloadSongs];
  List<Artist> get artists => [..._artists];
  List<Genre> get genres => [..._genres];

  Future<void> fetchDataDiscover() async {
    _popularSongs = await getPopularSongs(limit: 10);
    _lastestSongs = await getLastestSongs(limit: 10);
    _downloadSongs = await getMostDownloadSongs(limit: 10);
    _artists = await getArtistsOrderBySongs(limit: 10);
    _genres = await getGenres();
    notifyListeners();
  }
}
