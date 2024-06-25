import 'package:business_bosses_v2/features/marketplace/presentation/expandedsupplierspage.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import '../../search/controller/search_controller.dart';

class SuppliersGridTile extends StatefulWidget {
  final UserModel? user;
  final bool? status;
  final Function()? onChangeSuppliersStatus;
  final Function()? onTap;

  @override
  State<SuppliersGridTile> createState() => _SuppliersGridTileState();

  const SuppliersGridTile({
    Key? key,
    this.user,
    this.status,
    this.onChangeSuppliersStatus,
    this.onTap,
  }) : super(key: key);
}

class _SuppliersGridTileState extends State<SuppliersGridTile> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ProfileController profileController = Get.find();
    return InkWell(
      onTap: () {
        Get.to(const ExpandedSuppliersPage());
      },
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius), color: Colors.white),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(35),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'Verified',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserAvatarWithBadge(
              user: profileController.myProfile,
              height: 64.0,
              width: 64.0,
              radius: 64.0,
              placeHolder: Icons.person,
            ),
            const SizedBox(height: 8.0),
            profileController.myProfile.isSubscribed == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          profileController.myProfile?.name ??
                              profileController.myProfile!.username,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          'assets/svgs/premiumbadge.svg',
                          height: 9,
                          color: primaryColorLT,
                        )
                      ],
                    ),
                  )
                : Text(
                    profileController.myProfile.name ??
                        profileController.myProfile!.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            Text(
              'Supplier of Product',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Location',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                color: primaryColorLT,
                borderRadius: BorderRadius.circular(10)
              ),
              child: MCustomButton(
                buttonType: ButtonType.elevated,
                onPressed: widget.onChangeSuppliersStatus,
                height: 36.0,
                width: 120.0,
                child: const Text(
                  'Contact',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
