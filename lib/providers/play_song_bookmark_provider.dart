import 'package:flutter/material.dart';
import 'package:umusic/repository/firebase_repository.dart';

class PlaySongBookMarkProvider with ChangeNotifier {
  bool _isBookmarked = false;

  bool get isBookmarked => _isBookmarked;

  Future<void> fetchGetIsBookmarked(String uidEmail, String idSong) async {
    _isBookmarked = await getIsBookmark(uidEmail, idSong);
  }

  Future<void> addBookmark(String uidEmail, String idSong) async {
    _isBookmarked = await addSongBookmark(uidEmail, idSong);
  }

  Future<void> delBookmark(String uidEmail, String idSong) async {
    _isBookmarked = await delSongBookmark(uidEmail, idSong);
  }
}
