import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/tiles/custom_tileinterests.dart';
import 'package:business_bosses_v2/features/profile/widgets/productandserviceschip.dart';
import 'package:business_bosses_v2/functions/my_native_functions.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/theme/theme.dart';

Widget profileinfodisplay(BuildContext context, UserModel publicUser) {
  // final ProfileController _profileController = Get.find();
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Linkify(
            text: publicUser.bio ?? '',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            options: const LinkifyOptions(humanize: false),
            linkStyle: bodyText2.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              // if (_profileController
              //         .myProfile.website
              //         ?.trim()
              //         .isNotEmpty ??
              //     false)
              if (publicUser.website != null)
                InkWell(
                  onTap: () async {
                    String url = MyNativeFunctions.completeURL(
                        publicUser.website!, MyUrl.url);
                    await launchUrlString(url);

                    // String url =
                    //     MyNativeFunctions
                    //         .completeURL(
                    //             _user
                    //                 .website!,
                    //             MyUrl.url);
                    // _onUrlLaunch(
                    //     context, url);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/link.svg',
                        height: 14.0,
                        width: 15.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        publicUser.website!,
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 11.0),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
              // if (_profileController
              //         .myProfile.twitter
              //         ?.trim()
              //         .isNotEmpty ??
              //     false) ...{
              const SizedBox(width: 8.0),
              if (publicUser.twitter != null)
                GestureDetector(
                  onTap: () async {
                    String url = MyNativeFunctions.completeURL(
                        publicUser.twitter!, MyUrl.twitter);
                    await launchUrlString(url);
                    // _onUrlLaunch(context, url);
                  },
                  child: Container(
                    height: 25.0,
                    width: 25.0,
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SvgPicture.asset(
                      'assets/svgs/twitter_o.svg',
                    ),
                  ),
                ),
              // },
              // if (_profileController
              //         .myProfile.instagram
              //         ?.trim()
              //         .isNotEmpty ??
              //     false) ...{
              const SizedBox(width: 8.0),
              if (publicUser.instagram != null)
                GestureDetector(
                  onTap: () async {
                    String url = MyNativeFunctions.completeURL(
                        publicUser.instagram!, MyUrl.instagram);
                    await launchUrlString(url);

                    // _onUrlLaunch(context, url);
                  },
                  child: Container(
                    height: 25.0,
                    width: 25.0,
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SvgPicture.asset(
                      'assets/svgs/instagram_o.svg',
                    ),
                  ),
                ),
              //},
            ],
          ),
        ),
        // _profileController.myProfile
        //                 .achievements ==
        //             null ||
        //         // ignore: unrelated_type_equality_checks
        //         _profileController.myProfile
        //                 .achievements ==
        //             ''
        //     ? Container()
        //     :
        if (publicUser.achievements != null &&
            publicUser.achievements!.isNotEmpty &&
            publicUser.achievements!
                .where((String element) => element.isNotEmpty)
                .toList()
                .isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Achievements',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: subtextColor),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10, left: 20, right: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: publicUser.achievements == null
                      ? 0
                      : publicUser.achievements!.length,
                  // : _profileController.myProfile.achievements
                  //     .toString()
                  //     .split('+')
                  //     .length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 15, right: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/trophy.svg',
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    publicUser.achievements![index],
                                    // _profileController.myProfile.achievements
                                    //     .toString()
                                    //     .split('+')[index],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ])));
                  },
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),
        // _profileController.myProfile
        //                 .productsandservices ==
        //             null ||
        //         // ignore: unrelated_type_equality_checks
        //         _profileController.myProfile
        //                 .productsandservices ==
        //             ''
        //     ? Container()
        //     :
        if (publicUser.productsandservices != null &&
            publicUser.productsandservices!.isNotEmpty &&
            publicUser.productsandservices!
                .where((String element) => element.isNotEmpty)
                .toList()
                .isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Products & Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: subtextColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              buildChoiceChips(publicUser.productsandservices != null
                  ? publicUser.productsandservices!
                      .where((String element) => element.isNotEmpty)
                      .toList()
                  : [])
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        if (publicUser.interests != null && publicUser.interests!.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Interests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: subtextColor,
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        Column(children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            itemBuilder: (BuildContext context, int i) {
              return Column(
                children: [
                  CustomTileInterest(
                    label: publicUser.interests != null
                        ? publicUser.interests![i].industry!
                        : '',
                    onTap: () {
                      if (publicUser.interests![i].categoryId ==
                          Constants.BOSS_UP_CHALLENGE_CATEGORY_ID) {
                        Get.toNamed(
                          Routes.allCommunitiesScreen,
                        );
                      } else if (publicUser.interests![i].categoryId ==
                          Constants.MARKET_PLACE_CATEGORY_ID) {
                        Get.toNamed(
                          Routes.marketPlace,
                        );
                      } else {
                        Get.toNamed(
                          Routes.allforumscreen,
                          arguments: publicUser.interests![i],
                        );
                      }
                    },
                  ),
                ],
              );
            },
            itemCount:
                publicUser.interests != null ? publicUser.interests!.length : 0,
          ),
          publicUser.interests != null && publicUser.interests!.isNotEmpty
              ? const SizedBox(
                  width: double.infinity,
                  height: 1,
                  child: ColoredBox(color: backgroundcolorinterface),
                )
              : Container(),
          const SizedBox(
            height: 150,
          )
        ]),

        const SizedBox(
          height: 100,
        ),
      ]);
}
