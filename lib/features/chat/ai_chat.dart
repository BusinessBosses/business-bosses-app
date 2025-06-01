// lib/features/chat/screens/ai_chat_screen.dart
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/ai_chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/ai_chat_message.dart';
import 'package:business_bosses_v2/features/chat/widgets/chat_bubble.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
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

  @override
  void initState() {
    super.initState();
    if (controller.messages.isEmpty) {
      controller.messages.add(AiChatMessage(
        text:
            'Hi ${profileController.myProfile.name}. I\'m your go-to AI assistant for business advice. How can I assist you today?',
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

    // Colorful shadow animation
    _shadowColorAnimation = TweenSequence<Color?>(<TweenSequenceItem<Color?>>[
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFF6366F1), end: Color(0xFFEC4899)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFFEC4899), end: Color(0xFF10B981)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFF10B981), end: Color(0xFFF59E0B)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFFF59E0B), end: Color(0xFF8B5CF6)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFF8B5CF6), end: Color(0xFF06B6D4)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Color(0xFF06B6D4), end: Color(0xFF6366F1)),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    // Start the animation and repeat
    _animationController.repeat();
  }

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
          title: const Text('SmartChat AI')),
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
                      // Show the bot avatar and description at the top
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget? child) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(300),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF6366F1),
                                        Color(0xFF818CF8)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: (_shadowColorAnimation.value ??
                                                Colors.purple)
                                            .withOpacity(
                                                _shadowOpacityAnimation.value),
                                        blurRadius: _shadowBlurAnimation.value,
                                        offset: _shadowOffsetAnimation.value,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/svgs/bot.svg',
                                      width: 20,
                                      height: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'AI assistant',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 16), // Add some space before messages
                        ],
                      );
                    }
                    // Return the actual chat message (adjust index by -1)
                    return ChatBubble(msg: msgs[i - 1]);
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
                          colors: <Color>[Color(0xFF6366F1), Color(0xFF818CF8)],
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
