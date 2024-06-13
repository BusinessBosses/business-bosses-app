import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class PostonhomePopUp extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const PostonhomePopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
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
                Get.toNamed(
                  Routes.createPost,
                  arguments: <String, dynamic>{},
                );
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: backgroundColor),
                child: Center(
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
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
    );
  }
}
