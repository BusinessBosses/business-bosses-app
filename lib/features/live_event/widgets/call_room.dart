// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/widgets/zego_details.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class CallRoom extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final String title;
  final String? image;
  final ProfileController profileController = Get.find();

  CallRoom(
      {Key? key,
      required this.roomID,
      required this.title,
      this.image,
      this.isHost = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Display the room title in the app bar
      ),
      body: Column(
        children: <Widget>[
          if (image != null)
            SizedBox(
              height: 120,
              child: NetworkImageWithPlaceHolder(imageUrl: image),
            ),
          Expanded(
            child: ZegoUIKitPrebuiltLiveAudioRoom(
              appID: ZegoDetails
                  .appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
              appSign: ZegoDetails
                  .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
              userID: profileController.myProfile.uid,
              userName: profileController.myProfile.name ??
                  profileController.myProfile.username,
              roomID: roomID,
              config: isHost
                  ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                  : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
                ..innerText.memberListTitle = 'Members'
                ..inRoomMessageConfig = ZegoInRoomMessageConfig(
                  itemBuilder: (
                    BuildContext context,
                    ZegoInRoomMessage message,
                    Map<String, dynamic> extraInfo,
                  ) {
                    /// how to use itemBuilder to custom message view
                    return Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (() {
                                if (profileController.myProfile.uid !=
                                    message.user.id.toString()) {
                                  Get.toNamed(Routes.publicProfile,
                                      arguments:
                                          UserModel.fromMap(<String, dynamic>{
                                        'uid': message.user.id.toString(),
                                        'username': message.user.name,
                                        'email': 'hhh',
                                      }));
                                }
                              }),
                              child: Text(
                                '${message.user.name}:',
                                style: const TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              message.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ));
                  },
                )
                ..hostSeatIndexes = [0]
                ..topMenuBarConfig.buttons = [
                  ZegoMenuBarButtonName.minimizingButton
                ]
                ..layoutConfig.rowConfigs = [
                  ZegoLiveAudioRoomLayoutRowConfig(
                      count: 1,
                      alignment: ZegoLiveAudioRoomLayoutAlignment.center),
                  ZegoLiveAudioRoomLayoutRowConfig(
                      count: 4,
                      alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                  ZegoLiveAudioRoomLayoutRowConfig(
                      count: 4,
                      alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
