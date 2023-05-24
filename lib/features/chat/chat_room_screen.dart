import 'dart:async';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../action/action.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/buttons/button.dart';
import '../../common/widgets/chat_box.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import 'models/my_message.dart';

class ChatRoomScreen extends StatefulWidget {
  static const String routeName = '/chat-room-screen';

  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ProfileController _profileController = Get.find();
  final HomeController _homeController = Get.find();
  final ChatController _chatController = Get.find();
  late UserModel args;
  late TextEditingController _textEditingController;
  final List<PopupMenuEntry<String>> _popupItemForumMore = [
    const PopupMenuItem<String>(
      value: 'Delete Chat',
      child: Text(
        'Delete Chat',
        style: bodyText2,
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      _textEditingController = TextEditingController();
      args = Get.arguments;
      // _chatController.seen(args.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateTo(context);
        return true;
      },
      child: GetBuilder<ChatController>(
        builder: (ChatController controller) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              title: Container(
                alignment: Alignment.centerRight,
                child: ListTile(
                  onTap: () {
                    Get.toNamed(Routes.publicProfile, arguments: args);
                  },
                  trailing: SizedBox(
                    height: 22,
                    width: 22,
                    child: MyPopupMenuButton(
                      popupItems: _popupItemForumMore,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (String val) {
                        deleteChat();
                      },
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 0),
                  title: Text(
                    args.username,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  leading: UserAvatarWithBadge(
                    user: args,
                    height: 52.0,
                    width: 52.0,
                    radius: 50.0,
                    placeHolder: Icons.person,
                    iconSize: 36.0,
                  ),
                  subtitle: Text(
                    args.bio ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor.withOpacity(0.6)),
                  ),
                ),
              ),
              toolbarHeight: 48.0 + 28.0,
            ),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    child: controller
                            .extractConversations(
                              args.uid,
                              _profileController.myProfile.uid,
                            )
                            .isEmpty
                        ? SafetyModel(
                            isLoading: false,
                            icon: const Icon(
                              Icons.edit,
                              size: 80.0,
                              color: Colors.grey,
                            ),
                            title: 'Initiate conversation now!',
                            subTitle: 'No message sent to ${args.username} yet',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 75.0,
                                top: 16.0),
                            reverse: true,
                            itemCount: controller
                                .extractConversations(
                                    args.uid, _profileController.myProfile.uid)
                                .length,
                            itemBuilder: (BuildContext context, int i) {
                              final MessageModel message =
                                  controller.extractConversations(args.uid,
                                      _profileController.myProfile.uid)[i];
                              // final reversedIndex = _messages.length - 1 - i;
                              return InkWell(
                                  onLongPress: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              onTap: () async {
                                                navigateTo(context);
                                                await Clipboard.setData(
                                                  ClipboardData(
                                                    text: message.messageText!,
                                                  ),
                                                );
                                                showSnackBar(context,
                                                    message: 'Text Copied!');
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: const TextWidget(
                                                text: 'Copy Text',
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                navigateTo(context);
                                                optionsDialog(context, () {
                                                  // _isLoading = true;
                                                  Navigator.pop(context);
                                                  // deleteMessage(
                                                  //     _messages[reversedIndex],
                                                  //     reversedIndex);
                                                  // if (reversedIndex ==
                                                  //     _messages.length - 1) {
                                                  //   DeleteLastMessage(_messages[
                                                  //       reversedIndex]);
                                                  // }
                                                });
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: const TextWidget(
                                                text: 'Delete Message',
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );

                                    // deleteMessage(_messages[reversedIndex]);
                                  },
                                  child: ChatBox(
                                    message,
                                    myUid: _profileController.myProfile.uid,
                                  ));
                            },
                          ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 10.0,
                    right: 10.0,
                    child: SendMessageBox(
                      onSendMessage: (
                        String message,
                      ) {
                        controller.addNewChat(
                          <String, dynamic>{
                            'senderUid': _profileController.myProfile.uid,
                            'receiverUid': args.uid,
                            'messageText': message
                          },
                          args,
                          _homeController.socket,
                        );

                        _textEditingController.clear();
                      },
                      textEditingController: _textEditingController,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Future<void> _listenChatMessages() async {
  //   debugPrint('_ChatRoomScreenState._listenChatMessages');
  //   String path = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  // }

  // Future<void> deleteMessage(MessageModel message, int index) async {
  //   String path = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  // }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Future<void> _onSendMessage(MessageModel message) async {
  //   String chatRoomPath = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  // }

  Future<void> _sendNotification(MessageModel message) async {}

  void _setLastMessage(MessageModel message) {}

  void DeleteLastMessage(MessageModel message) {
    String senderPath = '${Constants.USERS_CHATS}/${message.senderUid}';
  }

  Future<void> _readMessages() async {}

  Future<void> deleteChat() async {}

  showSnackBAr(String message) {
    Navigator.pop(context);
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class SendMessageBox extends StatelessWidget {
  final Function(String) onSendMessage;
  final TextEditingController textEditingController;
  const SendMessageBox(
      {Key? key,
      required this.onSendMessage,
      required this.textEditingController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 70.0,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: hintColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Stack(
                  children: [
                    // IconButton(
                    //   onPressed: _onImagePicker,
                    //   icon: _myAssetsEntities.isNotEmpty && !_isSending
                    //       ? AssetViewer(
                    //           image: _myAssetsEntities[0].thumbnail,
                    //         )
                    //       : const Icon(Icons.insert_photo),
                    //   iconSize: 24.0,
                    // ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: messageBoxDecoration.copyWith(
                      hintText: 'Type your messages ...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (textEditingController.text.trim().isEmpty) return;
                    onSendMessage(textEditingController.text.trim());
                  },
                  icon: SvgPicture.asset('assets/svgs/send.svg'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future optionsDialog(BuildContext context, Function() ontap) {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Delete this message',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: MediaQuery.of(context).size.height / 42),
          ),
          actions: [
            but(context, 'Cancel', true, () {
              Navigator.pop(context);
            }),
            but(context, 'Delete', false, ontap)
          ],
        );
      });
}
