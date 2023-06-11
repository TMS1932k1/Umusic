import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/repository/firebase_repository.dart';

class ProcessDownloadProvider with ChangeNotifier {
  Song? _song;
  double _currentProcessDownload = 0.0;

  Song? get song => _song;

  double get currentProcessDownload => _currentProcessDownload;

  Future<bool> downloadSong(Song? song) async {
    _song = song;
    notifyListeners();
    await startDownload();
    return await updateDownloadCount(song!.download + 1, song.id);
  }

  Future<void> startDownload() async {
    Dio dio = Dio();
    String path = await getFilePath(song!.name);
    await dio.download(
      _song!.urlSong,
      path,
      onReceiveProgress: (count, total) {
        _currentProcessDownload = count / total;
        notifyListeners();
      },
      deleteOnError: true,
    ).then((value) {
      _song = null;
      _currentProcessDownload = 0;
      notifyListeners();
    });
  }

  Future<String> getFilePath(String nameFile) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/downloads/$nameFile.mp3';
  }
}
