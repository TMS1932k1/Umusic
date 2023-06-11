import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String name;
  final String urlImage;
  final String urlExpand;
  final String urlSong;
  final List<String> idGenres;
  final List<String> idSingers;
  final DateTime release;
  final int view;
  final int download;

  Song(
    this.id,
    this.name,
    this.urlImage,
    this.urlExpand,
    this.urlSong,
    this.idGenres,
    this.idSingers,
    this.release,
    this.view,
    this.download,
  );

  Song.fromDataMap(this.id, Map<String, dynamic> map)
      : name = map['name'],
        urlImage = map['image'],
        urlSong = map['song'],
        idGenres = (map['genre'] as List)
            .map(
              (item) => item as String,
            )
            .toList(),
        idSingers = (map['singer'] as List)
            .map(
              (item) => item as String,
            )
            .toList(),
        release = (map['release'] as Timestamp).toDate(),
        view = map['view'],
        urlExpand = map['expand'],
        download = map['download'];
}
