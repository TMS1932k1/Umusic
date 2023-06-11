import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/providers/process_download_provider.dart';

class FileItem extends StatelessWidget {
  final String nameFile;
  final Function()? onClick;
  final Function(DismissDirection)? onDismissed;

  const FileItem(
    this.nameFile, {
    this.onClick,
    this.onDismissed,
    super.key,
  });

  Future<bool?> confirmDismiss(BuildContext context) async {
    bool? isConfirmed;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Do you want to delete "$nameFile" file',
          style: textMedium,
        ),
        title: const Text(
          'Confirm delete',
          style: titleSmall,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Cancle',
              style: textSmall,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Confirm',
              style: titleSmall,
            ),
            onPressed: () {
              isConfirmed = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return isConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    String? nameFileDownloading;
    if (Provider.of<ProcessDownloadProvider>(context).song != null) {
      nameFileDownloading =
          '${Provider.of<ProcessDownloadProvider>(context).song!.name}.mp3';
    } else {
      nameFileDownloading = null;
    }

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        final confirm = await confirmDismiss(context);
        return confirm;
      },
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: kPandingMedium),
        child: const FaIcon(
          FontAwesomeIcons.trash,
          size: kSizeIconMedium,
        ),
      ),
      child: ListTile(
        onTap: onClick,
        leading: Container(
          padding: const EdgeInsets.all(kPandingSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadiusSmall),
            color: colorWhite,
          ),
          child: const FaIcon(
            FontAwesomeIcons.music,
            color: colorPurple,
            size: kSizeIconMedium,
          ),
        ),
        title: Text(
          nameFile,
          style: textSmall.copyWith(
              color: (nameFileDownloading != null &&
                      nameFileDownloading.compareTo(nameFile) == 0)
                  ? colorGray
                  : colorWhite),
          maxLines: 2,
          overflow: TextOverflow.clip,
        ),
        trailing: (nameFileDownloading != null &&
                nameFileDownloading.compareTo(nameFile) == 0)
            ? Text(
                'Downloading',
                style: textSmall.copyWith(color: colorGray),
              )
            : null,
      ),
    );
  }
}
