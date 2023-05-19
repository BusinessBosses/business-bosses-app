import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: public_member_api_docs
class Homeappbar extends StatelessWidget {
  // ignore: public_member_api_docs
  const Homeappbar({Key? key, this.hasBadge = false, required this.coinsCount})
      : super(key: key);
  final bool hasBadge;
  final String coinsCount;

  /// HOME SCREEN APP BAR
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0.5,
      bottomOpacity: 0,
      title: GestureDetector(
        child: SizedBox(
          height: 42,
          width: double.infinity,
          child: TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: inputDecoration.copyWith(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: backgroundcolorinterface,
              filled: true,
              enabled: false,
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SvgPicture.asset(
                  'assets/svgs/search.svg',
                  color: hintColor,
                ),
              ),
              hintText: 'Search people',
            ),
          ),
        ),
      ),
      leading: InkWell(
        onTap: () {
          Get.toNamed(Routes.chat);
          // navigateTo(context, routeName: ChatScreen.routeName);
        },
        child: SizedBox(
          width: 55,
          height: 20,
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            spreadRadius: 0.05,
                            blurRadius: 10,
                            blurStyle: BlurStyle.normal),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/messagewithbackground.svg',
                      // height: 30.0,
                    ),
                  ),
                  if (hasBadge)
                    const Positioned(
                      top: 0,
                      right: -5,
                      child: CircleAvatar(
                        backgroundColor: primaryColorLT,
                        radius: 4,
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundcolorinterface, // ash background color
                borderRadius: BorderRadius.circular(20), // rounded corners
              ),
              child: GestureDetector(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, top: 5, right: 8, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/coin.svg',
                            height: 22,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            coinsCount,
                            style: TextStyle(
                              color: Color.fromRGBO(133, 133, 133, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              child: SizedBox(
                width: 55,
                height: 55,
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        spreadRadius: 0.05,
                        blurRadius: 50,
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                  ),
                  // ignore: missing_required_param
                  child: Stack(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        icon: SvgPicture.asset(
                          'assets/svgs/topnotification.svg',
                          height: 40,
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.notifications);
                          //  Get.toNamed('/notifications');
                        },
                      ),
                      const Positioned(
                        top: 15,
                        right: 20,
                        child: CircleAvatar(
                          backgroundColor: primaryColorLT,
                          radius: 4,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
