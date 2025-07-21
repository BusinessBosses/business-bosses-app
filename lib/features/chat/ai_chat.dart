// lib/features/chat/screens/ai_chat_screen.dart
// ignore_for_file: unused_field

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

  // Animation controller and animations
  late AnimationController _animationController;
  late Animation<double> _shadowBlurAnimation;
  late Animation<double> _shadowOpacityAnimation;
  late Animation<Offset> _shadowOffsetAnimation;
  late Animation<Color?> _shadowColorAnimation;
  final List<String> _randomBusinessPrompts = <String>[
    'What are three ways I can grow my business sustainably over the next 12 months?',
    'Analyze the biggest strengths and weaknesses of my business, based on general small business trends.',
    'What marketing strategies would be most effective for promoting my business with a limited budget?',
    'Give me creative ideas to improve customer retention in my business.',
    'What are some common mistakes businesses like mine make, and how can I avoid them?',
    'Suggest five ways to make my business stand out in a competitive market.',
    'What key performance indicators (KPIs) should I track to measure the success of my business?',
    'How can I use technology to automate or streamline operations in my business?',
    'What are some low-cost ideas to build brand awareness for my business?',
    'Based on general business principles, what steps should I take to prepare my business for scaling?',
  ];

  List<String> _shownPrompts = <String>[];
  static const String _promptCountKey = 'daily_prompt_count';
  static const String _lastPromptDateKey = 'last_prompt_date';
  void _initPrompts() {
    _shownPrompts = (_randomBusinessPrompts..shuffle()).take(5).toList();
  }

  @override
  void initState() {
    super.initState();
    if (controller.messages.isEmpty) {
      controller.messages.add(AiChatMessage(
        text: 'Hello👋 How can I assist you with your business today?',
        isMe: false,
      ));
    }
    if (controller.messages.length == 1 &&
        controller.messages.first.text ==
            'Hello👋 How can I assist you with your business today?') {
      _initPrompts();
    }
    _initAnimations();
  }

  Future<bool> _canSendPrompt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isSubscribed = profileController.myProfile.isSubscribed;

    if (isSubscribed) return true; // No limit for subscribed

    final DateTime now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';
    final String lastUsed = prefs.getString(_lastPromptDateKey) ?? '';
    int count = prefs.getInt(_promptCountKey) ?? 0;

    // Reset if it's a new day
    if (lastUsed != today) {
      await prefs.setInt(_promptCountKey, 0);
      await prefs.setString(_lastPromptDateKey, today);
      count = 0;
    }

    if (count >= 5) return false;

    // Increment and save
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

    // Colorful shadow animation

    // Start the animation and repeat
    _animationController.repeat();
  }

  void _send() async {
    final String txt = _inputCtrl.text.trim();
    if (txt.isEmpty) return;

    final bool allowed = await _canSendPrompt();
    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'You\'ve reached your daily free limit. Upgrade to continue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
    bool ishellotext = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0,
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 2.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Icon(
                  //         Icons.info_outline,
                  //         size: 16,
                  //         color: Colors.grey[500],
                  //       ),
                  //       const SizedBox(width: 6),
                  //       Text(
                  //         'AI assistant',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontSize: 13,
                  //           color: Colors.grey[600],
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: msgs.length + 1, // +1 for the header
                  itemBuilder: (_, int i) {
                    if (i == 0) {
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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

                    if (!msgs[i - 1].text.contains(
                        'Hello👋 How can I assist you with your business today?')) {
                      ishellotext = true;
                    } else {
                      ishellotext = false;
                    }
                    // Return the actual chat message (adjust index by -1)
                    return Column(
                      children: <Widget>[
                        ChatBubble(msg: msgs[i - 1], ishellotext: ishellotext),
                        // 👇 Insert this block here
                        if (_shownPrompts.isNotEmpty &&
                            i == 1 &&
                            controller.messages.length == 1)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _shownPrompts
                                  .map(
                                    (String prompt) => GestureDetector(
                                      onTap: () {
                                        _inputCtrl.text = prompt;
                                        _focusNode.requestFocus();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.indigo
                                              .withAlpha((0.05 * 255).toInt()),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.indigo
                                                .withAlpha((0.2 * 255).toInt()),
                                          ),
                                        ),
                                        child: Text(
                                          prompt,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    );
                  },
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
