import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/chat/models/my_message.dart';
import '../../features/posts/widgets/images_viewer_screen.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';
import 'network_image_with_placeholder.dart';

class ChatBox extends StatelessWidget {
  final MessageModel message;
  final ChatTextSize? chatTextSize;
  final String myUid;
  final Function()? onTap;
  final MarketModel? post;
  final String? frommarketplace;

  // ignore: public_member_api_docs
  const ChatBox(
    this.message, {
    Key? key,
    this.chatTextSize,
    required this.myUid,
    this.onTap,
    this.post,
    this.frommarketplace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return message.senderUid != myUid
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              message.deleted!.contains('myId') ||
                      message.deleted!.contains(message.senderUid)
                  ? Text(
                      'This message was deleted.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: chatTextSize == null ? null : 16.0,
                          ),
                    )
                  : Flexible(
                      //Wrapping the container with flexible widget
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(radiusValue),
                            topRight: Radius.circular(radiusValue),
                            bottomRight: Radius.circular(radiusValue),
                          ),
                          child: Ink(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(radiusValue),
                                topRight: Radius.circular(radiusValue),
                                bottomRight: Radius.circular(radiusValue),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  //We only want to wrap the text message with flexible widget
                                  child: Column(
                                    crossAxisAlignment: message.image != null
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      if (message.image != null)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagesViewerScreen(
                                                  urls: [message.image!],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              NetworkImageWithPlaceHolder(
                                                imageUrl: message.image,
                                                width: size.width * 0.6,
                                                height: size.width * 0.6,
                                                cacheHeight: 90,
                                                cacheWidth: 90,
                                                placeHolder: Icons.photo,
                                                iconSize: 36.0,
                                              ),
                                              // multiImageIcon(message.images!)
                                            ],
                                          ),
                                        ),
                                      Container(
                                        child: message.messageText != null &&
                                                message.messageText!
                                                    .trim()
                                                    .isNotEmpty
                                            ? Text(
                                                message.messageText!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          chatTextSize == null
                                                              ? null
                                                              : 16.0,
                                                    ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              if (message.timestamp != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(TimeFormat.formatString(message.timestamp)),
                ),
            ],
          )
        : Column(
            children: [
              frommarketplace == 'yes'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/img1.png',
                                    fit: BoxFit.cover,
                                    height: 300,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, top: 20),
                                          child: Column(
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'price',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              DetectableText(
                                                text: 'post description',
                                                detectionRegExp:
                                                    detectionRegExp(
                                                        hashtag: false)!,
                                                detectedStyle:
                                                    bodyText2.copyWith(
                                                  color: Colors.blue,
                                                ),
                                                moreStyle: bodyText2.copyWith(
                                                  color: Colors.redAccent,
                                                ),
                                                lessStyle: bodyText2.copyWith(
                                                  color: Colors.redAccent,
                                                ),
                                                trimExpandedText: '  show less',
                                                basicStyle: bodyText2.copyWith(
                                                    color: textColor),
                                                onTap: (_) {},
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/svgs/location.svg'),
                                                  const SizedBox(
                                                    width: 1,
                                                  ),
                                                  const Text(
                                                    'location',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: subtextColor),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SvgPicture.asset(
                                                      'assets/svgs/category.svg'),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  const Text(
                                                    'category',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: subtextColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: backgroundColor,
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                      'Safety tips \n\n\• Check seller offers buyer protection before making payment \n\• On delivery, check that the item delivered is what you ordered \n\• Report any seller you’ve any concerns about'),
                                ),
                              ),
                            ),
                          ),
                        ])
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (message.timestamp != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(TimeFormat.formatString(message.timestamp)),
                    ),
                  message.deleted!.contains('myId')
                      ? Text(
                          'This message was deleted.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                                fontSize: chatTextSize == null ? null : 16.0,
                              ),
                        )
                      : Flexible(
                          //Wrapping the container with flexible widget
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(radiusValue),
                                topLeft: Radius.circular(radiusValue),
                                bottomRight: Radius.circular(radiusValue),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  //We only want to wrap the text message with flexible widget
                                  child: Column(
                                    crossAxisAlignment: message.deleted != null
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      if (message.image != null)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ImagesViewerScreen(
                                                  urls: [message.image!],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              NetworkImageWithPlaceHolder(
                                                imageUrl: message.image,
                                                width: size.width * 0.6,
                                                cacheHeight: 90,
                                                cacheWidth: 90,
                                                height: size.width * 0.6,
                                                placeHolder: Icons.photo,
                                                iconSize: 36.0,
                                              ),
                                              // multiImageIcon(message.images!)
                                            ],
                                          ),
                                        ),
                                      Container(
                                        child: message.messageText != null &&
                                                message.messageText!
                                                    .trim()
                                                    .isNotEmpty
                                            ? Text(
                                                message.messageText!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontSize:
                                                          chatTextSize == null
                                                              ? null
                                                              : 18.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ],
          );
  }

  // Widget multiImageIcon(List<String> images) {
  //   return images.length <= 1
  //       ? Container()
  //       : Positioned(
  //           bottom: 8.0,
  //           right: 8.0,
  //           child: Container(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  //             decoration: BoxDecoration(
  //                 color: primaryColorLT.withOpacity(0.5),
  //                 borderRadius: BorderRadius.circular(30.0)),
  //             child: Row(
  //               children: [
  //                 const Icon(
  //                   Icons.content_copy,
  //                   size: 18.0,
  //                   color: Colors.white,
  //                 ),
  //                 const SizedBox(width: 8.0),
  //                 Text(
  //                   '${message.images!.length - 1}',
  //                   style: bodyText1.copyWith(
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  // }
}

enum ChatTextSize { normal, medium, large }
