import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/artist.dart';
import 'package:umusic/providers/artist_provider.dart';
import 'package:umusic/widgets/artist_load_more.dart';
import 'package:umusic/widgets/progress_loading.dart';

class ArtistScreen extends StatefulWidget {
  static const nameRoute = '/artist';

  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<Artist> artists = [];
  bool isFirst = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!Provider.of<ArtistProvider>(
          context,
          listen: false,
        ).isMax) {
          getMoreArtists();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // To fetch get artists
  //   -- [BuildContext context] to provide to provider
  Future<void> setDataArtists(BuildContext context) async {
    isFirst = false;
    Provider.of<ArtistProvider>(context, listen: false).isMax = false;
    Provider.of<ArtistProvider>(context, listen: false).lastArtist = null;

    artists = await Provider.of<ArtistProvider>(
      context,
      listen: false,
    ).fetchArtist();
  }

  void getMoreArtists() async {
    Provider.of<ArtistProvider>(
      context,
      listen: false,
    ).lastArtist = artists.last;

    List<Artist> more = [];

    more = await Provider.of<ArtistProvider>(
      context,
      listen: false,
    ).fetchGetMoreArtist();

    setState(() {
      artists.addAll(more);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ARTISTS',
          style: titleSmall,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: kToolbarHeight + kPandingMedium,
          right: kPandingSmall,
          left: kPandingSmall,
          bottom: kPandingSmall,
        ),
        decoration: const BoxDecoration(
          gradient: gradientBackgroud,
        ),
        child: isFirst
            ? FutureBuilder(
                future: setDataArtists(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ProgressLoading();
                  }

                  return Column(
                    children: [
                      if (artists.isNotEmpty)
                        Expanded(
                          child: ArtistLoadMore(
                            artists,
                            Provider.of<ArtistProvider>(
                              context,
                              listen: false,
                            ).isMax,
                            controller: _scrollController,
                          ),
                        ),
                    ],
                  );
                },
              )
            : Column(
                children: [
                  if (artists.isNotEmpty)
                    Expanded(
                      child: ArtistLoadMore(
                        artists,
                        Provider.of<ArtistProvider>(
                          context,
                          listen: false,
                        ).isMax,
                        controller: _scrollController,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
