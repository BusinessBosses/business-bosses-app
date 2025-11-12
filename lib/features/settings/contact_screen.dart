import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

import '../profile/controller/profile_controller.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String message = ''; // Variable to store user's message
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              maxLines: 5, // Allows multiple lines of input
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  message =
                      value; // Update the message variable when the input changes
                });
              },
            ),
            ElevatedButton(
              onPressed: sendEmail,
              child: const Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    // String userEmailAddress = profileController.myProfile.email;
    // final  SmtpServer smtpServer = gmailSaslXoauth2(userEmailAddress, token);
    // final Message message = Message()
    //   ..from = Address(
    //       userEmailAddress) // Use the logged-in user's email as the sender
    //   ..recipients
    //       .add('support@businessbosses.co.uk') // Replace with the contact email
    //   ..subject = 'Flutter Email Test'
    //   ..text =
    //       'This is a test email sent from Flutter'; // Set the reply-to email as the user's email
    // // Manually set the reply-to header
    // message.headers['reply-to'] = userEmailAddress;
    // await send(message, smtpServer)
  }
}
