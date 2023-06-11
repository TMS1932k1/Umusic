import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';

class SectionBar extends StatelessWidget {
  final String title;
  final Widget? content;
  final Function()? onClickMore;

  const SectionBar(
    this.title, {
    this.content,
    this.onClickMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: titleSmall.copyWith(color: colorGray),
              ),
              if (onClickMore != null)
                IconButton(
                  onPressed: onClickMore!,
                  icon: const FaIcon(FontAwesomeIcons.chevronRight),
                  iconSize: kSizeIconSmall,
                  color: colorGray,
                ),
            ],
          ),
          if (content != null) content!,
        ],
      ),
    );
  }
}
