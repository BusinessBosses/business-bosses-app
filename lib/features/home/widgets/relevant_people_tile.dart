import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/connects/widgets/connection_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/presentation/complete_searching_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelevantPeopleTile extends StatefulWidget {
  const RelevantPeopleTile({super.key});

  @override
  State<RelevantPeopleTile> createState() => _RelevantPeopleTileState();
}

class _RelevantPeopleTileState extends State<RelevantPeopleTile> {
  late ProfileController profileController;
  final String _filtertitle = '';
  final CompleteSearchController controller =
      Get.put(CompleteSearchController());

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final List<UserModel> filteredConnections =
            controller.recommendedConnections.toList();
        final List<UserModel> filteredConnectionsbytitle = controller
            .recommendedConnections
            .where((UserModel element) =>
                element.category?.toString() == _filtertitle)
            .toList();

        filteredConnections.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        filteredConnectionsbytitle.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(CompleteSearchingScreen());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Find Collaborators',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Icon(Icons.chevron_right, color: textColor, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            controller.loading.value
                ? const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredConnections.length > 10
                          ? 11
                          : filteredConnections.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return const SizedBox(width: 15);
                        }

                        final UserModel currentUser =
                            filteredConnections[index - 1];

                        bool checkConnected =
                            profileController.myProfile.connecteds != null &&
                                profileController.myProfile.connecteds!
                                    .contains(currentUser.uid);

                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ConnectionGridTile(
                            color: Colors.white,
                            user: currentUser,
                            status: checkConnected,
                            onChangeConnectionStatus: () {
                              controller.connectToUser(currentUser);
                            },
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
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
