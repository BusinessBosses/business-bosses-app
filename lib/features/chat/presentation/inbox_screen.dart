import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  static const String routeName = '/inbox-screen';

  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}
