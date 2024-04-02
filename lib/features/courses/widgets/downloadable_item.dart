// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DownloadableItem extends StatefulWidget {
  final String link;
  const DownloadableItem({super.key, required this.link});

  @override
  // ignore: library_private_types_in_public_api
  _DownloadableItemState createState() => _DownloadableItemState();
}

class _DownloadableItemState extends State<DownloadableItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
