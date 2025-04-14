import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

class Floatingbutton extends StatelessWidget {
  final bool? isEvent;
  const Floatingbutton({
    Key? key,
    this.isEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController myProfile = Get.find();
    // ignore: unused_local_variable
    int now = DateTime.now().millisecondsSinceEpoch;
    // ignore: unused_local_variable
    int previousStamp = myProfile.myProfile.bossOfTheWeekTimeStamp ?? 0;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          builder: (BuildContext context) {
            return SizedBox(
              height: 380, // Increased height to accommodate the new item
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        itemCount: 5, // Changed to 5 items
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              if (index == 0) {
                                Get.to(() => const BossupChallenge(
                                      backgroundColor: Colors.white,
                                      ishome: false,
                                    ));
                              } else if (index == 1) {
                                Get.toNamed(Routes.createPost);
                              } else if (index == 2) {
                                sellProduct(context);
                              } else if (index == 3) {
                                Get.toNamed(Routes.createevent);
                              } else if (index == 4) {
                                Get.to(() => const CreatePollScreen());
                              }
                            },
                            minVerticalPadding: 0,
                            contentPadding: const EdgeInsets.only(left: 10),
                            leading: index == 4
                                ? const Icon(
                                    Icons.poll,
                                    color: Colors.black,
                                  )
                                : index == 0
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.black,
                                      )
                                    : SvgPicture.asset(
                                        index == 1
                                            ? 'assets/svgs/text.svg'
                                            : index == 2
                                                ? 'assets/svgs/sellicon.svg'
                                                : 'assets/svgs/eventu.svg',
                                        height: index == 1
                                            ? 25
                                            : index == 2
                                                ? 30
                                                : 22,
                                        color: textColor.withOpacity(1),
                                      ),
                            title: Text(
                              index == 0
                                  ? 'Enter Free Business Promotion'
                                  : index == 1
                                      ? 'Start a Discussion'
                                      : index == 2
                                          ? 'Sell your product & service'
                                          : index == 3
                                              ? 'Create an Event'
                                              : 'Create Polls & Surveys',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: isEvent == true ? 15 : 90, right: 15),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColorLT,
              borderRadius: BorderRadius.circular(50),
            ),
            width: 50,
            height: 50,
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
