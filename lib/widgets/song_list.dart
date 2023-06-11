import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/widgets/song_list_item.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  final Function(Song)? onClickItem;

  const SongList(
    this.songs, {
    this.onClickItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeightSongListHorizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: songs
              .map(
                (song) => SongListItem(
                  song,
                  onClick: onClickItem,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
