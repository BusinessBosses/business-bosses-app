import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/safe_url_launcher.dart';
import 'package:business_bosses_v2/features/home/widgets/winnercard.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';

import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';

import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/functions/my_native_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../utils/theme/theme.dart';

Widget profileinfodisplay(BuildContext context, UserModel publicUser) {
  final ProfileController profileController = Get.find();
  final String myUid = profileController.myProfile.uid;
  final bool isMyProfile = myUid == publicUser.uid;

  // Interest labels, worded exactly as in the Find My Match sheet so the two
  // never disagree. ('seller' is the stored key for the jobs option.)
  final String? rawMatchType = publicUser.matchType;
  String myLabel = '';
  String theirLabel = '';
  if (rawMatchType == 'seller') {
    myLabel = 'Need Work Done';
    theirLabel = 'Needs Work Done';
  } else if (rawMatchType == 'investor') {
    myLabel = 'I Need Backers / Funding';
    theirLabel = 'Needs Backers / Funding';
  } else if (rawMatchType == 'partner') {
    myLabel = 'I Need Suppliers/Partners';
    theirLabel = 'Needs Suppliers/Partners';
  } else if (rawMatchType == 'mentor') {
    myLabel = 'I Need Mentorship';
    theirLabel = 'Needs Mentorship';
  }
  final bool hasMatchType = myLabel.isNotEmpty;

  final int bossCount = publicUser.bossCount ?? 0;
  final int mentorCount = publicUser.mentorCount ?? 0;
  final int backerCount = publicUser.backerCount ?? 0;
  final int ambassadorCount = publicUser.ambassadorCount ?? 0;

  final bool hasAnyAchievement = bossCount > 0 ||
      mentorCount > 0 ||
      backerCount > 0 ||
      ambassadorCount > 0;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Bio
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

      const SizedBox(height: 10),

      // Social Links
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: <Widget>[
            if (publicUser.website != null)
              InkWell(
                onTap: () async {
                  String url = MyNativeFunctions.completeURL(
                      publicUser.website!, MyUrl.url);
                  await openUrlString(url);
                },
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/svgs/link.svg',
                        height: 14, width: 15),
                    const SizedBox(width: 4),
                    Text(publicUser.website!,
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 11)),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            if (publicUser.twitter != null)
              GestureDetector(
                onTap: () async {
                  String url = MyNativeFunctions.completeURL(
                      publicUser.twitter!, MyUrl.twitter);
                  await openUrlString(url);
                },
                child: Container(
                  height: 25,
                  width: 25,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(30)),
                  child: SvgPicture.asset('assets/svgs/twitter_o.svg'),
                ),
              ),
            const SizedBox(width: 8),
            if (publicUser.instagram != null)
              GestureDetector(
                onTap: () async {
                  String url = MyNativeFunctions.completeURL(
                      publicUser.instagram!, MyUrl.instagram);
                  await openUrlString(url);
                },
                child: Container(
                  height: 25,
                  width: 25,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(30)),
                  child: SvgPicture.asset('assets/svgs/instagram_o.svg'),
                ),
              ),
          ],
        ),
      ),

      // Achievements
      if (hasAnyAchievement)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 35),
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
            const SizedBox(height: 15),
            Column(
              spacing: 15,
              children: <Widget>[
                if (bossCount > 0)
                  WinnerCard(type: WinnerType.boss, winCount: bossCount),
                if (mentorCount > 0)
                  WinnerCard(type: WinnerType.mentor, winCount: mentorCount),
                if (backerCount > 0)
                  WinnerCard(type: WinnerType.backer, winCount: backerCount),
                if (ambassadorCount > 0)
                  WinnerCard(
                      type: WinnerType.ambassador, winCount: ambassadorCount),
              ],
            ),
          ],
        ),

      const SizedBox(height: 20),

      // Interests Section
      if (isMyProfile || hasMatchType)
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Interests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),

              // My profile with matchType (clickable)
              if (isMyProfile && hasMatchType)
                GestureDetector(
                  onTap: () {
                    Get.to(ExpandedMatchesScreen());
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child:
                          Icon(LucideIcons.chevronRight, color: primaryColorLT),
                    ),
                    title: Text(
                      myLabel,
                      style: const TextStyle(
                        color: subtextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )

              // My profile without matchType (prompt)
              else if (isMyProfile && !hasMatchType)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) => const PreMatchModal(),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text('What are you interested in?'),
                        Icon(LucideIcons.chevronRight, size: 15),
                      ],
                    ),
                  ),
                )

              // Public profile with matchType (not clickable)
              else if (!isMyProfile && hasMatchType)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    theirLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: subtextColor,
                    ),
                  ),
                ),
            ],
          ),
        ),

      const SizedBox(height: 100),
    ],
  );
}
