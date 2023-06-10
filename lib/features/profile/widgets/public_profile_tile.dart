import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../navigation/routes.dart';
import '../controller/profile_controller.dart';

// ignore: public_member_api_docs
class PublicProfileTile extends StatefulWidget {
  final UserModel myProfile;

  const PublicProfileTile({Key? key, required this.myProfile})
      : super(key: key);
  @override
  State<PublicProfileTile> createState() => _PublicProfileTileState();
}

class _PublicProfileTileState extends State<PublicProfileTile> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    // fetchData();
    // setState(() {});
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 0.0,
        bottom: 0.0,
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 120.0,
                width: 120.0,
                child: Align(
                  alignment: Alignment.topLeft,
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
              widget.myProfile.isRanked ?? false
                  ? Positioned(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor.withOpacity(1),
                                    fontSize: 9),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          Expanded(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6.0),
                  Text(
                    widget.myProfile.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    widget.myProfile.category ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(widget.myProfile.companyName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.normal)),
                  Text(
                    widget.myProfile.location ?? '',
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
