import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DeviceProvider with ChangeNotifier {
  List<File> _mp3Files = [];

  List<File> get mp3Files => [..._mp3Files];

  void removeFileInList(File file) {
    _mp3Files.removeWhere((element) => element == file);
    notifyListeners();
  }

  Future<void> getAllMp3() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/downloads/';
    _mp3Files.clear();

    Directory directory = Directory(path);
    if (await directory.exists()) {
      List<FileSystemEntity> files = directory.listSync(recursive: true);

      // Read all and filter by files '.mp3'
      for (FileSystemEntity file in files) {
        if (file.path.endsWith('.mp3')) {
          _mp3Files.add(File(file.path));
        }
      }
    }

    notifyListeners();
  }
}
