import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/providers/device_provider.dart';
import 'package:umusic/screens/play_song_screen.dart';
import 'package:umusic/widgets/file_item.dart';
import 'package:umusic/widgets/process_downloading_bar.dart';
import 'package:umusic/widgets/progress_loading.dart';
import 'package:path/path.dart';

class OnDeviceScreen extends StatelessWidget {
  const OnDeviceScreen({super.key});

  void deleteFile(BuildContext context, File file) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await file.delete().whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${basename(file.path)}" was deleted successfully',
            style: textSmall,
          ),
          backgroundColor: colorGreen,
        ),
      );
    });
    Provider.of<DeviceProvider>(context, listen: false).removeFileInList(file);
  }

  void onClickFile(BuildContext context, File file, List<File> files) {
    Navigator.of(context).pushNamed(PlaySongScreen.nameRoute, arguments: {
      'file': file,
      'files': files,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: kHeightAppBar + kPandingSmall,
        right: kPandingSmall,
        left: kPandingSmall,
        bottom: kBottomNavigationBarHeight,
      ),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const ProcessDownloadingBar(),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<DeviceProvider>(
                context,
                listen: false,
              ).getAllMp3(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressLoading();
                }

                final files = Provider.of<DeviceProvider>(context).mp3Files;

                return Column(
                  children: [
                    if (files.isNotEmpty)
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: kPandingSmall),
                        child: Text(
                          'Songs downloaded',
                          style: titleSmall.copyWith(color: colorGray),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FileItem(
                            basename(files[index].path),
                            onClick: () => onClickFile(
                              context,
                              files[index],
                              files,
                            ),
                            onDismissed: (_) =>
                                deleteFile(context, files[index]),
                          );
                        },
                        padding: const EdgeInsets.only(top: kPandingSmall),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
