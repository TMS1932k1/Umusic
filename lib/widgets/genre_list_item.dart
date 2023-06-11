import 'package:flutter/material.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/genre.dart';

class GenreListItem extends StatelessWidget {
  final Genre genre;
  final LinearGradient? linearGradient;
  final Function(Genre)? onClick;

  const GenreListItem(
    this.genre, {
    this.linearGradient,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick == null ? null : () => onClick!(genre),
      child: Container(
        width: 100,
        height: 60,
        margin: const EdgeInsets.only(right: kPandingSmall),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kRadiusSmall),
          gradient: linearGradient ?? genreColors[0],
        ),
        child: Text(
          genre.name.toUpperCase(),
          style: titleSmall,
        ),
      ),
    );
  }
}
