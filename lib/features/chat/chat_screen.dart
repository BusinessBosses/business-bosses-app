import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../action/action.dart';
import '../../common/dialogs/snackbar.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/un_read_dot.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';
import '../search/search_app_bar.dart';
import 'app_chats.dart';
import 'chat_room_screen.dart';
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
  bool _isInit = false;
  bool _isLoading = true;
  bool _isSearching = false;
  List<LastMessage> _myChatUsers = [];
  List<LastMessage> _searchedChats = [];

  Future<void> _listenMyChatUsers() async {}

  @override
  void initState() {
    super.initState();
    _listenMyChatUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _myChatUsers = appChat.myChats;
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          _onCloseSearching();
          return false;
        }
        navigateTo(context);
        return true;
      },
      child: Scaffold(
        appBar: _isSearching
            ? SearchAppBar(
                hintText: 'Search messages',
                onClose: _onChangeSearching,
                onChange: _onSearch,
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
            _myChatUsers.isEmpty
                ? SafetyModel(
                    isLoading: _isLoading,
                    icon: const Icon(
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
                    itemCount: _myChatUsers.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ChatItem(
                        myChatUser: _myChatUsers[i],
                        // key: ValueKey(_myChatUsers[i].user?.uid),
                      );
                    },
                  ),
            if (_isSearching)
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _searchedChats.isEmpty
                    ? SafetyModel(
                        mainAxisAlignment: MainAxisAlignment.start,
                        isLoading: _isLoading,
                        icon: SvgPicture.asset('assets/svgs/search.svg',
                            color: hintColor, height: 80.0, width: 80.0),
                        title: 'Search for chats',
                        subTitle: 'Search with name to find',
                      )
                    : ListView.builder(
                        itemCount: _searchedChats.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ChatItem(
                            myChatUser: _searchedChats[i],
                            key: ValueKey(_searchedChats[i].user?.uid),
                          );
                        },
                      ),
              )
          ],
        ),
      ),
    );
  }

  void _onChangeSearching() {
    setState(() {
      _isSearching = !_isSearching;
      _searchedChats = [];
    });
  }

  void _onSearch(String val) {
    if (val == null || val.trim().isEmpty) return;
    final List<LastMessage> data = _myChatUsers.where((LastMessage e) {
      return e.user!.name!.toLowerCase().contains(val.trim().toLowerCase());
    }).toList();
    setState(() {
      _searchedChats = data;
    });
  }

  void _onCloseSearching() {
    setState(() {
      _isSearching = false;
      _searchedChats = [];
    });
  }
}

// ignore: public_member_api_docs
class ChatItem extends StatefulWidget {
  // const ChatItem({Key? key}) : super(key: key);
  // ignore: public_member_api_docs
  final LastMessage myChatUser;
  // final Key key;
  // ignore: public_member_api_docs
  const ChatItem({
    Key? key,
    required this.myChatUser,
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
          context,
          routeName: ChatRoomScreen.routeName,
          arguments: widget.myChatUser.user,
        );
      },
      child: Container(
        key: widget.key,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            widget.myChatUser.isRead ?? true ? Container() : const UnReadDot(),
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
                        child: Text(
                          widget.myChatUser.user?.name ?? "",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Text(
                        TimeFormat.formatString(widget.myChatUser.timestamp!),
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
                                widget.myChatUser.text!,
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
    );
  }

  Future<void> deleteChat() async {}

  // ignore: always_declare_return_types
  showSnackBAr(String message) {
    Navigator.pop(context);
    showSnackbar(message: message);
  }
}
