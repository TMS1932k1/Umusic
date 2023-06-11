import 'package:flutter/material.dart';
import 'package:umusic/constants/app_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/song.dart';

class SliderItem extends StatelessWidget {
  final Song song;
  final Function(Song)? onPressed;

  const SliderItem(
    this.song, {
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed == null ? null : () => onPressed!(song),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kRadiusMedium),
        child: FadeInImage(
          placeholder: const AssetImage(imageSongPlaceholder),
          image: NetworkImage(song.urlExpand),
          placeholderErrorBuilder: (context, error, stackTrace) {
            return Image.asset(imageSongPlaceholder);
          },
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
