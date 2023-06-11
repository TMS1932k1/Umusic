import 'package:flutter/material.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/models/genre.dart';
import 'package:umusic/widgets/genre_list_item.dart';

class GenreList extends StatelessWidget {
  final List<Genre> genres;
  final Function(Genre)? onClickItem;

  const GenreList(
    this.genres, {
    this.onClickItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: genres
            .map(
              (genre) => GenreListItem(
                genre,
                linearGradient:
                    genreColors[genres.indexOf(genre) % genreColors.length],
                onClick: onClickItem,
              ),
            )
            .toList(),
      ),
    );
  }
}
