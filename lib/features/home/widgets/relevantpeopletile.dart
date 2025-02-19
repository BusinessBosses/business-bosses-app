import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/connects/widgets/connection_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelevantPeopleTile extends StatefulWidget {
  const RelevantPeopleTile({super.key});

  @override
  State<RelevantPeopleTile> createState() => _RelevantPeopleTileState();
}

class _RelevantPeopleTileState extends State<RelevantPeopleTile> {
  late ProfileController profileController;
  String _filtertitle = '';
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

        void _refreshScreen() {
          setState(() {
            _filtertitle = '';
          });
        }

        filteredConnections.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        filteredConnectionsbytitle.sort((UserModel a, UserModel b) {
          return _compareUsersByPhotoUrl(a, b);
        });

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.relevantusersscreen);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Find Collaborators',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          // Text(
                          //   'View all',
                          //   style: TextStyle(fontSize: 11),
                          // ),
                          Icon(Icons.chevron_right, color: textColor, size: 16),
                        ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            controller.loading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredConnections.length > 10
                            ? 11
                            : filteredConnections.length + 1,
                        shrinkWrap: true,
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

                          return Column(
                            children: <Widget>[
                              ConnectionGridTile(
                                color: Colors.white,
                                user: currentUser,
                                status: checkConnected,
                                onChangeConnectionStatus: () {
                                  controller.connectToUser(currentUser);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
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
