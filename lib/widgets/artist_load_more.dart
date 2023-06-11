import 'package:flutter/cupertino.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/screens/playlist_screen.dart';
import 'package:umusic/widgets/artist_load_more_item.dart';

class ArtistLoadMore extends StatelessWidget {
  final List<Artist> artists;
  final ScrollController? controller;
  final bool isMax;

  const ArtistLoadMore(
    this.artists,
    this.isMax, {
    this.controller,
    super.key,
  });

  void gotoPlaylistScreen(
    BuildContext context,
    Artist artist,
  ) {
    Navigator.of(context).pushNamed(
      PlaylistScreen.nameRoute,
      arguments: {
        'type': TypePlaylist.ARTIST,
        'artist': artist,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: kPandingSmall),
      controller: controller == null || isMax ? null : controller,
      itemBuilder: (context, index) {
        if (index == artists.length) {
          return const CupertinoActivityIndicator();
        }
        return ArtistLoadMoreItem(
          artists[index],
          onClick: (artist) => gotoPlaylistScreen(context, artist),
        );
      },
      itemCount: isMax ? artists.length : artists.length + 1,
    );
  }
}
