// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/expanded_course_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WithdrawalHeaderItem extends StatefulWidget {
  const WithdrawalHeaderItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalHeaderItemState createState() => _WithdrawalHeaderItemState();
}

class _WithdrawalHeaderItemState extends State<WithdrawalHeaderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundcolorinterface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:15.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text('Details', style: TextStyle(fontWeight: FontWeight.bold),),
          Text('Status', style: TextStyle(fontWeight: FontWeight.bold),)
        ]),
      ),
      
    );
  }
}
