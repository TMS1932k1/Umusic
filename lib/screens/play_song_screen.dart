import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/providers/play_song_provider.dart';
import 'package:umusic/providers/process_download_provider.dart';
import 'package:umusic/screens/control_playing_page.dart';
import 'package:umusic/screens/playlist_page.dart';
import 'package:umusic/widgets/bookmark_button.dart';
import 'package:umusic/widgets/process_downloading_bar.dart';
import 'package:path/path.dart';

class PlaySongScreen extends StatefulWidget {
  static const nameRoute = '/play_song';

  const PlaySongScreen({super.key});

  @override
  State<PlaySongScreen> createState() => _PlaySongScreenState();
}

class _PlaySongScreenState extends State<PlaySongScreen> {
  final _audioPlayer = AudioPlayer();
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Song? song;
    final List<Song>? playlist;
    final File? file;
    final List<File>? files;

    // Get args
    final mapArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    song = mapArg['song'] as Song?;
    playlist = mapArg['playlist'] as List<Song>?;

    file = mapArg['file'] as File?;
    files = mapArg['files'] as List<File>?;

    if (song != null) {
      // Set args into provider to can show display and fetch get song's artists
      Provider.of<PlaySongProvider>(context, listen: false).setDataWithSong(
        song,
        playlist,
      );
    }

    if (file != null) {
      // Set args into provider to can show display
      Provider.of<PlaySongProvider>(context, listen: false).setDataWithFile(
        file,
        files,
      );
    }

    void downloadSong(BuildContext context, Song song) async {
      await Provider.of<ProcessDownloadProvider>(context, listen: false)
          .downloadSong(song);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (song != null)
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // If logined will check bookmark
                  // To display add icon or del icon
                  return Consumer<PlaySongProvider>(
                    builder: (context, value, _) => BookmarkButton(
                      snapshot.data!.uid,
                      value.currentSong!.id,
                    ),
                  );
                } else {
                  // If don't login will go to auth screen
                  // To login before add bookmark
                  return const IconButton(
                    onPressed: null,
                    icon: FaIcon(
                      FontAwesomeIcons.bookmark,
                    ),
                    iconSize: kSizeIconMedium,
                  );
                }
              },
            ),
          if (song != null)
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return Consumer<ProcessDownloadProvider>(
                  builder: (context, value, _) {
                    return IconButton(
                      onPressed: value.song != null || !snapshot.hasData
                          ? null
                          : () => downloadSong(context, song!),
                      icon: const FaIcon(
                        FontAwesomeIcons.download,
                      ),
                      iconSize: kSizeIconMedium,
                    );
                  },
                );
              },
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
        child: Column(
          children: [
            const ProcessDownloadingBar(),
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  if (file != null)
                    Consumer<PlaySongProvider>(
                      builder: (context, value, _) => ControlPlayingPage(
                        _audioPlayer,
                      ),
                    ),
                  if (files != null && files.isNotEmpty)
                    PlaylistPage(
                      files: files,
                      onListenSelect: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                    ),
                  if (song != null)
                    _buildControlPageWithSongPlaying(context, _audioPlayer),
                  if (playlist != null && playlist.isNotEmpty)
                    PlaylistPage(
                      songs: playlist,
                      onListenSelect: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                    ),
                ],
                onPageChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildControlPageWithSongPlaying(
  BuildContext context,
  AudioPlayer audioPlayer,
) {
  return Consumer<PlaySongProvider>(
    builder: (context, value, _) => FutureBuilder(
      future: Provider.of<PlaySongProvider>(context, listen: false)
          .fetchGetArtists(),
      builder: (context, snapshot) {
        final song = Provider.of<PlaySongProvider>(
          context,
          listen: false,
        ).currentSong;

        final artists = Provider.of<PlaySongProvider>(
          context,
          listen: false,
        ).currentArtists;

        // Convert artists to String
        var stringArtist = '';
        for (var artist in artists) {
          stringArtist += artist.name;
          if (artists.indexOf(artist) < artists.length - 1) {
            stringArtist += ' x ';
          }
        }

        return ControlPlayingPage(
          audioPlayer,
          stringArtist: stringArtist,
        );
      },
    ),
  );
}
