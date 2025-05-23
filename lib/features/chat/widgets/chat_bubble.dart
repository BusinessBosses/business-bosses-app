import 'package:business_bosses_v2/features/chat/models/ai_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final AiChatMessage msg;
  const ChatBubble({required this.msg, super.key});

  @override
  Widget build(BuildContext context) {
    final Color bg = msg.isMe
        ? Theme.of(context).primaryColorLight
        : Theme.of(context).dividerColor.withValues(alpha: 0.1);
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: SelectableRegion(
        focusNode: FocusNode(), // needed for selection
        selectionControls: materialTextSelectionControls,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomLeft: msg.isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: msg.isMe ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: MarkdownBody(
            data: msg.text,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              // tweak default styles to match your bubble
              p: const TextStyle(color: Colors.black87),
              strong: const TextStyle(fontWeight: FontWeight.w700),
              listBullet: const TextStyle(color: Colors.black87),
              // you can customize bullets, padding, etc.
            ),
            // if you trust the API content, you can leave selectable true/false
            selectable: true,
            onTapLink: (String text, String? href, String title) async {
              if (href == null) return;
              final Uri uri = Uri.parse(href);

              // check if the device can handle this URI
              if (await canLaunchUrl(uri)) {
                // launch externally (e.g. browser)
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                // fallback or error
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $href')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
