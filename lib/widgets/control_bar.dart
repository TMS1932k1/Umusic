import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';

class ControlBar extends StatefulWidget {
  final bool isPlaying;
  final Duration duration;
  final Duration position;

  final Function()? pauseSong;
  final Function()? resumeSong;
  final Function(double)? seekPosition;
  final Function()? backwardSong;
  final Function()? forwardSong;
  final Function()? stepBackwardSong;
  final Function()? stepForwardSong;

  const ControlBar(
    this.isPlaying,
    this.duration,
    this.position, {
    this.resumeSong,
    this.pauseSong,
    this.seekPosition,
    this.backwardSong,
    this.forwardSong,
    this.stepBackwardSong,
    this.stepForwardSong,
    super.key,
  });

  @override
  State<ControlBar> createState() => _ControlBarState();
}

// Convert from Duration to String
String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(' : ');
}

class _ControlBarState extends State<ControlBar> {
  // Set event when on click resume or pause button depence on [bool isPlaying]
  void onClickResumeOrPauseButton() {
    if (widget.isPlaying) {
      widget.pauseSong!();
    } else {
      widget.resumeSong!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPandingLarge,
        vertical: kPandingMedium,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTime(widget.position),
                style: textSmall,
              ),
              Text(
                formatTime(widget.duration),
                style: textSmall,
              ),
            ],
          ),
          Column(
            children: [
              Slider(
                value: widget.position.inSeconds.toDouble(),
                onChanged: widget.seekPosition,
                min: 0,
                max: widget.duration.inSeconds.toDouble(),
                thumbColor: colorWhite,
                activeColor: colorPurple,
                inactiveColor: colorGray,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: widget.stepBackwardSong,
                icon: const FaIcon(
                  FontAwesomeIcons.backwardStep,
                ),
              ),
              IconButton(
                onPressed: widget.backwardSong,
                icon: const FaIcon(
                  FontAwesomeIcons.backward,
                ),
              ),
              IconButton(
                onPressed: widget.pauseSong != null && widget.resumeSong != null
                    ? onClickResumeOrPauseButton
                    : null,
                icon: widget.isPlaying
                    ? const FaIcon(
                        FontAwesomeIcons.pause,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.play,
                      ),
              ),
              IconButton(
                onPressed: widget.forwardSong,
                icon: const FaIcon(
                  FontAwesomeIcons.forward,
                ),
              ),
              IconButton(
                onPressed: widget.stepForwardSong,
                icon: const FaIcon(
                  FontAwesomeIcons.forwardStep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
