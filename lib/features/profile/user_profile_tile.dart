import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/widgets/network_image_with_placeholder.dart';

// ignore: public_member_api_docs
class UserProfileTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140.0,
      // color: Colors.green,
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 120.0,
                width: 120.0,
                // color:Colors.green,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: const NetworkImageWithPlaceHolder(
                      imageUrl:
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
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Column(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      padding: const EdgeInsets.all(36 * .2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        // ignore: always_specify_types
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5000000.0, // soften the shadow
                            spreadRadius: 0.02, //extend the shadow
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
                          fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 106.0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6.0),
                  Text(
                    'user.name ?? ' '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'user.category',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text('user.companyName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.normal)),
                  Text(
                    'user.location',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
