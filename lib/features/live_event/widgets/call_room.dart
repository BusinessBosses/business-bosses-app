// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/features/live_event/widgets/zego_details.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class CallRoom extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final String title;
  final ProfileController profileController = Get.find();

  CallRoom(
      {Key? key,
      required this.roomID,
      required this.title,
      this.isHost = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Display the room title in the app bar
      ),
      body: ZegoUIKitPrebuiltLiveAudioRoom(
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
          ..hostSeatIndexes = [0]
          ..layoutConfig.rowConfigs = [
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
          ],
      ),
    );
  }
}
