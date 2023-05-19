// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/my_user.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/ranking_badge.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserAvatarWithBadge extends StatelessWidget {
  final UserModel? user;
  final double? width;
  final double? height;
  final double? radius;
  final bool? showText;
  final double? iconSize;
  final IconData? placeHolder;
  final Color? color;
  final Color? borderColor;
  final BoxFit? fit;
  final PlaceHolderType? placeHolderType;
  final Color? progressCircleColor;
  final double? progressCircleHeight;
  final double right, bottom;
  final double? avatarSize;

  const UserAvatarWithBadge({
    Key? key,
    this.user,
    this.width,
    this.height,
    this.radius,
    this.iconSize,
    this.placeHolder,
    this.color,
    this.borderColor,
    this.showText = false,
    this.fit,
    this.right = 0,
    this.bottom = 0,
    this.placeHolderType,
    this.progressCircleColor,
    this.progressCircleHeight,
    this.avatarSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        NetworkImageWithPlaceHolder(
          imageUrl: user!.photoUrl ??
              'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile-thumbnail.png',
          height: height!,
          width: width!,
          radius: radius!,
          cacheHeight: 90,
          cacheWidth: 90,
          placeHolder: Icons.person,
          iconSize: iconSize,
        ),
        if (user!.isRanked ?? false)
          Positioned(
            right: right,
            bottom: bottom,
            child: showText!
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/svgs/bosseek.svg',
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Boss of the week',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor.withOpacity(1),
                              height: 3,
                              fontSize: 5,
                            ),
                      ),
                    ],
                  )
                : RankingBadge(size: avatarSize ?? (height! / 2.8)),
          ),
      ],
    );
  }
}
