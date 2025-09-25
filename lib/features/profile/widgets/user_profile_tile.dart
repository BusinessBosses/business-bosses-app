import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/subscribe_to_premium_button.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/features/posts/widgets/tag.dart';
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
    // ignore: unused_local_variable
    final ProfileController profileController = Get.find();
    // fetchData();
    // setState(() {});
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
                  height: 120.0,
                  width: 120.0,
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
                            blurRadius: 5000000.0, // soften the shadow
                            spreadRadius: 0.02, // extend the shadow
                          )
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/bosseek.svg',
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
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
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 6.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) => PreMatchModal());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(500),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: <Widget>[
                            Text(
                              profileController.myProfile.matchType!.capitalize
                                  .toString(),
                              style: TextStyle(color: primaryBlue),
                            ),
                            Icon(LucideIcons.refreshCcw,
                                size: 10,
                                color: primaryBlue.withValues(alpha: 0.6))
                          ],
                        ),
                      ),
                    ),
                    widget.myProfile.isSubscribed
                        ? Row(
                            children: <Widget>[
                              Text(
                                widget.myProfile.name != null &&
                                        widget.myProfile.name!.length <= 20
                                    ? widget.myProfile.name!
                                    : widget.myProfile.name != null
                                        ? '${widget.myProfile.name!.substring(0, 20)}...'
                                        : widget.myProfile.username,
                                style: Theme.of(context).textTheme.bodyLarge,
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
                            widget.myProfile.name != null &&
                                    widget.myProfile.name!.length <= 20
                                ? widget.myProfile.name!
                                : widget.myProfile.name != null
                                    ? '${widget.myProfile.name!.substring(0, 20)}...'
                                    : '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                    Text(
                      widget.myProfile.category ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor.withValues(alpha: 0.8)),
                    ),
                    widget.myProfile.companyName != null &&
                            widget.myProfile.companyName != ''
                        ? Text(
                            widget.myProfile.companyName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: textColor.withValues(
                                  alpha: 0.8,
                                )),
                          )
                        : Container(),
                    widget.myProfile.location != null &&
                            widget.myProfile.location != ''
                        ? Text(
                            widget.myProfile.location ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: textColor.withValues(alpha: 0.6),
                                ),
                          )
                        : Container(),
                  ],
                ),
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
                          padding: const EdgeInsets.only(
                            top: 2.0,
                          ),
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
          )
        ],
      ),
    );
  }
}
