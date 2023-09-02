import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/popup/my_popup_menu_button.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../navigation/routes.dart';
import '../../../../utils/theme/theme.dart';
import '../../../utils/time_format.dart';
import '../models/reviews_model.dart';

/// import 'rep';
class ReviewTile extends StatefulWidget {
  final ReviewModel post;
  final Future<void> Function() process;
  final Future<void> Function(int, int, String) edit;

  ///
  const ReviewTile(
      {Key? key, required this.post, required this.process, required this.edit})
      : super(key: key);

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool hide = false;
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (hide == false) {
      final List<PopupMenuEntry<String>> myPopupMore = <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Edit Rating',
          child: Text(
            'Edit Rating',
            style: bodyText2,
          ),
        ),
        const PopupMenuDivider(
          height: 0.0,
        ),
        const PopupMenuItem<String>(
          value: 'Delete Rating',
          child: Text(
            'Delete Rating',
            style: bodyText2,
          ),
        ),
      ];

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0.0),
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 15),
                  leading: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid ==
                          widget.post.rater.uid) {
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: widget.post.rater);
                      }
                    },
                    child: UserAvatarWithBadge(
                      user: widget.post.rater,
                      height: 55.0,
                      width: 55.0,
                      radius: 50.0,
                      placeHolder: Icons.person,
                      iconSize: 24.0,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      if (profileController.myProfile.uid ==
                          widget.post.rater.uid) {
                      } else {
                        Get.toNamed(Routes.publicProfile,
                            arguments: widget.post.rater);
                      }
                    },
                    child: widget.post.rater.isSubscribed == true
                        ? Row(
                            children: [
                              Text(
                                '${widget.post.rater.name!.length <= 15 ? widget.post.rater.name : "${widget.post.rater.name!.substring(0, 12)}..."}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                'assets/svgs/premiumbadge.svg',
                                height: 9,
                                color: primaryColorLT,
                              )
                            ],
                          )
                        : Text(
                            '${widget.post.rater.name!.length <= 15 ? widget.post.rater.name : "${widget.post.rater.name!.substring(0, 12)}..."}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: widget.post.rater.uid ==
                                    profileController.myProfile.uid
                                ? MyPopupMenuButton(
                                    popupItems: myPopupMore,
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      size: 20,
                                      color: Colors.black,
                                      weight: 100,
                                    ),
                                    onSelected: (String val) {
                                      if (val == 'Edit Rating') {
                                        widget.edit(
                                            widget.post.id,
                                            widget.post.rating,
                                            widget.post.reviewText ?? '');
                                      } else if (val == 'Delete Rating') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                              'Delete Listing',
                                              style: bodyText1,
                                            ),
                                            content: const Text(
                                                'Are you sure to delete this listing?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await ApiService.delete(
                                                      path:
                                                          'reviews/${widget.post.id}');
                                                  widget.process;
                                                  setState(() {
                                                    hide = true;
                                                  });
                                                  Get.back();
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    widget.post.rater.bio != null &&
                            widget.post.rater.bio!.isNotEmpty
                        ? widget.post.rater.bio!
                        : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color.fromRGBO(255, 202, 40, 1),
                                size: 14,
                              ),
                              Text(
                                widget.post.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0, top: 4),
                            child: DetectableText(
                              text: widget.post.reviewText ?? '',
                              detectionRegExp: detectionRegExp(hashtag: false)!,
                              detectedStyle: bodyText2.copyWith(
                                color: Colors.blue,
                              ),
                              moreStyle: bodyText2.copyWith(
                                color: Colors.redAccent,
                              ),
                              lessStyle: bodyText2.copyWith(
                                color: Colors.redAccent,
                              ),
                              trimExpandedText: '  show less',
                              basicStyle: bodyText2.copyWith(color: textColor),
                              onTap: (_) {},
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                (TimeFormat.formatString(
                                    DateTime.parse(widget.post.createdAt)
                                        .millisecondsSinceEpoch)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: textColor.withOpacity(0.4),
                                    ) // Your content here
                                ),
                          ),
                          const Divider(
                            color: Colors.black12,
                            thickness: 1.0,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
