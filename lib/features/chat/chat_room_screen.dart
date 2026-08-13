import 'dart:async';
import 'package:business_bosses_v2/utils/safe_url_launcher.dart';
import 'dart:convert';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/buttons/button.dart';
import '../../common/widgets/chat_box.dart';
import '../../common/widgets/popup/my_popup_menu_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../common/widgets/user_avatar_with_badge.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import 'models/my_message.dart';
import 'package:http/http.dart' as http;

UserModel chatargs = UserModel();

class ChatRoomScreen extends StatefulWidget {
  static const String routeName = '/chat-room-screen';
  final bool frommarketplace;
  final bool fromBuyerRequest;
  const ChatRoomScreen({
    super.key,
    required this.frommarketplace,
    this.fromBuyerRequest = false,
  });

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  final ProfileController _profileController = Get.find();
  final ChatController _chatController = Get.find();
  late TextEditingController _textEditingController;
  late UserModel args;
  bool showColumn = true;

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

  Widget buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      _textEditingController = TextEditingController();

      // Handle different argument types
      if (Get.arguments is Map<String, dynamic>) {
        final Map<String, dynamic> argsMap =
            Get.arguments as Map<String, dynamic>;
        args = argsMap['user'] as UserModel;

        // If coming from a job application, auto-send the job details and the
        // applicant's CV when they attached one.
        if (widget.fromBuyerRequest && argsMap.containsKey('buyerRequest')) {
          final BuyerRequestModel buyerRequest =
              argsMap['buyerRequest'] as BuyerRequestModel;
          final String? cvUrl = argsMap['cvUrl'] as String?;
          final String? cvName = argsMap['cvName'] as String?;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _sendBuyerRequestMessage(buyerRequest);
            if (cvUrl != null && cvUrl.isNotEmpty) {
              _sendCvMessage(cvUrl, cvName);
            }
          });
        }
      } else {
        args = Get.arguments as UserModel;
      }
      chatargs = args;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showColumn = false;
      });
    });
  }

  void _showBuyerRequestDetails(BuyerRequestModel request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (request.imageUrl != null &&
                      request.imageUrl!.isNotEmpty) ...<Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        request.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (CurrencyFormatter.budgetRange(
                          request.budgetStart, request.budgetEnd) !=
                      null) ...<Widget>[
                    buildDetailRow(
                      Icons.attach_money,
                      'Budget',
                      CurrencyFormatter.budgetRange(
                          request.budgetStart, request.budgetEnd)!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  buildDetailRow(
                    Icons.category,
                    'Category',
                    request.category,
                  ),
                  const SizedBox(height: 8),
                  if (request.deadline.isNotEmpty)
                    buildDetailRow(
                      Icons.calendar_today,
                      'Deadline',
                      DateFormat('MMMM dd, yyyy').format(
                        DateTime.tryParse(request.deadline) ?? DateTime.now(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Renders an attached CV as a card the poster can tap to open/download.
  Widget _buildCvCard(MessageModel message) {
    String name = 'CV';
    String url = '';

    try {
      final Map<String, dynamic> data = jsonDecode(
        (message.messageText ?? '').replaceFirst('JOB_CV::', ''),
      ) as Map<String, dynamic>;
      name = (data['name'] as String?)?.trim().isNotEmpty == true
          ? data['name'] as String
          : 'CV';
      url = (data['url'] as String?) ?? '';
    } catch (_) {
      return const SizedBox.shrink();
    }

    if (url.isEmpty) return const SizedBox.shrink();

    final bool isMine = message.senderUid == _profileController.myProfile.uid;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () async {
          final Uri? uri = Uri.tryParse(url);
          if (uri == null) return;
          if (!await openUrl(uri, mode: LaunchMode.externalApplication)) {
            _showSnackBar('Could not open this file');
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(maxWidth: Get.width * 0.72),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColorLT.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.description_outlined,
                  color: primaryColorLT, size: 22),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'CV attached',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColorLT,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.download_rounded, size: 18, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyerRequestCard(MessageModel message) {
    bool isValidImageUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      final Uri? uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasAbsolutePath &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    }

    try {
      final String messageText = message.messageText ?? '';
      if (!messageText.startsWith('BUYER_REQUEST::')) {
        return const SizedBox.shrink();
      }

      final String jsonStr = messageText.replaceFirst('BUYER_REQUEST::', '');
      final Map<String, dynamic> requestData =
          jsonDecode(jsonStr) as Map<String, dynamic>;
      final BuyerRequestModel request = BuyerRequestModel.fromJson(requestData);
      final bool hasValidImage = isValidImageUrl(request.imageUrl);

      return GestureDetector(
        onTap: () => _showBuyerRequestDetails(request),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColorLT.withValues(alpha: 0.3)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: primaryColorLT,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Job Application',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColorLT,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF757575),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                request.description,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  if (CurrencyFormatter.budgetRange(
                          request.budgetStart, request.budgetEnd) !=
                      null) ...<Widget>[
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      CurrencyFormatter.budgetRange(
                          request.budgetStart, request.budgetEnd)!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.category,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (hasValidImage) ...<Widget>[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    request.imageUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) =>
                        Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error parsing buyer request: $e');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? previousScreen = Get.previousRoute;
    return PopScope(
      canPop: true,
      child: GetBuilder<ChatController>(
        builder: (ChatController controller) {
          final List<MessageModel> conversations =
              controller.extractConversations(
            args.uid,
            _profileController.myProfile.uid,
          );

          return Scaffold(
            backgroundColor: backgroundcolorinterface,
            appBar: AppBar(
              actions: <Widget>[
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3000)),
                  padding: const EdgeInsets.all(14),
                  child: MyPopupMenuButton(
                    popupItems: _popupItemForumMore,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (String val) {
                      _deleteChat();
                    },
                  ),
                ),
              ],
              leading: previousScreen == '/bottomNavScreen'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 0.0),
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
                    trailing: const SizedBox(
                      width: 70,
                      child: Row(
                        children: <Widget>[],
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 0),
                    title: Text(
                      args.name ?? args.username,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    leading: UserAvatarWithBadge(
                      user: args,
                      height: 40.0,
                      width: 40.0,
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
                          ?.copyWith(color: textColor.withValues(alpha: 0.6)),
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
                                                fontWeight: FontWeight.w600,
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
                    child: conversations.isEmpty
                        ? SafetyModel(
                                isLoading: false,
                                icon: const Icon(
                                  Icons.edit,
                                  size: 80.0,
                                  color: Color(0xFF616161),
                                ),
                                title: 'Initiate conversation now!',
                                subTitle:
                                    'No message sent to ${args.username} yet',
                              )
                        : Stack(children: <Widget>[
                            ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 7.0,
                                  right: 15.0,
                                  bottom: 75.0,
                                  top: 16.0),
                              reverse: true,
                              itemCount: conversations.length,
                              itemBuilder: (BuildContext context, int i) {
                                final MessageModel message = conversations[i];

                                // Check if this is a buyer request message
                                if (message.messageText
                                        ?.startsWith('BUYER_REQUEST::') ??
                                    false) {
                                  return _buildBuyerRequestCard(message);
                                }

                                // Attached CV from a job application
                                if (message.messageText
                                        ?.startsWith('JOB_CV::') ??
                                    false) {
                                  return _buildCvCard(message);
                                }

                                // Handle call messages
                                if (message.messageText
                                        ?.contains('ccaalliidd') ??
                                    false) {
                                  return Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {},
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
                                                      Navigator.of(context)
                                                          .pop();
                                                      await Clipboard.setData(
                                                        ClipboardData(
                                                          text: message
                                                              .messageText!,
                                                        ),
                                                      );
                                                      _showSnackBar(
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
                                                          .pop();
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
                                                                  onPressed:
                                                                      () {
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    controller.deleteMessage(
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
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 4,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white70
                                                            .withValues(
                                                                alpha: 0.47)),
                                                    child: Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      alignment:
                                                          WrapAlignment.end,
                                                      children: <Widget>[
                                                        Stack(
                                                            children: <Widget>[
                                                              const SizedBox(
                                                                height: 50,
                                                                width: 50,
                                                              ),
                                                              UserAvatarWithBadge(
                                                                user: args,
                                                                height: 32.0,
                                                                width: 32.0,
                                                                radius: 50.0,
                                                                placeHolder:
                                                                    Icons
                                                                        .person,
                                                                iconSize: 36.0,
                                                              ),
                                                              Positioned(
                                                                left: 15,
                                                                top: 15,
                                                                child:
                                                                    UserAvatarWithBadge(
                                                                  user: _profileController
                                                                      .myProfile,
                                                                  height: 32.0,
                                                                  width: 32.0,
                                                                  radius: 50.0,
                                                                  placeHolder:
                                                                      Icons
                                                                          .person,
                                                                  iconSize:
                                                                      36.0,
                                                                ),
                                                              ),
                                                            ]),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green
                                                                  .withValues(
                                                                      alpha:
                                                                          0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: const Icon(
                                                            Icons.call,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Text(
                                                          'Join Call',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Regular message
                                return Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {},
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
                                                    Navigator.of(context).pop();
                                                    await Clipboard.setData(
                                                      ClipboardData(
                                                        text: message
                                                            .messageText!,
                                                      ),
                                                    );
                                                    _showSnackBar(
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
                                                    Navigator.of(context).pop();
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
                        _chatController.onPickImage();
                      },
                      onSendMessage: (
                        String message,
                      ) {
                        _chatController.addNewChat(
                          <String, dynamic>{
                            'senderUid': _profileController.myProfile.uid,
                            'receiverUid': args.uid,
                            'messageText': message
                          },
                          args,
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

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Future<void> _deleteChat() async {
    // Implement delete chat functionality
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      _chatController.deleteChat(args.uid);
      Get.back();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Sends the applicant's CV as a follow-up message the poster can open.
  void _sendCvMessage(String url, String? name) {
    final String cvMessage = 'JOB_CV::${jsonEncode(<String, String>{
          'url': url,
          'name': name ?? 'CV',
        })}';

    _chatController.addNewChat(
      <String, dynamic>{
        'senderUid': _profileController.myProfile.uid,
        'receiverUid': args.uid,
        'messageText': cvMessage,
      },
      args,
    );
  }

  void _sendBuyerRequestMessage(BuyerRequestModel request) {
    final String requestMessage =
        'BUYER_REQUEST::${jsonEncode(request.toJson())}';

    _chatController.addNewChat(
      <String, dynamic>{
        'senderUid': _profileController.myProfile.uid,
        'receiverUid': args.uid,
        'messageText': requestMessage,
      },
      args,
    );
  }
}

class SendMessageBox extends StatelessWidget {
  final Function(String) onSendMessage;
  final VoidCallback onPickImage;
  final TextEditingController textEditingController;
  const SendMessageBox({
    super.key,
    required this.onSendMessage,
    required this.onPickImage,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 70.0,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
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
                        filled: true,
                        fillColor: Colors.white,
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

Future<void> optionsDialog(BuildContext context, Function() ontap) {
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

class StartCallDialog extends StatelessWidget {
  final String callerId;
  final String recipientId;

  const StartCallDialog(
      {super.key, required this.callerId, required this.recipientId});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final ChatController chatController = Get.find();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Start Instant Call',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: FutureBuilder<String>(
        future: startCall(<String, dynamic>{
          'callerId': callerId,
          'recipientId': recipientId,
        }),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Failed to start call: ${snapshot.error}');
          } else {
            final String? callId = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Call ID: $callId'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          chatController.addNewChat(
                            <String, dynamic>{
                              'senderUid': profileController.myProfile.uid,
                              'receiverUid': chatargs.uid,
                              'messageText': '$callId' 'ccaalliidd'
                            },
                            chatargs,
                          );
                          Get.back();
                        },
                        child: Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                                color: primaryColorLT,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'Send Call ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: callId!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Call ID copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.content_copy),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> startCall(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constants.ACCESS_TOKEN) ?? '';

    final http.Response response = await http.post(
      Uri.parse(
          'https://orca-app-5dg8w.ondigitalocean.app/share/initiate-call'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final ApiResponseModel data =
          ApiResponseModel.fromMap(jsonDecode(response.body));
      return data.data['callId'] as String;
    } else {
      throw Exception('Failed to start call: ${response.statusCode}');
    }
  }
}
