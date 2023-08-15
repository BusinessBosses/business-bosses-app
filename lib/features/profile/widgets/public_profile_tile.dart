import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';

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
    // fetchData();
    // setState(() {});
    return SizedBox(
      width: double.infinity,
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
                  widget.myProfile.isSubscribed
                      ? Row(
                          children: [
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
                              color: primaryColorLT,
                            )
                          ],
                        )
                      : Text(
                          widget.myProfile.name != null &&
                                  widget.myProfile.name!.length <= 20
                              ? widget.myProfile.name!
                              : widget.myProfile.name != null
                                  ? '${widget.myProfile.name!.substring(0, 20)}...'
                                  : widget.myProfile.username,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                  Text(
                    widget.myProfile.category ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor.withOpacity(0.8)),
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
                              color: textColor.withOpacity(
                                0.8,
                              )),
                        )
                      : Container(),
                  widget.myProfile.location != null &&
                          widget.myProfile.location != ''
                      ? Text(
                          widget.myProfile.location ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor.withOpacity(0.6),
                                  ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
