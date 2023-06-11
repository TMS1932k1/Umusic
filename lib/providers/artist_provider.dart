import 'package:flutter/material.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/repository/firebase_repository.dart';

class ArtistProvider with ChangeNotifier {
  Artist? _lastArtist;
  bool _isMax = false;

  bool get isMax => _isMax;

  set isMax(bool value) => _isMax = value;

  set lastArtist(Artist? artist) {
    _lastArtist = artist;
  }

  // Get artists
  Future<List<Artist>> fetchArtist() async {
    return await getArtists(
      limit: 12,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }

  // Get more artists
  Future<List<Artist>> fetchGetMoreArtist() async {
    return await getArtists(
      limit: 10,
      start: _lastArtist,
      setIsMax: (isMax) {
        _isMax = isMax;
      },
    );
  }
}
