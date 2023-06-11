import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/artist.dart';

class ArtistListItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist)? onClick;

  const ArtistListItem(
    this.artist, {
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick == null ? null : () => onClick!(artist),
      child: Container(
        margin: const EdgeInsets.only(right: kPandingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(kHeightItemArtist),
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/placeholder_person.jpg'),
                image: NetworkImage(artist.urlImage),
                fit: BoxFit.cover,
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/placeholder_person.jpg');
                },
                height: kHeightItemArtist,
                width: kHeightItemArtist,
              ),
            ),
            SizedBox(
              width: kHeightItemArtist,
              child: Text(
                artist.name,
                style: textSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
