import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/models/genre.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/providers/playlist_provider.dart';
import 'package:umusic/screens/play_song_screen.dart';
import 'package:umusic/widgets/progress_loading.dart';
import 'package:umusic/widgets/song_load_more.dart';

enum TypePlaylist {
  POPULAR,
  RELEASE,
  DOWNLOAD,
  GENRE,
  ARTIST,
}

class PlaylistScreen extends StatefulWidget {
  static const nameRoute = '/playlist';

  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  TypePlaylist? type;
  Genre? genre;
  Artist? artist;
  bool isFirst = true;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).isMax) {
          getMoreSongs();
        }
      }
    });
  }

  // To fetch get playlist with type
  //   -- [BuildContext context] to provide to provider
  //   -- [TypePlaylist type] to switch futures get playlist of its
  Future<void> setDataSongs(BuildContext context) async {
    isFirst = false;
    Provider.of<PlaylistProvider>(context, listen: false).isMax = false;
    Provider.of<PlaylistProvider>(context, listen: false).lastSong = null;

    switch (type!) {
      case TypePlaylist.POPULAR:
        await Provider.of<PlaylistProvider>(context, listen: false)
            .fetchPopular();
        break;

      case TypePlaylist.RELEASE:
        await Provider.of<PlaylistProvider>(context, listen: false)
            .fetchLastest();
        break;

      case TypePlaylist.DOWNLOAD:
        await Provider.of<PlaylistProvider>(context, listen: false)
            .fetchDownload();
        break;
      case TypePlaylist.GENRE:
        await Provider.of<PlaylistProvider>(context, listen: false)
            .fetchGenre(genre!.id);
        break;
      case TypePlaylist.ARTIST:
        await Provider.of<PlaylistProvider>(context, listen: false)
            .fetchArtist(artist!.id);
        break;
    }
  }

  void getMoreSongs() async {
    Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).lastSong = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).playlist.last;

    List<Song> more = [];

    switch (type!) {
      case TypePlaylist.POPULAR:
        more = await Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).fetchGetMorePopular();
        break;

      case TypePlaylist.RELEASE:
        more = await Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).fetchGetMoreLastest();
        break;

      case TypePlaylist.DOWNLOAD:
        more = await Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).fetchGetMoreDownload();
        break;
      case TypePlaylist.GENRE:
        more = await Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).fetchGetMoreGenre(genre!.id);
        break;
      case TypePlaylist.ARTIST:
        more = await Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).fetchGetMoreArtist(artist!.id);
        break;
    }

    final tempPlaylist = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).playlist;
    tempPlaylist.addAll(more);

    setState(() {
      Provider.of<PlaylistProvider>(
        context,
        listen: false,
      ).playlist = tempPlaylist;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getTitle() {
    if (type == TypePlaylist.ARTIST) {
      return artist!.name;
    } else if (type == TypePlaylist.GENRE) {
      return genre!.name;
    } else {
      return type!.name;
    }
  }

  // Go to play song screen
  // With param:
  //   -- [BuildContext context] to provide to Navigator.of
  //   -- [List<Song> playlist] get all current songs look like a playlist
  void gotoPlaySongScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      PlaySongScreen.nameRoute,
      arguments: {
        'song': Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).playlist[0],
        'playlist': Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).playlist,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final mapArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    type = mapArg['type'] as TypePlaylist;

    // If type is genre or artist, need to get an argument to filter with its:
    // TypePlaylist.GENRE => get [genre]
    // TypePlaylist.ARTIST => get [artist]
    if (type == TypePlaylist.GENRE) {
      genre = mapArg['genre'] as Genre;
    } else if (type == TypePlaylist.ARTIST) {
      artist = mapArg['artist'] as Artist;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(),
          style: titleSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => gotoPlaySongScreen(context),
            child: Text(
              'Play all',
              style: titleSmall.copyWith(
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: kToolbarHeight + kPandingMedium,
          right: kPandingSmall,
          left: kPandingSmall,
          bottom: kPandingSmall,
        ),
        decoration: const BoxDecoration(
          gradient: gradientBackgroud,
        ),
        child: isFirst
            ? FutureBuilder(
                future: setDataSongs(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressLoading();
                  }

                  return Column(children: [
                    if (Provider.of<PlaylistProvider>(
                      context,
                      listen: false,
                    ).playlist.isNotEmpty)
                      Expanded(
                        child: SongLoadMore(
                          Provider.of<PlaylistProvider>(
                            context,
                            listen: false,
                          ).playlist,
                          Provider.of<PlaylistProvider>(
                            context,
                            listen: false,
                          ).isMax,
                          controller: _scrollController,
                        ),
                      ),
                  ]);
                },
              )
            : Column(
                children: [
                  if (Provider.of<PlaylistProvider>(
                    context,
                    listen: false,
                  ).playlist.isNotEmpty)
                    Expanded(
                      child: SongLoadMore(
                        Provider.of<PlaylistProvider>(
                          context,
                          listen: false,
                        ).playlist,
                        Provider.of<PlaylistProvider>(
                          context,
                          listen: false,
                        ).isMax,
                        controller: _scrollController,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
