// lib/features/chat/screens/ai_chat_screen.dart
// ignore_for_file: unused_field

import 'package:business_bosses_v2/bbpro/widgets/typingindicator.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/ai_chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/ai_chat_message.dart';
import 'package:business_bosses_v2/features/chat/widgets/chat_bubble.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with TickerProviderStateMixin {
  final AiChatController controller = Get.find<AiChatController>();
  final ProfileController profileController = Get.find<ProfileController>();

  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Animation controller and animations
  late AnimationController _animationController;
  late Animation<double> _shadowBlurAnimation;
  late Animation<double> _shadowOpacityAnimation;
  late Animation<Offset> _shadowOffsetAnimation;
  late Animation<Color?> _shadowColorAnimation;

  // Suggested questions for business and entrepreneurship
  final List<String> suggestedQuestions = <String>[
    'How to create a business plan?',
    'What are the key marketing strategies?',
    'How to manage cash flow effectively?',
    'What legal structure should I choose?',
    'How to find investors for my startup?',
    'What are the best productivity tools?',
    'How to build a strong team?',
    'What are current market trends?',
  ];

  @override
  void initState() {
    super.initState();
    if (controller.messages.isEmpty) {
      controller.messages.add(AiChatMessage(
        text: 'Hello👋 How can I assist you with your business today?',
        isMe: false,
      ));
    }
    _initAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _shadowBlurAnimation = Tween<double>(
      begin: 12.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _shadowOpacityAnimation = Tween<double>(
      begin: 0.25,
      end: 0.45,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _shadowOffsetAnimation = Tween<Offset>(
      begin: Offset(0, 5),
      end: Offset(0, 10),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    // Start the animation and repeat
    _animationController.repeat();
  }

  void _send({String? predefinedText}) {
    final String txt = predefinedText ?? _inputCtrl.text.trim();
    if (txt.isEmpty) return;

    controller.sendMessage(txt);
    if (predefinedText == null) {
      _inputCtrl.clear();
    }
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

  bool _shouldShowSuggestions() {
    // Show suggestions only if we have exactly 1 message (the hello message)
    // and it's the initial greeting
    return controller.messages.length == 1 &&
        controller.messages.first.text
            .contains('Hello👋 How can I assist you with your business today?');
  }

  Widget _buildSuggestedQuestions() {
    // Arrange questions into exactly 3 rows
    List<List<String>> questionRows = <List<String>>[];
    int questionsPerRow = (suggestedQuestions.length / 3).ceil();

    for (int i = 0; i < suggestedQuestions.length; i += questionsPerRow) {
      int endIndex = (i + questionsPerRow > suggestedQuestions.length)
          ? suggestedQuestions.length
          : i + questionsPerRow;
      questionRows.add(suggestedQuestions.sublist(i, endIndex));
    }

    // If we have less than 3 rows, pad with empty lists
    while (questionRows.length < 3) {
      questionRows.add(<String>[]);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: const Text(
              'Ask a question',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Create 3 horizontal scrollable rows
          ...questionRows.map((List<String> rowQuestions) {
            if (rowQuestions.isEmpty) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 36,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: rowQuestions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _send(predefinedText: rowQuestions[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.indigo.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            rowQuestions[index],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool ishellotext = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: Get.back,
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xFF6366F1), Color(0xFF818CF8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svgs/bot.svg',
                          width: 10,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text('SmartChat AI'),
                ],
              ),
            ],
          )),
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
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  itemCount: msgs.length +
                      1 + // for header
                      (_shouldShowSuggestions() ? 1 : 0) +
                      (controller.shouldShowFollowUps ? 1 : 0),
                  itemBuilder: (_, int i) {
                    if (i == 0) {
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SmartChat AI is your intelligent business assistant. Ask questions, get advice, and boost your productivity with instant, AI-powered responses.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }

                    // Handle suggestions
                    if (_shouldShowSuggestions() && i == 1) {
                      return _buildSuggestedQuestions();
                    }

                    // Handle follow-ups
                    if (controller.shouldShowFollowUps &&
                        i == msgs.length + 1) {
                      return _buildFollowUpQuestions();
                    }

                    // Adjust index for messages
                    int msgIndex = i - 1;
                    if (_shouldShowSuggestions() && msgIndex >= msgs.length) {
                      msgIndex -= 1;
                    }

                    bool ishellotext = !msgs[msgIndex].text.contains(
                        'Hello👋 How can I assist you with your business today?');

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ChatBubble(
                          msg: msgs[msgIndex], ishellotext: ishellotext),
                    );
                  },
                );
              }),
            ),
            // status footer
            Obx(
              () {
                if (controller.isLoading.value) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                        child: TypingIndicator(
                      showIndicator: true,
                    )),
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

  Widget _buildFollowUpQuestions() {
    return Obx(() {
      if (!controller.shouldShowFollowUps) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ask a follow-up question',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.followUpQuestions
                  .map((String question) => GestureDetector(
                        onTap: () => _send(predefinedText: question),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.indigo.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            question,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
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
                    icon: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: <Color>[primaryColorLT, primaryColorLT],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Icon(
                        Icons.send,
                        color: enabled ? Colors.white : Colors.grey,
                      ),
                    ),
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
