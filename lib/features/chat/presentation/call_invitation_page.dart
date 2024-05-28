// import 'package:business_bosses_v2/common/models/api_response_model.dart';
// import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
// import 'package:business_bosses_v2/features/chat/presentation/call_page.dart';
// import 'package:business_bosses_v2/services/api_service.dart';
// import 'package:business_bosses_v2/utils/constants/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CallInvitationPage extends StatelessWidget {
//   final String callerId;
//   final String recipientId;
//   final String username;

//   const CallInvitationPage(
//       {super.key,
//       required this.callerId,
//       required this.recipientId,
//       required this.username});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Call'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => StartCallDialog(
//                     callerId: callerId,
//                     recipientId: recipientId,
//                   ),
//                 );
//               },
//               child: const Text('Start Call'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => JoinCallDialog(
//                     userId: recipientId,
//                     username: username,
//                   ),
//                 );
//               },
//               child: const Text('Join Call'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

