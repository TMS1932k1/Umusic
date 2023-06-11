import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:path/path.dart';
import 'package:umusic/providers/play_song_provider.dart';
import 'package:umusic/providers/process_download_provider.dart';
import 'package:umusic/widgets/song_load_more_item.dart';

class PlaylistPage extends StatelessWidget {
  final List<Song>? songs;
  final List<File>? files;
  final Function()? onListenSelect;

  const PlaylistPage({
    this.songs,
    this.files,
    this.onListenSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (songs != null && songs!.isNotEmpty) {
      return _buildListSongs(songs!, onClickSelect: onListenSelect);
    }
    if (files != null && files!.isNotEmpty) {
      return _buildListFiles(files!, onClickSelect: onListenSelect);
    }
    return Center(
      child: Text(
        'Empty',
        style: textSmall.copyWith(
          color: colorGray,
        ),
      ),
    );
  }
}

Widget _buildListSongs(
  List<Song> songs, {
  Function()? onClickSelect,
}) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    padding: const EdgeInsets.only(top: kPandingMedium),
    child: ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final currentSong = Provider.of<PlaySongProvider>(context).currentSong;

        return ListTile(
          minVerticalPadding: 0,
          onTap: () {
            if (currentSong.id != songs[index].id) {
              Provider.of<PlaySongProvider>(context, listen: false)
                  .currentSong = songs[index];
              onClickSelect!();
            }
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(kRadiusSmall),
            child: FadeInImage(
              height: kSizeImageSmall,
              width: kSizeImageSmall,
              image: NetworkImage(songs[index].urlImage),
              placeholder: const AssetImage(
                'assets/images/placeholder_music.png',
              ),
              placeholderErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/placeholder_music.png');
              },
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            songs[index].name,
            style: textMedium.copyWith(
              color:
                  currentSong!.id == songs[index].id ? colorGray : colorWhite,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          subtitle: Text(
            '${songs[index].download} downloads',
            style: textSmall.copyWith(color: colorGray),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: currentSong.id == songs[index].id
              ? Text(
                  'Current',
                  style: textSmall.copyWith(color: colorGray),
                )
              : null,
        );
      },
    ),
  );
}

Widget _buildListFiles(
  List<File> files, {
  Function()? onClickSelect,
}) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    padding: const EdgeInsets.only(top: kPandingMedium),
    child: ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final currentFile = Provider.of<PlaySongProvider>(context).currentFile;

        return ListTile(
          onTap: () {
            if (currentFile.path != files[index].path) {
              Provider.of<PlaySongProvider>(context, listen: false)
                  .currentFile = files[index];
              onClickSelect!();
            }
          },
          leading: Container(
            padding: const EdgeInsets.all(kPandingSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              color: colorWhite,
            ),
            child: const FaIcon(
              FontAwesomeIcons.music,
              color: colorPurple,
              size: kSizeIconMedium,
            ),
          ),
          title: Text(
            basename(files[index].path),
            style: textSmall.copyWith(
              color: currentFile!.path == files[index].path
                  ? colorGray
                  : colorWhite,
            ),
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
          trailing: currentFile.path == files[index].path
              ? Text(
                  'Current',
                  style: textSmall.copyWith(color: colorGray),
                )
              : null,
        );
      },
    ),
  );
}
