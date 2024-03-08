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

class BuyCoinsListItem extends StatefulWidget {
  const BuyCoinsListItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BuyCoinsListItemState createState() => _BuyCoinsListItemState();
}

class _BuyCoinsListItemState extends State<BuyCoinsListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
    
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:15.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
            children:[
              SvgPicture.asset('assets/svgs/coin.svg'),
              SizedBox(width: 10,),
              Text('1000 ',),
              Text('(\$4.99)', style: TextStyle(fontWeight: FontWeight.bold),),
              
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: Container(height:1,
                color: backgroundcolorinterface,
              ),
          )
        ],
      ),
      
    );
  }
}
