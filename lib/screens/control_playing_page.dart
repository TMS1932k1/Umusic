import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/providers/play_song_provider.dart';
import 'package:umusic/widgets/control_bar.dart';
import 'package:umusic/widgets/disk_playing.dart';

class ControlPlayingPage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String? stringArtist;

  const ControlPlayingPage(
    this.audioPlayer, {
    this.stringArtist,
    super.key,
  });

  @override
  State<ControlPlayingPage> createState() => _ControlPlayingPageState();
}

class _ControlPlayingPageState extends State<ControlPlayingPage>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Set url song into [AudioPlayer audioPlayer]
  // And listen to event change state in [AudioPlayer audioPlayer]
  Future<void> setAudio() async {
    await widget.audioPlayer.play(
      DeviceFileSource(
        Provider.of<PlaySongProvider>(
          context,
          listen: false,
        ).getUrlCurrent()!,
      ),
    );

    if (mounted) {
      setState(() {
        _controller.repeat();
        isPlaying = true;
      });
    }

    //widget.audioPlayer.setReleaseMode(ReleaseMode.loop);

    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
          if (isPlaying) {
            _controller.repeat();
          } else {
            _controller.stop(canceled: false);
          }
        });
      }
    });

    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          if (newPosition < duration) {
            position = newPosition;
          }
        });
      }
    });

    widget.audioPlayer.onPlayerComplete.listen((event) {
      stepForwardSong();
    });
  }

  Future<void> pauseSong() async {
    await widget.audioPlayer.pause();
  }

  Future<void> resumeSong() async {
    await widget.audioPlayer.resume();
  }

  Future<void> seekSong(double value) async {
    final position = Duration(seconds: value.toInt());
    await widget.audioPlayer.seek(position);
    await widget.audioPlayer.resume();
  }

  Future<void> backwardSong() async {
    final currentPosition = await widget.audioPlayer.getCurrentPosition();
    if (currentPosition != null) {
      final position = Duration(
        seconds: max(currentPosition.inSeconds - 5, 0),
      );
      await widget.audioPlayer.seek(position);
      await widget.audioPlayer.resume();
    }
  }

  Future<void> forwardSong() async {
    final currentPosition = await widget.audioPlayer.getCurrentPosition();
    final duration = await widget.audioPlayer.getDuration();
    if (currentPosition != null && duration != null) {
      final position = Duration(
        seconds: min(currentPosition.inSeconds + 5, duration.inSeconds),
      );
      await widget.audioPlayer.seek(position);
      await widget.audioPlayer.resume();
    }
  }

  Future<void> stepForwardSong() async {
    Provider.of<PlaySongProvider>(context, listen: false).nextSong();
    await widget.audioPlayer.release();
    await setAudio();
  }

  Future<void> stepBackwardSong() async {
    Provider.of<PlaySongProvider>(context, listen: false).backSong();
    await widget.audioPlayer.release();
    await setAudio();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 6,
      ),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    setAudio();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: kPandingExtra),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DiskPlaying(
                  Provider.of<PlaySongProvider>(
                    context,
                    listen: false,
                  ).urlImageSong,
                  kSizeDiskPlaying,
                  _animation,
                ),
                const SizedBox(height: kPandingExtra),
                if (Provider.of<PlaySongProvider>(
                      context,
                      listen: false,
                    ).getNameCurrent() !=
                    null)
                  Text(
                      Provider.of<PlaySongProvider>(
                        context,
                        listen: false,
                      ).getNameCurrent()!,
                      style: textMedium),
                if (widget.stringArtist != null)
                  const SizedBox(height: kPandingSmall),
                if (widget.stringArtist != null)
                  Text(
                    widget.stringArtist!.trim(),
                    style: textMedium.copyWith(color: colorGray),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ControlBar(
              isPlaying,
              duration,
              position,
              pauseSong: pauseSong,
              resumeSong: resumeSong,
              seekPosition: seekSong,
              backwardSong: backwardSong,
              forwardSong: forwardSong,
              stepBackwardSong: stepBackwardSong,
              stepForwardSong: stepForwardSong,
            ),
          ),
        ],
      ),
    );
  }
}
