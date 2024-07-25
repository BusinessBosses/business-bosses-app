// import 'package:business_bosses_v2/utils/constants/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class CallPage extends StatelessWidget {
//   const CallPage(
//       {Key? key,
//       required this.callID,
//       required this.userId,
//       required this.username})
//       : super(key: key);
//   final String callID;
//   final String userId;
//   final String username;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: Constants
//           .APP_ID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign: Constants
//           .APP_SIGN, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: userId,
//       userName: username,
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//     );
//   }
// }
