import 'dart:async';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../action/action.dart';
import '../../common/dialogs/snackbar.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/un_read_dot.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';
import '../search/widgets/search_app_bar.dart';
import 'models/last_message.dart';

// ignore: public_member_api_docs
class ChatScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/chats-screen';

  // ignore: public_member_api_docs
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.find();

  bool _isSearching = false;
  final List<LastMessage> _myChats = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          _onCloseSearching();
          _chatController.clearSearch();
          return false;
        }
        navigateTo(context);
        return true;
      },
      child: GetBuilder<ChatController>(
        builder: (ChatController controller) {
          return Scaffold(
            appBar: _isSearching
                ? SearchAppBar(
                    hintText: 'Search messages',
                    onClose: _onChangeSearching,
                    onChange: (String query) {
                      controller.searchChats(query);
                    },
                  )
                : AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                    centerTitle: true,
                    title: const Text('Chats'),
                    actions: [
                      IconButton(
                        onPressed: _onChangeSearching,
                        icon: SvgPicture.asset('assets/svgs/search.svg'),
                      )
                    ],
                  ),
            body: Stack(
              children: [
                controller.chatMessages.isEmpty
                    ? const SafetyModel(
                        isLoading: false,
                        icon: Icon(
                          Icons.person,
                          size: 80.0,
                          color: Colors.grey,
                        ),
                        title: 'No chat found',
                        subTitle:
                            'Search for friends or connections and chat with them',
                        clickableText: 'Search connections',
                        // onTap: () => navigateTo(
                        //   context,
                        //   routeName: UsersSearchScreen.routeName,
                        // ),
                      )
                    : ListView.builder(
                        itemCount: controller.chats.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ChatItem(
                            myChatUser: controller.chats[i],
                            chatController: controller,
                            // key: ValueKey(_myChats[i].user?.uid),
                          );
                        },
                      ),
                if (_isSearching)
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: controller.searchedChats.isEmpty
                        ? SafetyModel(
                            mainAxisAlignment: MainAxisAlignment.start,
                            isLoading: false,
                            icon: SvgPicture.asset('assets/svgs/search.svg',
                                color: hintColor, height: 80.0, width: 80.0),
                            title: 'Search for chats',
                            subTitle: 'Search with name to find',
                          )
                        : ListView.builder(
                            itemCount: controller.searchedChats.length,
                            itemBuilder: (BuildContext context, int i) {
                              return ChatItem(
                                myChatUser: controller.searchedChats[i],
                                key: ValueKey(
                                    controller.searchedChats[i].user!.uid),
                                chatController: controller,
                              );
                            },
                          ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onChangeSearching() {
    setState(() {
      _isSearching = !_isSearching;

      // _searchedChats = [];
    });
  }

  void _onSearch(String val) {
    if (val.trim().isEmpty) return;
    final List<LastMessage> data = _myChats.where((LastMessage e) {
      return e.user!.name!.toLowerCase().contains(val.trim().toLowerCase());
    }).toList();
    setState(() {
      // _searchedChats = data;
    });
  }

  void _onCloseSearching() {
    setState(() {
      _isSearching = false;
      // _searchedChats = [];
    });
  }
}

// ignore: public_member_api_docs
class ChatItem extends StatefulWidget {
  // const ChatItem({Key? key}) : super(key: key);
  // ignore: public_member_api_docs
  final MessageModel myChatUser;
  final ChatController chatController;

  // final Key key;
  // ignore: public_member_api_docs
  const ChatItem({
    Key? key,
    required this.myChatUser,
    required this.chatController,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final List<PopupMenuEntry<String>> _popupItemForumMore = [
    const PopupMenuItem<String>(
      value: 'Delete Chat',
      child: Text(
        'Delete Chat',
        style: bodyText2,
      ),
    ),
  ];

  final ProfileController _profileController = Get.find();
  final HomeController _homeController = Get.find();

  bool getUnreadMessages() {
    final List<MessageModel> unread = widget.chatController.chatMessages
        .where((MessageModel element) =>
            element.receiverUid == _profileController.myProfile.uid &&
            element.senderUid == widget.myChatUser.user!.uid &&
            !element.seen)
        .toList();
    return unread.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return widget.myChatUser.user != null
        ? InkWell(
            onTap: () {
              widget.chatController
                  .seen(widget.myChatUser.user!.uid, _homeController.socket);
              Get.to(
                () => const ChatRoomScreen(
                  frommarketplace: false,
                ),
                arguments: widget.myChatUser.user,
              );
            },
            child: Container(
              key: widget.key,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (getUnreadMessages()) const UnReadDot() else Container(),
                  Container(
                    width: 80.0,
                    alignment: Alignment.center,
                    child: UserAvatarWithBadge(
                      user: widget.myChatUser.user,
                      height: 52.0,
                      width: 52.0,
                      radius: 50.0,
                      placeHolder: Icons.person,
                      iconSize: 36.0,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: widget.myChatUser.user!.isSubscribed ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            widget.myChatUser.user!.name !=
                                                        null &&
                                                    widget.myChatUser.user!
                                                            .name!.length <=
                                                        20
                                                ? widget.myChatUser.user!.name!
                                                : widget.myChatUser.user!
                                                            .name !=
                                                        null
                                                    ? '${widget.myChatUser.user!.name!.substring(0, 20)}...'
                                                    : widget.myChatUser.user!
                                                        .username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          const SizedBox(width: 5),
                                          SvgPicture.asset(
                                            'assets/svgs/premiumbadge.svg',
                                            height: 9,
                                            color: primaryColorLT,
                                          )
                                        ],
                                      ),
                                    )
                                  : Text(
                                      widget.myChatUser.user!.name != null &&
                                              widget.myChatUser.user!.name!
                                                      .length <=
                                                  20
                                          ? widget.myChatUser.user!.name!
                                          : widget.myChatUser.user!.name != null
                                              ? '${widget.myChatUser.user!.name!.substring(0, 20)}...'
                                              : widget
                                                  .myChatUser.user!.username,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                            ),
                            Text(
                              TimeFormat.formatString(
                                  widget.myChatUser.timestamp),
                              style: bodyText2.copyWith(
                                color: hintColor,
                              ),
                            ),
                            SizedBox(
                              // color: Colors.redAccent,
                              height: 22,
                              width: 22,
                              child: MyPopupMenuButton(
                                popupItems: _popupItemForumMore,
                                icon: const Icon(Icons.more_vert),
                                onSelected: (String val) {
                                  deleteChat();
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: widget.myChatUser.deleted == true
                                  ? Text(
                                      'This message was deleted.',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.red,
                                          ),
                                    )
                                  : Text(
                                      widget.myChatUser.messageText ?? 'Image',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: textColor.withOpacity(0.8),
                                          ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Future<void> deleteChat() async {
    final UserModel chatParty = widget.myChatUser.user!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWidget(
              text: 'All Messages with ${chatParty.username} will be deleted'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const TextWidget(
                  text: 'Cancel',
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.chatController.deleteChat(chatParty.uid);
                },
                child: const TextWidget(
                  text: 'Delete',
                  color: primaryColorLT,
                ))
          ],
        );
      },
    );
  }

  // ignore: always_declare_return_types
  showSnackBAr(String message) {
    Navigator.pop(context);
    showSnackbar(message: message);
  }
}
