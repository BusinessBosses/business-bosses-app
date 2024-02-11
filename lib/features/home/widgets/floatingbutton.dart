import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

class Floatingbutton extends StatelessWidget {
  const Floatingbutton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController myProfile = Get.find();
    int now = DateTime.now().millisecondsSinceEpoch;
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
                    height: 310,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            // Set a specific height
                            child: ListView.separated(
                              itemCount: 4,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.pop(
                                        context); // Close the drawer or navigate back
                                    if (index == 0) {
                                      Get.toNamed(Routes
                                          .createPost); // Navigate to "createPost" route
                                    } else if (index == 1) {
                                      sellProduct(
                                          context); // Call sellProduct function
                                    } else if (index == 2) {
                                      Get.toNamed(Routes
                                          .createevent); // Navigate to "createevent" route
                                    } else if (index == 3) {
                                      Get.to(() =>
                                          const CreatePollScreen()); // Navigate to "createPollSurvey" route
                                    }
                                  },
                                  minVerticalPadding: 0,
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  leading: index == 3
                                      ? const Icon(Icons.poll)
                                      : SvgPicture.asset(
                                          index == 0
                                              ? 'assets/svgs/text.svg'
                                              : index == 1
                                                  ? 'assets/svgs/sellicon.svg'
                                                  : 'assets/svgs/liveevent.svg', // Assuming you have a "polls.svg" asset
                                          height: index == 0
                                              ? 25
                                              : index == 1
                                                  ? 30
                                                  : index == 2
                                                      ? 22
                                                      : 22, // Adjust the height as needed
                                          color: textColor.withOpacity(1),
                                        ),
                                  title: Text(
                                    index == 0
                                        ? 'Create a Post'
                                        : index == 1
                                            ? 'Sell your product & service'
                                            : index == 2
                                                ? 'Create a Live Event'
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
                });
            
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 90, right: 15),
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
