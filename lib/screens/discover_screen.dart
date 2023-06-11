import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/models/genre.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/providers/discover_provider.dart';
import 'package:umusic/screens/artist_screen.dart';
import 'package:umusic/screens/play_song_screen.dart';
import 'package:umusic/screens/playlist_screen.dart';
import 'package:umusic/widgets/artist_list.dart';
import 'package:umusic/widgets/genre_list.dart';
import 'package:umusic/widgets/progress_loading.dart';
import 'package:umusic/widgets/section_bar.dart';
import 'package:umusic/widgets/song_list.dart';
import 'package:umusic/widgets/song_slider.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  // Go to playlist screen
  // With param:
  //   -- [BuildContext context] to provide to Navigator.of
  //   -- [TypePlaylist type] to get songs where or order by type
  void gotoPlaylistScreen(
    BuildContext context,
    TypePlaylist type, {
    Genre? genre,
    Artist? artist,
  }) {
    Navigator.of(context).pushNamed(
      PlaylistScreen.nameRoute,
      arguments: {
        'type': type,
        'genre': genre,
        'artist': artist,
      },
    );
  }

  // Go to play song screen
  // With param:
  //   -- [BuildContext context] to provide to Navigator.of
  //   -- [Song song] song item which on tapped
  void gotoPlaySongScreen(BuildContext context, Song song) {
    Navigator.of(context).pushNamed(
      PlaySongScreen.nameRoute,
      arguments: {'song': song},
    );
  }

  // Go to playlist screen
  // With param:
  //   -- [BuildContext context] to provide to Navigator.of
  void gotoArtistScreen(BuildContext context) {
    Navigator.of(context).pushNamed(ArtistScreen.nameRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kHeightAppBar + kPandingSmall,
        right: kPandingSmall,
        left: kPandingSmall,
        bottom: kBottomNavigationBarHeight,
      ),
      height: double.infinity,
      width: double.infinity,
      child: FutureBuilder(
        future: Provider.of<DiscoverProvider>(
          context,
          listen: false,
        ).fetchDataDiscover(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProgressLoading();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Show 10 popular songs
                SectionBar(
                  'POPULAR',
                  content: SongSlider(
                    Provider.of<DiscoverProvider>(
                      context,
                      listen: false,
                    ).popularSongs,
                    onClickItem: (song) => gotoPlaySongScreen(context, song),
                  ),
                  onClickMore: () => gotoPlaylistScreen(
                    context,
                    TypePlaylist.POPULAR,
                  ),
                ),
                const SizedBox(height: kPandingMedium),
                // Show all genres
                SectionBar(
                  'GENRES',
                  content: GenreList(
                    Provider.of<DiscoverProvider>(
                      context,
                      listen: false,
                    ).genres,
                    onClickItem: (genre) => gotoPlaylistScreen(
                      context,
                      TypePlaylist.GENRE,
                      genre: genre,
                    ),
                  ),
                ),
                // Show 10 released songs
                SectionBar(
                  'LASTEST RELEASED',
                  content: SongList(
                    Provider.of<DiscoverProvider>(
                      context,
                      listen: false,
                    ).lastestSongs,
                    onClickItem: (song) => gotoPlaySongScreen(context, song),
                  ),
                  onClickMore: () => gotoPlaylistScreen(
                    context,
                    TypePlaylist.RELEASE,
                  ),
                ),
                const SizedBox(height: kPandingMedium),
                // Show 10 artists order by count their songs
                SectionBar(
                  'ARTISTS',
                  content: ArtistList(
                    Provider.of<DiscoverProvider>(
                      context,
                      listen: false,
                    ).artists,
                    onClickItem: (artist) => gotoPlaylistScreen(
                      context,
                      TypePlaylist.ARTIST,
                      artist: artist,
                    ),
                  ),
                  onClickMore: () => gotoArtistScreen(context),
                ),
                const SizedBox(height: kPandingMedium),
                // Show 10 the most download songs
                SectionBar(
                  'MOST DOWNLOADED',
                  content: SongList(
                    Provider.of<DiscoverProvider>(
                      context,
                      listen: false,
                    ).downloadSongs,
                    onClickItem: (song) => gotoPlaySongScreen(context, song),
                  ),
                  onClickMore: () => gotoPlaylistScreen(
                    context,
                    TypePlaylist.DOWNLOAD,
                  ),
                ),
                const SizedBox(height: kPandingMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
