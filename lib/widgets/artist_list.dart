import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/widgets/artist_list_item.dart';

class ArtistList extends StatelessWidget {
  final List<Artist> artists;
  final Function(Artist)? onClickItem;

  const ArtistList(
    this.artists, {
    this.onClickItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeightArtistList,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: artists
              .map(
                (artist) => ArtistListItem(
                  artist,
                  onClick: onClickItem,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
