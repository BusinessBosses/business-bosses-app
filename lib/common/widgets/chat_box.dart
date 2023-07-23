import 'dart:io';

import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:flutter/material.dart';

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

  // ignore: public_member_api_docs
  const ChatBox(
    this.message, {
    Key? key,
    this.chatTextSize,
    required this.myUid,
    this.onTap,
    this.post,
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
                                            if (message.isRawImage ?? false) {
                                              return;
                                            }
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
                                              if (message.isRawImage ?? false)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.file(
                                                    File(message.image!),
                                                    width: size.width * 0.6,
                                                    height: size.width * 0.6,
                                                  ),
                                                )
                                              else
                                                NetworkImageWithPlaceHolder(
                                                  imageUrl: message.image,
                                                  width: size.width * 0.6,
                                                  height: size.width * 0.6,
                                                  cacheHeight: 120,
                                                  cacheWidth: 120,
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
                                            if (message.isRawImage ?? false) {
                                              return;
                                            }
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
                                              if (message.isRawImage ?? false)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.file(
                                                    File(message.image!),
                                                    width: size.width * 0.6,
                                                    height: size.width * 0.6,
                                                  ),
                                                )
                                              else
                                                NetworkImageWithPlaceHolder(
                                                  imageUrl: message.image,
                                                  width: size.width * 0.6,
                                                  cacheHeight: 120,
                                                  cacheWidth: 120,
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
