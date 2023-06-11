import 'package:flutter/material.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';

class BookmarkProvider with ChangeNotifier {
  List<Song> _bookmarks = [];

  List<Song> get bookmark => [..._bookmarks];

  Future<void> fetchBookmarkList(String idEmail) async {
    _bookmarks = await getBookmarkList(idEmail);
  }
}
