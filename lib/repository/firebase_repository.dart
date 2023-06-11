import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/models/genre.dart';
import 'package:umusic/models/song.dart';

// Get songs (by name and start index) on cloudstore
// With optional param:
//   -- [String name] to filt of songs
//   -- [Song start] to get song after obj start
//   -- [int limit] to limit result
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getSongsWithName(
  String name, {
  Song? start,
  int? limit,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      // Get limit songs with name
      await FirebaseFirestore.instance
          .collection('musics')
          .where('name', isEqualTo: name)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      // Get all songs with name at start obj
      await FirebaseFirestore.instance
          .collection('musics')
          .where('name', isEqualTo: name)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (song == start) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      // Get limit songs whose field of name equal to name
      await FirebaseFirestore.instance
          .collection('musics')
          .where('name', isEqualTo: name)
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where('name', isEqualTo: name)
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      // Get all songs whose field of name equal to name
      await FirebaseFirestore.instance
          .collection('musics')
          .where('name', isEqualTo: name)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
          setIsMax!(true);
        },
      );
    }
  }

  return songs;
}

// Get popular songs (by views) on cloudstore
// With optional param:
//   -- [int limit] to limit result
//   -- [Song start] to get song after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getPopularSongs({
  int? limit,
  Song? start,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('view', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      // Get all songs with view at start obj
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('view', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('view', descending: true)
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('view', descending: true)
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      // Get all songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('view', descending: true)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return songs;
}

// Get lastest released songs (by release) on cloudstore
// With optional param:
//   -- [int limit] to limit result
//   -- [Song start] to get song after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getLastestSongs({
  int? limit,
  Song? start,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('release', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      // Get all songs with view at start obj
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('release', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('release', descending: true)
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('release', descending: true)
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      // Get all songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('release', descending: true)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return songs;
}

// Get most downloaded songs (by download) on cloudstore
// With optional param:
//   -- [int limit] to limit result
//   -- [Song start] to get song after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getMostDownloadSongs({
  int? limit,
  Song? start,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('download', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      // Get all songs with view at start obj
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('download', descending: true)
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      // Get limit songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('download', descending: true)
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('download', descending: true)
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      // Get all songs
      await FirebaseFirestore.instance
          .collection('musics')
          .orderBy('download', descending: true)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return songs;
}

// Get songs (by singer array) on cloudstore
// With optional param:
//   -- [String id] to contain in singer array
//   -- [int limit] to limit result
//   -- [Song start] to get song after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getSongsWithIdArtist(
  String id, {
  int? limit,
  Song? start,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'singer',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'singer',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'singer',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'singer',
            arrayContains: id,
          )
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'singer',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return songs;
}

// Get songs (by genre array) on cloudstore
// With optional param:
//   -- [String id] to contain in genre array
//   -- [int limit] to limit result
//   -- [Song start] to get song after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Song>> getSongsWithIdGenre(
  String id, {
  int? limit,
  Song? start,
  Function(bool)? setIsMax,
}) async {
  List<Song> songs = [];

  if (start != null) {
    if (limit != null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'genre',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              songs.add(song);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'genre',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final song = Song.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              songs.add(song);
            }
            // To get first item to add
            if (!isAdd && song.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'genre',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              songs.add(Song.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'genre',
            arrayContains: id,
          )
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      await FirebaseFirestore.instance
          .collection('musics')
          .where(
            'genre',
            arrayContains: id,
          )
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            songs.add(Song.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return songs;
}

// Get artists on cloudstore
// With optional param:
//   -- [int limit] to limit result
//   -- [Artist start] to get artist's point after obj start
//   -- [Function(bool) setIsMax] to set value isMax in provider
Future<List<Artist>> getArtists({
  int? limit,
  Artist? start,
  Function(bool)? setIsMax,
}) async {
  List<Artist> artists = [];

  if (start != null) {
    if (limit != null) {
      await FirebaseFirestore.instance.collection('singers').get().then(
        (value) {
          var isAdd = false; // value to check item which should be added
          var count = 0; // value to limit adding artist
          for (var doc in value.docs) {
            final artist = Artist.fromDataMap(doc.id, doc.data());
            if (isAdd && count <= limit) {
              artists.add(artist);
              count++;
              setIsMax!(true);
            } else if (isAdd && count > limit) {
              setIsMax!(false);
              break;
            }
            // To get first item to add
            if (!isAdd && artist.id == start.id) isAdd = true;
          }
        },
      );
    } else {
      await FirebaseFirestore.instance.collection('singers').get().then(
        (value) {
          var isAdd = false; // value to check item which should be added
          for (var doc in value.docs) {
            final artist = Artist.fromDataMap(doc.id, doc.data());
            if (isAdd) {
              artists.add(artist);
            }
            // To get first item to add
            if (!isAdd && artist.id == start.id) isAdd = true;
          }
          setIsMax!(true);
        },
      );
    }
  } else {
    if (limit != null && setIsMax != null) {
      await FirebaseFirestore.instance.collection('singers').get().then(
        (value) {
          var count = 0; // value to limit adding song
          for (var doc in value.docs) {
            count++;
            if (count <= limit) {
              artists.add(Artist.fromDataMap(doc.id, doc.data()));
              setIsMax(true);
            } else {
              setIsMax(false);
              break;
            }
          }
        },
      );
    } else if (limit != null && setIsMax == null) {
      await FirebaseFirestore.instance
          .collection('singers')
          .limit(limit)
          .get()
          .then(
        (value) {
          for (var doc in value.docs) {
            artists.add(Artist.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    } else {
      await FirebaseFirestore.instance.collection('singers').get().then(
        (value) {
          for (var doc in value.docs) {
            artists.add(Artist.fromDataMap(doc.id, doc.data()));
          }
        },
      );
    }
  }

  return artists;
}

// Get artists on cloudstore
// With optional param:
//   -- [int limit] to limit result
Future<List<Artist>> getArtistsOrderBySongs({int? limit}) async {
  List<Artist> artists = [];

  if (limit != null) {
    await FirebaseFirestore.instance
        .collection('singers')
        .orderBy('songs', descending: true)
        .limit(limit)
        .get()
        .then(
      (value) {
        for (var doc in value.docs) {
          artists.add(Artist.fromDataMap(doc.id, doc.data()));
        }
      },
    );
  } else {
    await FirebaseFirestore.instance
        .collection('singers')
        .orderBy('songs', descending: true)
        .get()
        .then(
      (value) {
        for (var doc in value.docs) {
          artists.add(Artist.fromDataMap(doc.id, doc.data()));
        }
      },
    );
  }

  return artists;
}

// Get all genres on cloudstore
Future<List<Genre>> getGenres() async {
  List<Genre> genres = [];
  await FirebaseFirestore.instance.collection('genres').get().then(
    (value) {
      for (var doc in value.docs) {
        genres.add(Genre.fromDataMap(doc.id, doc.data()));
      }
    },
  );

  return genres;
}

// Get artist with id doc
// With param:
//   -- [String id] to get condition in doc's field
Future<Artist?> getArtistWithId(String idArtist) async {
  return await FirebaseFirestore.instance
      .collection('singers')
      .doc(idArtist)
      .get()
      .then(
    (value) {
      if (value.data() == null) {
        return null;
      }
      return Artist.fromDataMap(
        idArtist,
        value.data()!,
      );
    },
  );
}

// Check in uid's collection has idSong
// If have return true else return false
// With params:
//   -- [String collectionId] id email
//   -- [String idSong] id song needed check
Future<bool> getIsBookmark(String collectionId, String idSong) async {
  var isBookmark = false;
  await FirebaseFirestore.instance
      .collection(collectionId)
      .doc(idSong)
      .get()
      .then(
    (value) {
      if (value.exists && value.data() != null && value.data()!['bookmark']) {
        isBookmark = true;
      } else {
        isBookmark = false;
      }
    },
  );
  return isBookmark;
}

// Add id song into doc user collection
// If add successfully return true else return false
// With params:
//   -- [String collectionId] id email
//   -- [String idSong] id song needed check
Future<bool> addSongBookmark(String collectionId, String idSong) async {
  var isAdded = false;
  await FirebaseFirestore.instance
      .collection(collectionId)
      .doc(idSong)
      .set({
        'bookmark': true,
      })
      .whenComplete(
        () => isAdded = true,
      )
      .onError(
        (error, stackTrace) => isAdded = false,
      );
  return isAdded;
}

// Del id song into doc user collection
// If del successfully return false else return true
// With params:
//   -- [String collectionId] id email
//   -- [String idSong] id song needed check
Future<bool> delSongBookmark(String collectionId, String idSong) async {
  var isAdded = true;
  await FirebaseFirestore.instance
      .collection(collectionId)
      .doc(idSong)
      .set({
        'bookmark': false,
      })
      .whenComplete(
        () => isAdded = false,
      )
      .onError(
        (error, stackTrace) => isAdded = true,
      );
  return isAdded;
}

// Get songs bookmarked in uid's collection
// With params:
//   -- [String collectionId] id email
Future<List<Song>> getBookmarkList(String collectionId) async {
  final List<Song> bookmarks = [];
  await FirebaseFirestore.instance
      .collection(collectionId)
      .where('bookmark', isEqualTo: true)
      .get()
      .then(
    (value) async {
      for (var doc in value.docs) {
        final song = await getSongById(doc.id);
        if (song != null) bookmarks.add(song);
      }
    },
  );
  return bookmarks;
}

// Get song by its id
// With params:
//  -- [String id] song's id
Future<Song?> getSongById(String id) async {
  Song? song;
  await FirebaseFirestore.instance.collection('musics').doc(id).get().then(
        (value) => song = Song.fromDataMap(id, value.data()!),
      );
  return song;
}

// Update count download of song
// With params:
//   -- [int countDownload] value need update
//   -- [String id] song's id need updated
Future<bool> updateDownloadCount(int countDownload, String id) async {
  bool isSuccess = false;
  await FirebaseFirestore.instance.collection('musics').doc(id).update(
    {'download': countDownload},
  ).whenComplete(() => isSuccess = true);
  return isSuccess;
}
