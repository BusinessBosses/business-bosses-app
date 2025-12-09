import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HometopWidget extends StatefulWidget {
  const HometopWidget({super.key});

  @override
  State<HometopWidget> createState() => _HometopWidgetState();
}

class _HometopWidgetState extends State<HometopWidget> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Wrap(children: <Widget>[
            SizedBox(
              height: 40.0,
              width: 40.0,
              child: Align(
                alignment: Alignment.topLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWithPlaceHolder(
                    imageUrl: profileController.myProfile.photoUrl ?? '',
                    radius: 10,
                    placeHolder: Icons.person,
                    iconSize: 22.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Column(
              children: <Widget>[
                Text('data'),
                Wrap(
                  children: <Widget>[Text('data'), Text('Good morning')],
                )
              ],
            )
          ])
        ],
      ),
    );
  }
}
