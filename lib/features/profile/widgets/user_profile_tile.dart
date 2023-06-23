import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../navigation/routes.dart';
import '../controller/profile_controller.dart';

// ignore: public_member_api_docs
class UserProfileTile extends StatefulWidget {
  final UserModel myProfile;

  const UserProfileTile({Key? key, required this.myProfile}) : super(key: key);
  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    // fetchData();
    // setState(() {});
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: NetworkImageWithPlaceHolder(
                      imageUrl: widget.myProfile.photoUrl ??
                          'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png',
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
              if (widget.myProfile.isRanked ?? false)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      padding: const EdgeInsets.all(36 * .2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0, // soften the shadow
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
                            color: textColor.withOpacity(1),
                            fontSize: 9,
                          ),
                    ),
                  ],
                ),
            ],
          ),
          Expanded(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.myProfile.name != null &&
                                  widget.myProfile.name!.length <= 20
                              ? widget.myProfile.name!
                              : widget.myProfile.name != null
                                  ? '${widget.myProfile.name!.substring(0, 20)}...'
                                  : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          widget.myProfile.category ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.8)),
                        ),
                        widget.myProfile?.companyName != null &&
                                widget.myProfile.companyName != ''
                            ? Text(
                                widget.myProfile.companyName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: textColor.withOpacity(
                                      0.8,
                                    )),
                              )
                            : Container(),
                        widget.myProfile?.location != null &&
                                widget.myProfile.location != ''
                            ? Text(
                                widget.myProfile.location ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: textColor.withOpacity(0.6),
                                    ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  if (!widget.myProfile.isSubscribed)
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.premiumscreen);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.09),
                                blurRadius: 500.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/subscribebuttonback.svg',
                                      width: 200,
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Subscribe to Premium',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svgs/nextbutton.svg',
                                            color: primaryColorLT,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]))),
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
