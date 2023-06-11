import 'package:flutter/material.dart';
import 'package:umusic/constants/app_constant.dart';

class DiskPlaying extends StatelessWidget {
  final String? urlImage;
  final double size;
  final Animation<double> animation;

  const DiskPlaying(
    this.urlImage,
    this.size,
    this.animation, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: urlImage != null
            ? FadeInImage(
                placeholder: const AssetImage(
                  'assets/images/placeholder_music.png',
                ),
                image: NetworkImage(urlImage!),
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder_music.png',
                  );
                },
                fit: BoxFit.fill,
                height: size,
                width: size,
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                ),
                height: size,
                width: size,
                child: Image.asset(imageSongPlaceholder),
              ),
      ),
    );
  }
}
