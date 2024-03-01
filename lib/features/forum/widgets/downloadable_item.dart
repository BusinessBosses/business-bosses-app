// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/forum/presentation/expanded_course_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DownloadableItem extends StatefulWidget {
  const DownloadableItem({super.key});

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
          height: 200,
          width: 150,
          decoration:  const BoxDecoration(
            color: backgroundcolorinterface,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Image.asset('assets/images/pdf.png'),
              Text('data')
            ],
          ),

        ),
        SizedBox(width: 10,)
      ],
    );
    
  }
}
