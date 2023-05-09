import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../action/action.dart';
import '../../common/models/user_model.dart';
import '../../common/params.dart';
import '../../common/widgets/buttons/button.dart';
import '../../common/widgets/chat_box.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../profile/publicprofilescreen.dart';
import 'app_chats.dart';
import 'models/my_message.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = '/chat-room-screen';

  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  UserModel? _user;
  AppChats? appChats;

  final List<MyMessage> _messages = [];

  bool _isInit = false;
  bool _isLoading = true;
  final List<PopupMenuEntry<String>> _popupItemForumMore = [
    const PopupMenuItem<String>(
      value: 'Delete Chat',
      child: Text(
        'Delete Chat',
        style: bodyText2,
      ),
    ),
  ];
  String? _chatRoomId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _user = ModalRoute.of(context)?.settings.arguments as UserModel?;
      _readMessages();
      _listenChatMessages();
      _isInit = true;
    }
  }

  void _navigateTo(BuildContext context, {String? routeName, var argument}) {
    if (routeName != null) {
      Navigator.of(context).pushNamed(routeName, arguments: argument);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateTo(context);
        return true;
      },
      child: Scaffold(
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
                _navigateTo(
                  context,
                  routeName: PublicProfileScreen.routeName,
                  argument: Params(arg1: _user?.uid),
                );
              },
              trailing: SizedBox(
                height: 22,
                width: 22,
                child: MyPopupMenuButton(
                  popupItems: _popupItemForumMore,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (val) {
                    deleteChat();
                  },
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 0),
              title: Text(
                '_user.name',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              leading: UserAvatarWithBadge(
                user: _user,
                height: 52.0,
                width: 52.0,
                radius: 50.0,
                placeHolder: Icons.person,
                iconSize: 36.0,
              ),
              subtitle: Text('_user.bio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor.withOpacity(0.6),
                      )),
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
                child: _messages.isEmpty
                    ? SafetyModel(
                        isLoading: _isLoading,
                        icon: const Icon(
                          Icons.edit,
                          size: 80.0,
                          color: Colors.grey,
                        ),
                        title: 'Initiate conversation now!',
                        subTitle: 'No message sent to ${"_user!.name"} yet',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 75.0, top: 16.0),
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final reversedIndex = _messages.length - 1 - i;
                          return InkWell(
                              onLongPress: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            navigateTo(context);
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: _messages[reversedIndex]
                                                    .messageText,
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
                                              _isLoading = true;
                                              Navigator.pop(context);
                                              deleteMessage(
                                                  _messages[reversedIndex],
                                                  reversedIndex);
                                              if (reversedIndex ==
                                                  _messages.length - 1) {
                                                DeleteLastMessage(
                                                    _messages[reversedIndex]);
                                              }
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
                              child: ChatBox(_messages[reversedIndex]));
                        },
                      ),
              ),
              Positioned(
                bottom: 20.0,
                left: 10.0,
                right: 10.0,
                child: SendMessageBox(onSendMessage: _onSendMessage),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _listenChatMessages() async {
    debugPrint('_ChatRoomScreenState._listenChatMessages');
    String path = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  }

  Future<void> deleteMessage(MyMessage message, int index) async {
    String path = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onSendMessage(MyMessage message) async {
    String chatRoomPath = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  }

  Future<void> _sendNotification(MyMessage message) async {}

  void _setLastMessage(MyMessage message) {}

  void DeleteLastMessage(MyMessage message) {
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

class SendMessageBox extends StatefulWidget {
  final Function(MyMessage) onSendMessage;

  const SendMessageBox({
    required this.onSendMessage,
    Key? key,
  }) : super(key: key);

  @override
  _SendMessageBoxState createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final _messageController = TextEditingController();
  List<bool>? _fileProcessing;
  // List<MyAssetEntity> _myAssetsEntities = [];
  bool _isSending = false;

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
                Stack(
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
                    controller: _messageController,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: messageBoxDecoration.copyWith(
                      hintText: 'Type your messages ...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    debugPrint('_SendMessageBoxState.build');
                    // if ((_messageController?.text?.trim()?.isNotEmpty ??
                    //         false) ||
                    //     _myAssetsEntities.isNotEmpty) _sendMessage();
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

  Future<void> _sendMessage() async {}

  _onImagePicker() async {}
}

optionsDialog(BuildContext context, Function() ontap) {
  return showDialog(
      context: context,
      builder: (ctx) {
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
