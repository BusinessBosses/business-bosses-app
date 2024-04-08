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
        title: Text('Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              child: Text('Start Call'),
            ),
            SizedBox(height: 20),
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
              child: Text('Join Call'),
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
      title: Text('Start Call'),
      content: FutureBuilder(
        future: startCall({
          'callerId': callerId,
          'recipientId': recipientId,
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Failed to start call: ${snapshot.error}');
          } else {
            final callId = snapshot.data as String?;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Call ID: $callId'),
                IconButton(
                  onPressed: () {
                    // Copy call ID to clipboard
                    Clipboard.setData(ClipboardData(text: callId!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Call ID copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(Icons.content_copy),
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
    final response = await http.post(
      Uri.parse(
          'https://orca-app-5dg8w.ondigitalocean.app/share/initiate-call'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Parse the response to get the call ID
      // final data = json.decode(response.body);
      final data = ApiResponseModel.fromMap(jsonDecode(response.body));
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
      title: Text('Join Call'),
      content: TextField(
        controller: _callIdController,
        decoration: InputDecoration(
          hintText: 'Enter Call ID',
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final callId = _callIdController.text.trim();
            // Navigate to the call page with the call ID
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallPage(
                  callID: callId,
                  userId: userId,
                  username: username,
                ),
              ),
            );
          },
          child: Text('Join'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
