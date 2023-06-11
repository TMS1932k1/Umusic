import 'package:flutter/foundation.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';
import 'package:umusic/screens/playlist_screen.dart';

class PlaylistProvider with ChangeNotifier {
  TypePlaylist? _type;
  Song? _lastSong;
  bool _isMax = false;
  List<Song> _playlist = [];

  bool get isMax => _isMax;

  List<Song> get playlist => [..._playlist];

  set type(TypePlaylist type) => _type = type;

  set isMax(bool value) => _isMax = value;

  set playlist(List<Song> playlist) {
    _playlist = playlist;
  }

  set lastSong(Song? song) {
    _lastSong = song;
  }

  // Get popular songs
  Future<void> fetchPopular() async {
    _playlist = await getPopularSongs(
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more popular songs
  Future<List<Song>> fetchGetMorePopular() async {
    return await getPopularSongs(
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get lastest songs
  Future<void> fetchLastest() async {
    _playlist = await getLastestSongs(
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more lastest songs
  Future<List<Song>> fetchGetMoreLastest() async {
    return await getLastestSongs(
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get most downloaded songs
  Future<void> fetchDownload() async {
    _playlist = await getMostDownloadSongs(
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more most downloaded songs
  Future<List<Song>> fetchGetMoreDownload() async {
    return await getMostDownloadSongs(
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get songs with id artist
  Future<void> fetchArtist(String idArtist) async {
    _playlist = await getSongsWithIdArtist(
      idArtist,
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more songs with id artist
  Future<List<Song>> fetchGetMoreArtist(String idArtist) async {
    return await getSongsWithIdArtist(
      idArtist,
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get songs with id artist
  Future<void> fetchGenre(String idGenre) async {
    _playlist = await getSongsWithIdGenre(
      idGenre,
      limit: 10,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more songs with id artist
  Future<List<Song>> fetchGetMoreGenre(String idGenre) async {
    return await getSongsWithIdGenre(
      idGenre,
      limit: 10,
      start: _lastSong,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }
}
