import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/providers/device_provider.dart';
import 'package:umusic/providers/process_download_provider.dart';

class SongLoadMoreItem extends StatelessWidget {
  final Song song;
  final Function(Song)? onClick;

  const SongLoadMoreItem(
    this.song, {
    this.onClick,
    super.key,
  });

  void downloadSong(BuildContext context, Song song) async {
    await Provider.of<ProcessDownloadProvider>(context, listen: false)
        .downloadSong(song);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPandingSmall),
      child: ListTile(
        minVerticalPadding: 0,
        onTap: onClick == null ? null : () => onClick!(song),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(kRadiusSmall),
          child: FadeInImage(
            height: kSizeImageSmall,
            width: kSizeImageSmall,
            image: NetworkImage(song.urlImage),
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
          song.name,
          style: textMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        subtitle: Text(
          '${song.download} downloads',
          style: textSmall.copyWith(color: colorGray),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return Consumer<ProcessDownloadProvider>(
              builder: (context, value, _) {
                return IconButton(
                  onPressed: value.song != null || !snapshot.hasData
                      ? null
                      : () => downloadSong(context, song),
                  icon: const FaIcon(
                    FontAwesomeIcons.download,
                  ),
                  iconSize: kSizeIconMedium,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
