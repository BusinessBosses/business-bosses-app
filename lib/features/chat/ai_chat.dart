// lib/features/chat/screens/ai_chat_screen.dart
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/ai_chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/ai_chat_message.dart';
import 'package:business_bosses_v2/features/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AiChatScreen extends GetView<AiChatController> {
  AiChatScreen({super.key});

  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  void _send() {
    final String txt = _inputCtrl.text.trim();
    if (txt.isEmpty) return;

    controller.sendMessage(txt);
    _inputCtrl.clear();
    _focusNode.unfocus();

    // Use post-frame callback to wait until the UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            onPressed: Get.back,
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: const Text('BB SmartChat')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(() {
                final RxList<AiChatMessage> msgs = controller.messages;
                if (msgs.isEmpty) {
                  return const SafetyModel(
                    isLoading: false,
                    title: 'No messages yet!',
                    subTitle: 'Start a conversation',
                  );
                }
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: msgs.length,
                  itemBuilder: (_, int i) => ChatBubble(msg: msgs[i]),
                );
              }),
            ),

            // status footer
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.errorMessage.value != null) {
                  return SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        controller.errorMessage.value!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  );
                }
                return const Divider(height: 1);
              },
            ),

            // input bar
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: <BoxShadow>[
              BoxShadow(blurRadius: 4, color: Colors.black12)
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _inputCtrl,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputCtrl,
                builder: (BuildContext context, TextEditingValue value,
                    Widget? child) {
                  final bool enabled = value.text.trim().isNotEmpty;
                  return IconButton(
                    icon: Icon(
                      Icons.send,
                      color: enabled ? Colors.grey : Colors.red,
                    ),
                    color: enabled ? Colors.red : Colors.grey,
                    onPressed: enabled ? _send : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
