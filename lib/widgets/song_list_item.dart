import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/song.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final Function(Song)? onClick;

  const SongListItem(
    this.song, {
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick == null ? null : () => onClick!(song),
      child: Container(
        margin: const EdgeInsets.only(right: kPandingMedium),
        width: kSizeImageMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage(
              placeholder:
                  const AssetImage('assets/images/placeholder_music.png'),
              image: NetworkImage(song.urlImage),
              placeholderErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/placeholder_music.png');
              },
              height: kSizeImageMedium,
              width: kSizeImageMedium,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: kPandingSmall),
            Expanded(
              child: Text(
                song.name,
                style: textSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
