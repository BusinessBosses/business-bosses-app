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
import 'package:shared_preferences/shared_preferences.dart';

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

  late AnimationController _animationController;
  late Animation<double> _shadowBlurAnimation;
  late Animation<double> _shadowOpacityAnimation;
  late Animation<Offset> _shadowOffsetAnimation;

  static const String _promptCountKey = 'daily_prompt_count';
  static const String _lastPromptDateKey = 'last_prompt_date';

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

  Future<bool> _canSendPrompt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isSubscribed = profileController.myProfile.isSubscribed;

    if (isSubscribed) return true;

    final DateTime now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';
    final String lastUsed = prefs.getString(_lastPromptDateKey) ?? '';
    int count = prefs.getInt(_promptCountKey) ?? 0;

    if (lastUsed != today) {
      await prefs.setInt(_promptCountKey, 0);
      await prefs.setString(_lastPromptDateKey, today);
      count = 0;
    }

    if (count >= 5) return false;

    await prefs.setInt(_promptCountKey, count + 1);
    await prefs.setString(_lastPromptDateKey, today);
    return true;
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
      duration: const Duration(seconds: 8),
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
      begin: const Offset(0, 5),
      end: const Offset(0, 10),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _animationController.repeat();
  }

  void _send({String? predefinedText}) async {
    final String txt = predefinedText ?? _inputCtrl.text.trim();
    if (txt.isEmpty) return;

    final bool allowed = await _canSendPrompt();
    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You\'ve reached your daily free limit. Upgrade to continue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    controller.sendMessage(txt);
    if (predefinedText == null) _inputCtrl.clear();
    _focusNode.unfocus();

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
    return controller.messages.length == 1 &&
        controller.messages.first.text
            .contains('Hello👋 How can I assist you with your business today?');
  }

  Widget _buildSuggestedQuestions() {
    List<List<String>> questionRows = <List<String>>[];
    int questionsPerRow = (suggestedQuestions.length / 3).ceil();

    for (int i = 0; i < suggestedQuestions.length; i += questionsPerRow) {
      int endIndex = (i + questionsPerRow > suggestedQuestions.length)
          ? suggestedQuestions.length
          : i + questionsPerRow;
      questionRows.add(suggestedQuestions.sublist(i, endIndex));
    }

    while (questionRows.length < 3) {
      questionRows.add(<String>[]);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Ask a question',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...questionRows.map((List<String> rowQuestions) {
            if (rowQuestions.isEmpty) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 36,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          color: Colors.indigo.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.indigo.withValues(alpha: 0.2),
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
                      gradient: const LinearGradient(
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
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Text('SmartChat AI'),
          ],
        ),
      ),
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: msgs.length +
                      1 + // header
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
                              color: Colors.indigo.withValues(alpha: 0.07),
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

                    if (_shouldShowSuggestions() && i == 1) {
                      return _buildSuggestedQuestions();
                    }

                    if (controller.shouldShowFollowUps &&
                        i == msgs.length + 1) {
                      return _buildFollowUpQuestions();
                    }

                    int msgIndex = i - 1;
                    if (_shouldShowSuggestions()) msgIndex -= 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ChatBubble(
                        msg: msgs[msgIndex],
                        ishellotext: true,
                      ),
                    );
                  },
                );
              }),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return TypingIndicator(showIndicator: true);
              }
              if (controller.errorMessage.value != null) {
                return SizedBox(
                  height: 48,
                  child: Center(
                    child: Text(
                      controller.errorMessage.value!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                );
              }
              return const Divider(height: 1);
            }),
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
              children: controller.followUpQuestions.map((String question) {
                return GestureDetector(
                  onTap: () => _send(predefinedText: question),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.indigo.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      question,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                );
              }).toList(),
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
                    onPressed: enabled ? () => _send() : null,
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
