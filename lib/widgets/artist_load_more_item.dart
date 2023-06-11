import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/artist.dart';

class ArtistLoadMoreItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist)? onClick;

  const ArtistLoadMoreItem(
    this.artist, {
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kPandingSmall,
      ),
      child: ListTile(
        onTap: () => onClick!(artist),
        leading: FadeInImage(
          height: kSizeImageSmall,
          width: kSizeImageSmall,
          image: NetworkImage(artist.urlImage),
          placeholder: const AssetImage(
            'assets/images/placeholder_person.jpg',
          ),
          placeholderErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/placeholder_person.jpg');
          },
          fit: BoxFit.fill,
        ),
        title: Text(
          artist.name,
          style: textMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
