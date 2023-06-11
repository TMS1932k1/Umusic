import 'package:flutter/material.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/models/song.dart';
import 'package:umusic/widgets/slider_item.dart';

class SongSlider extends StatefulWidget {
  final List<Song> songs;
  final Function(Song)? onClickItem;

  const SongSlider(
    this.songs, {
    this.onClickItem,
    super.key,
  });

  @override
  State<SongSlider> createState() => _SongSliderState();
}

class _SongSliderState extends State<SongSlider> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.songs.isEmpty) {
      return Container();
    }

    return SizedBox(
      height: kHeightSlider,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.songs.length,
        onPageChanged: (value) {},
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SliderItem(
          widget.songs[index],
          onPressed: widget.onClickItem,
        ),
      ),
    );
  }
}
