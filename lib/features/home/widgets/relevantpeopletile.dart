import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/connects/widgets/connection_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RelevantPeopleTile extends StatefulWidget {
  const RelevantPeopleTile({super.key});

  @override
  State<RelevantPeopleTile> createState() => _RelevantPeopleTileState();
}

class _RelevantPeopleTileState extends State<RelevantPeopleTile> {
  late ProfileController profileController;
  String _filtertitle = '';

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
      init: CompleteSearchController(), // Ensure the controller is initialized
      builder: (CompleteSearchController controller) {
        // Ensure the controller is registered
        if (!Get.isRegistered<CompleteSearchController>()) {
          return const Center(child: Text('Controller not found'));
        }

        final List<UserModel> filteredConnections =
            controller.recommendedConnections.toList();
        final List<UserModel> filteredConnectionsbytitle = controller
            .recommendedConnections
            .where((UserModel element) =>
                element.category?.toString() == _filtertitle)
            .toList();

        void _refreshScreen() {
          setState(() {
            _filtertitle = '';
          });
        }

        // Sorting logic
        filteredConnections.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        filteredConnectionsbytitle.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            height: 230,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Follow Relevant People',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.relevantusersscreen);
                      },
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            const Text(
                              'View all',
                              style: TextStyle(fontSize: 11),
                            ),
                            const SizedBox(width: 5.0),
                            SvgPicture.asset(
                              'assets/svgs/nexticon.svg',
                              // ignore: deprecated_member_use
                              color: textColor,
                              height: 8,
                            ),
                          ]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final currentUser = filteredConnections[index];

                            bool checkConnected =
                                profileController.myProfile.connecteds !=
                                        null &&
                                    profileController.myProfile.connecteds!
                                        .contains(currentUser.uid);

                            return ConnectionGridTile(
                              color: backgroundColor,
                              user: currentUser,
                              status: checkConnected,
                              onChangeConnectionStatus: () {
                                controller.connectToUser(currentUser);
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _compareUsersByPhotoUrl(UserModel a, UserModel b) {
    if (a.photoUrl != null && a.photoUrl!.isNotEmpty) {
      if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
        return 0;
      } else {
        return -1;
      }
    } else {
      if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
