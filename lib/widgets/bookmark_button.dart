import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/providers/play_song_bookmark_provider.dart';
import 'package:umusic/widgets/progress_loading.dart';

class BookmarkButton extends StatefulWidget {
  final String uidEmail;
  final String idSong;

  const BookmarkButton(this.uidEmail, this.idSong, {super.key});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  var isLoading = false;

  void onClickBookmark(String uidEmail, String idSong) async {
    setState(() {
      isLoading = true;
    });

    if (!Provider.of<PlaySongBookMarkProvider>(context, listen: false)
        .isBookmarked) {
      await Provider.of<PlaySongBookMarkProvider>(context, listen: false)
          .addBookmark(
        uidEmail,
        idSong,
      );
    } else {
      await Provider.of<PlaySongBookMarkProvider>(context, listen: false)
          .delBookmark(
        uidEmail,
        idSong,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.all(kPandingSmall),
            child: ProgressLoading(),
          )
        : FutureBuilder(
            future: Provider.of<PlaySongBookMarkProvider>(context)
                .fetchGetIsBookmarked(widget.uidEmail, widget.idSong),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(kPandingSmall),
                  child: ProgressLoading(),
                );
              }

              return IconButton(
                onPressed: () => onClickBookmark(
                  widget.uidEmail,
                  widget.idSong,
                ),
                icon: Provider.of<PlaySongBookMarkProvider>(
                  context,
                  listen: false,
                ).isBookmarked
                    ? const FaIcon(
                        FontAwesomeIcons.solidBookmark,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.bookmark,
                      ),
                iconSize: kSizeIconMedium,
              );
            },
          );
  }
}
