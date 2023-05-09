import 'package:flutter/material.dart';

import '../../features/chat/models/my_message.dart';
import '../../features/posts/presentation/widgets/images_viewer_screen.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';
import 'network_image_with_placeholder.dart';

class ChatBox extends StatelessWidget {
  final MyMessage message;
  final ChatTextSize? chatTextSize;
  final Function()? onTap;

  const ChatBox(
    this.message, {
    Key? key,
    this.chatTextSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return message.senderUid != 'FirebaseAuth.instance.currentUser.uid'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              message.singleDeletedBy!.contains('myId') ||
                      message.singleDeletedBy!.contains(message.senderUid)
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
                                    crossAxisAlignment:
                                        (message.images?.length ?? -1) > 0
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                    children: [
                                      if ((message.images?.length ?? -1) > 0)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImagesViewerScreen(
                                                  urls: message.images,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              NetworkImageWithPlaceHolder(
                                                imageUrl: message.images![0],
                                                width: size.width * 0.6,
                                                height: size.width * 0.6,
                                                cacheHeight: 90,
                                                cacheWidth: 90,
                                                placeHolder: Icons.photo,
                                                iconSize: 36.0,
                                              ),
                                              multiImageIcon(message.images!)
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
                  child: Text(TimeFormat.formatString(message.timestamp!)),
                ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (message.timestamp != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(TimeFormat.formatString(message.timestamp!)),
                ),
              message.singleDeletedBy!.contains('myId')
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
                                crossAxisAlignment:
                                    (message.images?.length ?? -1) > 0
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                children: [
                                  if ((message.images?.length ?? -1) > 0)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImagesViewerScreen(
                                              urls: message.images,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          NetworkImageWithPlaceHolder(
                                            imageUrl: message.images![0],
                                            width: size.width * 0.6,
                                            cacheHeight: 90,
                                            cacheWidth: 90,
                                            height: size.width * 0.6,
                                            placeHolder: Icons.photo,
                                            iconSize: 36.0,
                                          ),
                                          multiImageIcon(message.images!)
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
                                                  fontSize: chatTextSize == null
                                                      ? null
                                                      : 18.0,
                                                  fontWeight: FontWeight.w600,
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
          );
  }

  Widget multiImageIcon(List<String> images) {
    return images.length <= 1
        ? Container()
        : Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                  color: primaryColorLT.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: [
                  const Icon(
                    Icons.content_copy,
                    size: 18.0,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '${message.images!.length - 1}',
                    style: bodyText1.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

enum ChatTextSize { normal, medium, large }
