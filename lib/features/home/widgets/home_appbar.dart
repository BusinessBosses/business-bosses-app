import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: public_member_api_docs
class Homeappbar extends StatelessWidget {
  // ignore: public_member_api_docs
  const Homeappbar(
      {Key? key,
      this.hasBadge = false,
      required this.coinsCount,
      this.hasUnreadNotification = false,
      this.isTabVisible = false})
      : super(key: key);
  final bool hasBadge;
  final bool isTabVisible;
  final String coinsCount;
  final bool hasUnreadNotification;
  // static final GlobalKey<NavigatorState> searchkey =
  //     GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> notificationkey =
  //     GlobalKey<NavigatorState>();

  /// HOME SCREEN APP BAR
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0.5,
            bottomOpacity: 0,
            title: GestureDetector(
              onTap: () => Get.toNamed(Routes.completesearchingscreen),
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
                    hintText: 'Search people & posts',
                  ),
                ),
              ),
            ),
            leading: InkWell(
              onTap: () {
                Get.toNamed(Routes.chat);
              },
              child: SizedBox(
                width: 55,
                height: 20,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                spreadRadius: 0.05,
                                blurRadius: 10,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/svgs/messagewithbackground.svg',
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
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      child: Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, right: 8, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.promotionscreen);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/coin.svg',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    coinsCount,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(133, 133, 133, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
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
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              spreadRadius: 0.05,
                              blurRadius: 50,
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            IconButton(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              icon: SvgPicture.asset(
                                'assets/svgs/topnotification.svg',
                                height: 40,
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.notifications);
                              },
                            ),
                            if (hasUnreadNotification)
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
          ),
          
        ],
      ),
    );
  }
}
