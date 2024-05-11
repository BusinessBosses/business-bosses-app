import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/chat/presentation/call_page.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallInvitationPage extends StatelessWidget {
  final String callerId;
  final String recipientId;
  final String username;

  const CallInvitationPage(
      {super.key,
      required this.callerId,
      required this.recipientId,
      required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => StartCallDialog(
                    callerId: callerId,
                    recipientId: recipientId,
                  ),
                );
              },
              child: const Text('Start Call'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => JoinCallDialog(
                    userId: recipientId,
                    username: username,
                  ),
                );
              },
              child: const Text('Join Call'),
            ),
          ],
        ),
      ),
    );
  }
}

class StartCallDialog extends StatelessWidget {
  final String callerId;
  final String recipientId;

  const StartCallDialog(
      {super.key, required this.callerId, required this.recipientId});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start Call'),
      content: FutureBuilder(
        future: startCall(<String, dynamic>{
          'callerId': callerId,
          'recipientId': recipientId,
        }),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Failed to start call: ${snapshot.error}');
          } else {
            final String? callId = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Call ID: $callId'),
                IconButton(
                  onPressed: () {
                    // Copy call ID to clipboard
                    Clipboard.setData(ClipboardData(text: callId!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Call ID copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.content_copy),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> startCall(Map<String, dynamic> data) async {
    final String? token = sandBox.read(Constants.ACCESS_TOKEN);
    // Call your backend API to start the call
    final http.Response response = await http.post(
      Uri.parse(
          'https://orca-app-5dg8w.ondigitalocean.app/share/initiate-call'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Parse the response to get the call ID
      // final data = json.decode(response.body);
      final ApiResponseModel data =
          ApiResponseModel.fromMap(jsonDecode(response.body));
      return data.data['callId'] as String;
    } else {
      throw Exception('Failed to start call');
    }
  }
}

class JoinCallDialog extends StatelessWidget {
  final TextEditingController _callIdController = TextEditingController();
  final String userId;
  final String username;

  JoinCallDialog({super.key, required this.userId, required this.username});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Call'),
      content: TextField(
        controller: _callIdController,
        decoration: const InputDecoration(
          hintText: 'Enter Call ID',
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            final String callId = _callIdController.text.trim();
            // Navigate to the call page with the call ID
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CallPage(
                  callID: callId,
                  userId: userId,
                  username: username,
                ),
              ),
            );
          },
          child: const Text('Join'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
