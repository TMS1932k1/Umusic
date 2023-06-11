import 'package:flutter/material.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';

class IconUser extends StatelessWidget {
  final String charFirst;
  final Function()? onClick;

  const IconUser(this.charFirst, {this.onClick, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: kSizeIconLarge,
          width: kSizeIconLarge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSizeIconMedium),
            border: Border.all(
              color: colorWhite,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            charFirst,
            style: titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
