import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/subscribe_to_premium_button.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/profile/widgets/profile_picture_display.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../controller/profile_controller.dart';

// ignore: public_member_api_docs
class UserProfileTile extends StatefulWidget {
  final UserModel myProfile;

  const UserProfileTile({super.key, required this.myProfile});
  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

    final String category = widget.myProfile.category ?? '';
    final String company = widget.myProfile.companyName ?? '';

    String limitText(String text, int max) {
      if (text.length <= max) return text;
      return '${text.substring(0, max)}…';
    }

// Build combined AFTER trim and checks
    String combined;

// First check if we need to shorten them
    if ((category + company).length > 30) {
      int split = ((30 - 3) ~/ 2); // minus 3 for " | "
      String shortCategory = limitText(category, split);
      String shortCompany = limitText(company, split);

      combined = '$shortCategory'
          '${(shortCategory.trim().isNotEmpty && shortCompany.trim().isNotEmpty) ? ' | ' : ''}'
          '$shortCompany';
    } else {
      // If already short enough, use full versions with clean check
      combined = '$category'
          '${(category.trim().isNotEmpty && company.trim().isNotEmpty) ? ' | ' : ''}'
          '$company';
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Get.to(() =>
                      ProfilePictureDisplay(widget.myProfile.photoUrl ?? ''));
                },
                child: SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: NetworkImageWithPlaceHolder(
                        imageUrl: widget.myProfile.photoUrl ?? '',
                        height: 105.0,
                        width: 105.0,
                        radius: radius,
                        cacheHeight: 120,
                        cacheWidth: 120,
                        placeHolder: Icons.person,
                        iconSize: 64.0,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.myProfile.isRanked ?? false)
                Column(
                  children: <Widget>[
                    Container(
                      height: 36,
                      width: 36,
                      padding: const EdgeInsets.all(36 * .2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5000000.0,
                            spreadRadius: 0.02,
                          )
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/bosseek.svg',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Boss of the week',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor.withValues(alpha: 1),
                            fontSize: 9,
                          ),
                    ),
                  ],
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 6.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (profileController.myProfile.matchType != null)
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ExpandedMatchesScreen());
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Text(
                                'Find My Match',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Icon(LucideIcons.chevronRight,
                                  size: 15, color: Colors.blueAccent)
                            ],
                          ),
                        ),

                      /// NAME
                      if (widget.myProfile.name != null &&
                          widget.myProfile.name!.isNotEmpty)
                        widget.myProfile.isSubscribed
                            ? Row(
                                children: <Widget>[
                                  Text(
                                    widget.myProfile.name!.length <= 20
                                        ? widget.myProfile.name!
                                        : '${widget.myProfile.name!.substring(0, 20)}...',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                    'assets/svgs/premiumbadge.svg',
                                    height: 9,
                                    colorFilter: const ColorFilter.mode(
                                      primaryColorLT,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                widget.myProfile.name!.length <= 20
                                    ? widget.myProfile.name!
                                    : '${widget.myProfile.name!.substring(0, 20)}...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),

                      /// CATEGORY (already clean)
                      Row(
                        children: <Widget>[
                          Text(
                            combined,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: textColor.withValues(alpha: 0.8),
                                    ),
                          ),
                        ],
                      ),

                      /// COMPANY NAME

                      /// LOCATION
                      if (widget.myProfile.location != null &&
                          widget.myProfile.location!.isNotEmpty)
                        Text(
                          widget.myProfile.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor.withValues(alpha: 0.6),
                                  ),
                        ),
                    ],
                  ),

                  /// SUBSCRIBE BUTTON
                  if (!profileController.myProfile.isSubscribed)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.09),
                                blurRadius: 500.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Transform.translate(
                              offset: const Offset(-15, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: subscribetopremiumbutton(),
                              ),
                            ),
                          )),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
