import 'package:flutter/cupertino.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/screens/play_song_screen.dart';
import 'package:umusic/widgets/song_load_more_item.dart';

class SongLoadMore extends StatelessWidget {
  final List<Song> songs;
  final ScrollController? controller;
  final bool isMax;

  const SongLoadMore(
    this.songs,
    this.isMax, {
    this.controller,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: kPandingSmall),
      controller: controller == null || isMax ? null : controller,
      itemBuilder: (context, index) {
        if (index == songs.length) {
          return const CupertinoActivityIndicator();
        }

        return SongLoadMoreItem(
          songs[index],
          onClick: (song) => gotoPlaySongScreen(
            context,
            song,
          ),
        );
      },
      itemCount: isMax ? songs.length : songs.length + 1,
    );
  }
}
