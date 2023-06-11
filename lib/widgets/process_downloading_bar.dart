import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/providers/process_download_provider.dart';

class ProcessDownloadingBar extends StatelessWidget {
  const ProcessDownloadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProcessDownloadProvider>(
      builder: (context, value, _) {
        if (value.song == null) {
          return const SizedBox();
        }

        return Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusSmall),
                child: FadeInImage(
                  height: kSizeImageSmall,
                  width: kSizeImageSmall,
                  image: NetworkImage(value.song!.urlImage),
                  placeholder: const AssetImage(
                    'assets/images/placeholder_music.png',
                  ),
                  placeholderErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/placeholder_music.png');
                  },
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                '${value.song!.name}.mp3',
                style: textSmall,
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
              subtitle: LinearProgressIndicator(
                backgroundColor: colorGray,
                color: colorWhite,
                minHeight: 5,
                value: value.currentProcessDownload,
              ),
              trailing: Text(
                '${(value.currentProcessDownload * 100).toInt()}%',
                style: textSmall,
              ),
            ),
            const SizedBox(height: kPandingSmall),
            const Divider(),
            const SizedBox(height: kPandingSmall),
          ],
        );
      },
    );
  }
}
