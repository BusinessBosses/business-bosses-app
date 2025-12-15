import 'dart:async';
import 'package:business_bosses_v2/bbpro/presentation/campaign_page.dart';
import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../common/dialogs/snackbar.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';
import '../search/widgets/search_app_bar.dart';
// import 'models/last_message.dart';

// ignore: public_member_api_docs
class ChatScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/chats-screen';

  // ignore: public_member_api_docs
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.find();
  final ProfileController _profileController = Get.find();
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();

  bool _isSearching = false;
  // final List<LastMessage> _myChats = <LastMessage>[];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        if (_isSearching) {
          _onCloseSearching();
          _chatController.clearSearch();
        }
      },
      child: GetBuilder<ChatController>(
        builder: (ChatController controller) {
          return AdvancedDrawer(
            backdrop: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white,
                    Colors.white.withValues(alpha: 0.2)
                  ],
                ),
              ),
            ),
            controller: _advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            // openScale: 1.0,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              // NOTICE: Uncomment if you want to add shadow behind the page.
              // Keep in mind that it may cause animation jerks.
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),

            drawer: DrawerContent(
              oncloseclick: () {
                _advancedDrawerController.hideDrawer();
              },
              currentuser: _profileController.myProfile,
              hasUnreadNotification:
                  _profileController.myProfile.unReadCount != null &&
                      _profileController.myProfile.unReadCount! > 0,
            ),

            child: Scaffold(
              // floatingActionButton: Floatingbutton(),
              backgroundColor: Colors.white,
              appBar: _isSearching
                  ? searchAppBar(
                      hintText: 'Search messages',
                      onClose: _onChangeSearching,
                      onChange: (String query) {
                        controller.searchChats(query);
                      },
                    )
                  : AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      title: const Text(
                        'Inbox',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 20),
                      ),
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            spacing: 10,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _profileController.myProfile.isSubscribed ==
                                          true
                                      ? Get.to(() => const Campaignpage())
                                      : Get.bottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                            ),
                                            height: Get.height * 0.9,
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  PremiumScreen(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        );
                                },
                                child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: backgroundColor,
                                    child: SvgPicture.asset(
                                      'assets/svgs/campaign.svg',
                                      height: 20,
                                    )),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(Routes.notifications),
                                child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: backgroundColor,
                                    child: Icon(
                                      LucideIcons.bell,
                                      color: textColor,
                                      size: 20,
                                    )),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _advancedDrawerController.showDrawer();
                                  },
                                  child: const CustomMenuButton())
                            ],
                          ),
                        )
                      ],
                    ),
              body: Stack(
                children: <Widget>[
                  controller.chatMessages.isEmpty
                      ? SafetyModel(
                          isLoading: false,
                          icon: SvgPicture.asset(
                            'assets/svgs/message.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                            height: 80,
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
                      : Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _onChangeSearching();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: backgroundColor,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: backgroundColor,
                                        child: SvgPicture.asset(
                                          'assets/svgs/homesearch.svg',
                                          colorFilter: const ColorFilter.mode(
                                            textColor,
                                            BlendMode.srcIn,
                                          ),
                                          height: 20,
                                        ),
                                      ),
                                      const Text(
                                        'Search Chats',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 200),
                                itemCount: controller.chats.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Column(
                                    children: <Widget>[
                                      ChatItem(
                                        myChatUser: controller.chats[i],
                                        chatController: controller,
                                        // key: ValueKey(_myChats[i].user?.uid),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Divider(
                                          height: 0.5,
                                          color: Colors.grey
                                              .withValues(alpha: 0.05),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                  if (_isSearching)
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: controller.searchedChats.isEmpty
                          ? SafetyModel(
                              mainAxisAlignment: MainAxisAlignment.start,
                              isLoading: false,
                              icon: SvgPicture.asset(
                                'assets/svgs/search.svg',
                                colorFilter: const ColorFilter.mode(
                                    hintColor, BlendMode.srcIn),
                                height: 80.0,
                                width: 80.0,
                              ),
                              title: 'Search for chats',
                              subTitle: 'Search with name to find',
                            )
                          : ListView.builder(
                              itemCount: controller.searchedChats.length,
                              itemBuilder: (BuildContext context, int i) {
                                return ChatItem(
                                  myChatUser: controller.searchedChats[i],
                                  key: ValueKey<String>(
                                      controller.searchedChats[i].user!.uid),
                                  chatController: controller,
                                );
                              },
                            ),
                    ),
                  BottomBar(activeIndex: 1),
                ],
              ),
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

  // void _onSearch(String val) {
  //   if (val.trim().isEmpty) return;
  //   // ignore: unused_local_variable
  //   final List<LastMessage> data = _myChats.where((LastMessage e) {
  //     return e.user!.name!.toLowerCase().contains(val.trim().toLowerCase());
  //   }).toList();
  //   setState(() {
  //     // _searchedChats = data;
  //   });
  // }

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
    super.key,
    required this.myChatUser,
    required this.chatController,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final List<PopupMenuEntry<String>> _popupItemForumMore =
      <PopupMenuEntry<String>>[
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

  int getUnreadMessagesCount() {
    final List<MessageModel> unread = widget.chatController.chatMessages
        .where((MessageModel element) =>
            element.receiverUid == _profileController.myProfile.uid &&
            element.senderUid == widget.myChatUser.user!.uid &&
            !element.seen)
        .toList();
    return unread.length;
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
              padding:
                  const EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10),
              child: Row(
                children: <Widget>[
                  Stack(children: <Widget>[
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
                    if (getUnreadMessagesCount() > 0)
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: primaryColorLT,
                          child: Text(
                            '${getUnreadMessagesCount()}',
                            style: bodyText2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ]),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: widget.myChatUser.user!.isSubscribed ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Row(
                                        children: <Widget>[
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
                                            colorFilter: ColorFilter.mode(
                                                primaryColorLT,
                                                BlendMode.srcIn),
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
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              // ignore: unrelated_type_equality_checks
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
                                  : widget.myChatUser.messageText != null
                                      ? widget.myChatUser.messageText!
                                              .startsWith('BUYER_REQUEST::')
                                          ? Text('Buyer Request')
                                          : Text(
                                              widget.myChatUser.messageText ??
                                                  'Image',
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: textColor.withValues(
                                                        alpha: 0.8),
                                                  ),
                                            )
                                      : SizedBox(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        TimeFormat.formatString(widget.myChatUser.timestamp),
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
                      ),
                    ],
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
          actions: <Widget>[
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
  void showSnackBAr(String message) {
    Navigator.pop(context);
    showSnackbar(message: message);
  }
}
