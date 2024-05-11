import 'dart:async';
import 'package:business_bosses_v2/common/models/user_model.dart';
// import 'package:flutter/foundation.dart' as foundation;
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/presentation/call_invitation_page.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../action/action.dart';
import '../../common/widgets/buttons/button.dart';
import '../../common/widgets/chat_box.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/models/market_model.dart';
import 'models/my_message.dart';

class ChatRoomScreen extends StatefulWidget {
  static const String routeName = '/chat-room-screen';
  final bool frommarketplace;
  final MarketModel? market;
  const ChatRoomScreen({
    Key? key,
    required this.frommarketplace,
    this.market,
  }) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ProfileController _profileController = Get.find();
  // ignore: unused_field
  final HomeController _homeController = Get.find();
  // ignore: unused_field
  final ChatController _chatController = Get.find();
  late TextEditingController _textEditingController;
  late UserModel args;
  bool showColumn = true;
  // bool showEmoji = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      _textEditingController = TextEditingController();
      args = Get.arguments;
      // print(widget.market!.toMap());
      // _chatController.seen(args.uid);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showColumn = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String? previousScreen = Get.previousRoute;
    return WillPopScope(
      onWillPop: () async {
        navigateTo(context);
        return true;
      },
      child: GetBuilder<ChatController>(
        builder: (ChatController controller) {
          return Scaffold(
            backgroundColor: backgroundcolorinterface,
            appBar: AppBar(
              leading: previousScreen == '/bottomNavScreen'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
              title: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.publicProfile, arguments: args);
                    },
                    trailing: SizedBox(
                      width: 70,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () async {
                                //   Get.to(CallPage(
                                //       callID: "1234",

                                //       ///it was hardcoded
                                //       userId: args.uid,
                                //       username: args.username));
                                Get.to(() => CallInvitationPage(
                                      callerId:
                                          _profileController.myProfile.uid,
                                      recipientId: args.uid,
                                      username: args.username,
                                    ));
                              },
                              icon: SvgPicture.asset('assets/svgs/call.svg')),
                          SizedBox(
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
                  previousScreen == '/marketPlaceScreen'
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Color.fromRGBO(255, 202, 40, 1),
                                size: 16,
                              ),
                              Text(
                                args.averageRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: backgroundcolorinterface,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => SellerReviewScreen(
                                                  user: args));
                                            },
                                            child: Text(
                                              args.averageRating!.toDouble() > 0
                                                  ? 'Seller reviews'
                                                  : 'Rate Seller',
                                              style: const TextStyle(
                                                color: primaryColorLT,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/svgs/nexticon.svg')
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
              toolbarHeight: previousScreen == '/marketPlaceScreen'
                  ? 48.0 + 78.0
                  : 48.0 + 28.0,
            ),
            body: SizedBox(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: controller
                            .extractConversations(
                              args.uid,
                              _profileController.myProfile.uid,
                            )
                            .isEmpty
                        ? widget.frommarketplace
                            ? SizedBox(
                                height: double.infinity,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, right: 20, left: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Stack(
                                            children: <Widget>[
                                              widget.market!.images != null
                                                  ? Image.network(
                                                      widget.market
                                                              ?.images?[0] ??
                                                          '',
                                                      fit: BoxFit.contain,
                                                      height: 350,
                                                      width: double.infinity,
                                                    )
                                                  : Container(),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            '${widget.market?.price}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          DetectableText(
                                                            text:
                                                                '${widget.market?.description}',
                                                            detectionRegExp:
                                                                detectionRegExp(
                                                                    hashtag:
                                                                        false)!,
                                                            detectedStyle:
                                                                bodyText2.copyWith(
                                                                    color: Colors
                                                                        .blue),
                                                            moreStyle: bodyText2
                                                                .copyWith(
                                                                    color: Colors
                                                                        .redAccent),
                                                            lessStyle: bodyText2
                                                                .copyWith(
                                                                    color: Colors
                                                                        .redAccent),
                                                            trimExpandedText:
                                                                '  show less',
                                                            basicStyle: bodyText2
                                                                .copyWith(
                                                                    color:
                                                                        textColor),
                                                            onTap: (_) {},
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          widget.market?.location !=
                                                                      null ||
                                                                  widget.market
                                                                          ?.category !=
                                                                      null
                                                              ? Row(
                                                                  children: <Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                            'assets/svgs/location.svg'),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      '${widget.market?.location}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            subtextColor,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          false,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    SvgPicture
                                                                        .asset(
                                                                            'assets/svgs/category.svg'),
                                                                    const SizedBox(
                                                                        width:
                                                                            3),
                                                                    Text(
                                                                      widget.market!.category!.length >
                                                                              40
                                                                          ? '${widget.market!.category!.substring(0, 40)}...'
                                                                          : widget
                                                                              .market!
                                                                              .category!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            subtextColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            bottom: 200,
                                            right: 20,
                                            top: 20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            color: Colors.grey.shade200,
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                'Safety tips \n\n• Check seller offers buyer protection before making payment \n• On delivery, check that the item delivered is what you ordered \n• Report any seller you have any concerns about',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SafetyModel(
                                isLoading: false,
                                icon: const Icon(
                                  Icons.edit,
                                  size: 80.0,
                                  color: Colors.grey,
                                ),
                                title: 'Initiate conversation now!',
                                subTitle:
                                    'No message sent to ${args.username} yet',
                              )
                        : Stack(children: <Widget>[
                            showColumn
                                ? Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, right: 20, left: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Stack(
                                            children: <Widget>[
                                              if (widget.market?.images != null)
                                                Image.network(
                                                  widget.market?.images?[0],
                                                  fit: BoxFit.cover,
                                                  height: 350,
                                                  width: double.infinity,
                                                ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            '${widget.market?.price}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          DetectableText(
                                                            text:
                                                                '${widget.market?.description}',
                                                            detectionRegExp:
                                                                detectionRegExp(
                                                                    hashtag:
                                                                        false)!,
                                                            detectedStyle:
                                                                bodyText2.copyWith(
                                                                    color: Colors
                                                                        .blue),
                                                            moreStyle: bodyText2
                                                                .copyWith(
                                                                    color: Colors
                                                                        .redAccent),
                                                            lessStyle: bodyText2
                                                                .copyWith(
                                                                    color: Colors
                                                                        .redAccent),
                                                            trimExpandedText:
                                                                '  show less',
                                                            basicStyle: bodyText2
                                                                .copyWith(
                                                                    color:
                                                                        textColor),
                                                            onTap: (_) {},
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          widget.market?.location !=
                                                                      null ||
                                                                  widget.market
                                                                          ?.category !=
                                                                      null
                                                              ? Row(
                                                                  children: <Widget>[
                                                                    SvgPicture
                                                                        .asset(
                                                                            'assets/svgs/location.svg'),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      '${widget.market?.location}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            subtextColor,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          false,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    SvgPicture
                                                                        .asset(
                                                                            'assets/svgs/category.svg'),
                                                                    const SizedBox(
                                                                        width:
                                                                            3),
                                                                    Text(
                                                                      widget.market!.category!.length >
                                                                              15
                                                                          ? '${widget.market!.category!.substring(0, 15)}...'
                                                                          : widget
                                                                              .market!
                                                                              .category!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            subtextColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 75.0,
                                  top: 16.0),
                              reverse: true,
                              itemCount: controller
                                  .extractConversations(args.uid,
                                      _profileController.myProfile.uid)
                                  .length,
                              itemBuilder: (BuildContext context, int i) {
                                final MessageModel message =
                                    controller.extractConversations(args.uid,
                                        _profileController.myProfile.uid)[i];
                                // final reversedIndex = _messages.length - 1 - i;
                                return Column(
                                  children: <Widget>[
                                    InkWell(
                                      onLongPress: () {
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  onTap: () async {
                                                    navigateTo(context);
                                                    await Clipboard.setData(
                                                      ClipboardData(
                                                        text: message
                                                            .messageText!,
                                                      ),
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    showSnackBar(context,
                                                        message:
                                                            'Text Copied!');
                                                  },
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const TextWidget(
                                                    text: 'Copy Text',
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const TextWidget(
                                                              text:
                                                                  'Delete this Message'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Cancel',
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  controller
                                                                      .deleteMessage(
                                                                          message
                                                                              .messageId);
                                                                },
                                                                child:
                                                                    const TextWidget(
                                                                  text:
                                                                      'Delete',
                                                                  color:
                                                                      primaryColorLT,
                                                                ))
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    // optionsDialog(context, () {
                                                    //   // _isLoading = true;
                                                    //   print('sdf');
                                                    //   Navigator.pop(context);
                                                    //   controller.deleteMessage(
                                                    //       message.messageId);
                                                    //   // deleteMessage(
                                                    //   //     _messages[reversedIndex],
                                                    //   //     reversedIndex);
                                                    //   // if (reversedIndex ==
                                                    //   //     _messages.length - 1) {
                                                    //   //   DeleteLastMessage(_messages[
                                                    //   //       reversedIndex]);
                                                    //   // }
                                                    // });
                                                  },
                                                  contentPadding:
                                                      EdgeInsets.zero,
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
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ]),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 10.0,
                    right: 10.0,
                    child: SendMessageBox(
                      onPickImage: () {
                        controller.onPickImage();
                      },
                      onSendMessage: (
                        String message,
                      ) {
                        if (widget.frommarketplace) {
                          controller.addNewChatMarket(
                            <String, dynamic>{
                              'senderUid': _profileController.myProfile.uid,
                              'receiverUid': args.uid,
                              'messageText': message
                            },
                            args,
                            widget.market!.marketId,
                          );
                        } else {
                          controller.addNewChat(
                            <String, dynamic>{
                              'senderUid': _profileController.myProfile.uid,
                              'receiverUid': args.uid,
                              'messageText': message
                            },
                            args,
                          );
                        }
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
    super.dispose();
    _textEditingController.dispose();
  }

  // Future<void> _onSendMessage(MessageModel message) async {
  //   String chatRoomPath = '${Constants.CHAT_ROOMS}/$_chatRoomId';
  // }

  Future<void> _sendNotification(MessageModel message) async {}

  void _setLastMessage(MessageModel message) {}

  void DeleteLastMessage(MessageModel message) {
    // ignore: unused_local_variable
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
  final VoidCallback onPickImage;
  final TextEditingController textEditingController;
  const SendMessageBox({
    Key? key,
    required this.onSendMessage,
    required this.onPickImage,
    required this.textEditingController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String? previousScreen = Get.previousRoute;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    IconButton(
                      onPressed: onPickImage,
                      icon: const Icon(Icons.insert_photo),
                      iconSize: 24.0,
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: messageBoxDecoration.copyWith(
                        hintText: 'Type your messages ...',
                      )),
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
          actions: <Widget>[
            but(context, 'Cancel', true, () {
              Navigator.pop(context);
            }),
            but(context, 'Delete', false, ontap)
          ],
        );
      });
}
