// ignore_for_file: always_specify_types

import 'dart:io';

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

double downloadProgress = 0;

void downloadCallback(String id, int status, int progress) {
  print(
      'Download task ($id) is in status ($status) and process (${progress / 100})');

  downloadProgress = (progress / 100).toDouble();

  print(downloadProgress);
}

class DownloadableItem extends StatefulWidget {
  final String link;
  final String filename;
  const DownloadableItem(
      {super.key, required this.link, required this.filename});

  @override
  // ignore: library_private_types_in_public_api
  _DownloadableItemState createState() => _DownloadableItemState();
}

class _DownloadableItemState extends State<DownloadableItem> {
  bool isDownloading = false;
  String? downloadTaskId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            downloadFile(url: widget.link);
          },
          child: Container(
            height: 120,
            width: 100,
            decoration: const BoxDecoration(
              color: backgroundcolorinterface,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/pdf.png'),
                const SizedBox(
                  height: 10,
                ),
                Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(50)),
                    child: SvgPicture.asset(
                      'assets/svgs/download.svg',
                    ),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 8,
                    color: primaryColorLT,
                    backgroundColor: Colors.white,
                    value: 0.3,
                    strokeCap: StrokeCap.round,
                  ),
                ])
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Future<void> downloadFile({required String url}) async {
    setState(() {
      isDownloading = true;
    });

    // Register the callback
    FlutterDownloader.registerCallback(downloadCallback);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String saveDir = '$appDocPath/downloads';

    Directory(saveDir).createSync(recursive: true);

    downloadTaskId = await FlutterDownloader.enqueue(
      url: widget.link,
      headers: {},
      savedDir: saveDir,
      saveInPublicStorage: true,
      showNotification: true,
      openFileFromNotification: true,
      fileName: widget.filename,
    );
  }
}
