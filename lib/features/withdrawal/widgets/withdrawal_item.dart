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

class WithdrawalItem extends StatefulWidget {
  const WithdrawalItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalItemState createState() => _WithdrawalItemState();
}

class _WithdrawalItemState extends State<WithdrawalItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$20', style: TextStyle(fontWeight: FontWeight.w700),),
                  Text('Date and Time'),
                ],
              ),
              Text('Paid', style: TextStyle(color: Colors.greenAccent),),
            
            ]),
          ),
          Container(
            color: backgroundcolorinterface,
            height: 1,
          )
        ],
      ),
    );
  }
}
