import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/providers/bookmark_provider.dart';
import 'package:umusic/screens/auth_screen.dart';
import 'package:umusic/widgets/progress_loading.dart';
import 'package:umusic/widgets/song_load_more.dart';

class BookmartScreen extends StatelessWidget {
  const BookmartScreen({super.key});

  // Go to auth screen to login account
  // With param:
  //   -- [BuildContext context] to provide to Navigator.of(...)
  void gotoAuthScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AuthScreen.nameRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kHeightAppBar + kPandingSmall,
        bottom: kBottomNavigationBarHeight,
      ),
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If logined
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                    FirebaseAuth.instance.currentUser!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: Provider.of<BookmarkProvider>(
                    context,
                    listen: false,
                  ).fetchBookmarkList(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ProgressLoading();
                    }

                    final bookmark = Provider.of<BookmarkProvider>(
                      context,
                      listen: false,
                    ).bookmark;

                    return SongLoadMore(bookmark, true);
                  },
                );
              },
            );
          } else {
            // If don't login
            return Center(
              child: TextButton(
                child: Text(
                  "Click here\nlogin your account to get bookmart's list",
                  style: textSmall.copyWith(color: colorGray),
                  textAlign: TextAlign.center,
                ),
                onPressed: () => gotoAuthScreen(context),
              ),
            );
          }
        },
      ),
    );
  }
}
