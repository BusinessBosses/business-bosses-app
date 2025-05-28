import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class PostonhomePopUp extends StatelessWidget {
  final ForumModel forum;
  final bool isBossUp;

  /// Boss Up Challenge Pop Up
  const PostonhomePopUp(
      {super.key, required this.forum, required this.isBossUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (isBossUp) {
                      Get.to(() => const AllCommunitiesScreen(
                            initialTabIndex: 0,
                          ));
                    } else {
                      Get.off(() => const AllForumScreen());
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.close)),
                )
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text('Post Created Successfully',
                  textAlign: TextAlign.center,
                  style: bodyText1.copyWith(
                      fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(
                height: 20,
              ),
              Lottie.asset(
                'assets/anim/done.json',
                height: 120,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              GestureDetector(
                onTap: () {
                  Get.offAndToNamed(
                    Routes.createPost,
                    arguments: <String, dynamic>{
                      'sharemessage': 'Hey there! Check out this post',
                      'title': forum.title,
                      'forumdata': forum,
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.01),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor),
                  child: Center(
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Share on homepage',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/svgs/nexticon.svg',
                            color: Colors.black,
                          )
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              SizedBox(
                height: SizeConfig.safeBlockHorizontal * 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
