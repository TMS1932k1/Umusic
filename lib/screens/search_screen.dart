import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/providers/search_provider.dart';
import 'package:umusic/widgets/song_load_more.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  List<Song> searchSongs = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!Provider.of<SearchProvider>(
          context,
          listen: false,
        ).isMax) {
          getMoreSongs();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // To get more song loading
  Future<void> getMoreSongs() async {
    Provider.of<SearchProvider>(
      context,
      listen: false,
    ).lastSong = searchSongs.last;

    final more = await Provider.of<SearchProvider>(
      context,
      listen: false,
    ).fetchGetMore();

    setState(() {
      searchSongs.addAll(more);
    });
  }

  // To get search songs
  Future<void> onSubmitted(String name) async {
    Provider.of<SearchProvider>(context, listen: false).name = name;
    Provider.of<SearchProvider>(context, listen: false).isMax = false;
    Provider.of<SearchProvider>(context, listen: false).lastSong = null;

    searchSongs = await Provider.of<SearchProvider>(
      context,
      listen: false,
    ).fetchSearch();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kHeightAppBar,
        bottom: kBottomNavigationBarHeight,
        left: kPandingSmall,
        right: kPandingSmall,
      ),
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: kPandingMedium),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorWhite),
              borderRadius: BorderRadius.circular(kRadiusSmall),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: kPandingMedium,
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter the keyword to search...',
                hintStyle: textSmall,
              ),
              maxLines: 1,
              onSubmitted: onSubmitted,
            ),
          ),
          const SizedBox(height: kPandingMedium),
          if (searchSongs.isNotEmpty)
            Expanded(
              child: SongLoadMore(
                searchSongs,
                Provider.of<SearchProvider>(
                  context,
                  listen: false,
                ).isMax,
                controller: _scrollController,
              ),
            ),
        ],
      ),
    );
  }
}
