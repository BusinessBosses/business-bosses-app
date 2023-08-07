import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/widgets/safety_model.dart';
import '../../features/connects/widgets/connection_grid_tile.dart';
import '../../features/search/controller/search_controller.dart';
import '../../utils/theme/theme.dart';

class RelevantUsersScreen extends StatefulWidget {
  static const String routeName = '/relevant-users-screen';

  const RelevantUsersScreen({Key? key}) : super(key: key);

  @override
  _RelevantUsersScreenState createState() => _RelevantUsersScreenState();
}

class _RelevantUsersScreenState extends State<RelevantUsersScreen> {
  late UserModel _user;
  ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
        builder: (CompleteSearchController controller) {
      final List<UserModel> filteredConnections = controller
          .recommendedConnections
          .where((UserModel element) =>
              element.photoUrl != null && element.photoUrl!.isNotEmpty)
          .toList();
      return Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Connect',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: controller.loading.value
            ? const Center(
                child:
                    CircularProgressIndicator(), // Circular Progress Indicator
              )
            : controller.recommendedConnections.isEmpty
                ? _safetyModal(_user)
                : StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.all(8.0),
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    itemCount: filteredConnections.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool checkConnected =
                          profileController.myProfile.connecteds != null &&
                              profileController.myProfile.connecteds!.contains(
                                filteredConnections[index].uid,
                              );

                      return ConnectionGridTile(
                        user: filteredConnections[index],
                        status: checkConnected,
                        onChangeConnectionStatus: () {
                          controller.connectToUser(filteredConnections[index]);
                        },
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(1),
                  ),
      );
    });
  }

  final bool _isLoading = true;

  Future<void> _loadRelevantUsers() async {}

  void _sendNotification(UserModel user) {}

  Widget _safetyModal(UserModel user) {
    if ((user.category?.isEmpty ?? true) && (user.industry?.isEmpty ?? true)) {
      return SafetyModel(
        icon: const Icon(
          Icons.info_outline,
          size: 80.0,
          color: hintColor,
        ),
        isLoading: _isLoading,
        title: 'You may have incomplete profile!',
        subTitle: 'You don\'t have category or industry yet',
        clickableText: 'Complete profile',
        onTap: () async {
          await Get.toNamed(Routes.updateProfile, arguments: true);
          _loadRelevantUsers();
        },
      );
    }
    return SafetyModel(
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        color: hintColor,
        height: 80.0,
      ),
      isLoading: _isLoading,
      title: 'You\'ve no matched users for now',
      subTitle: 'All relevant users will be displayed here!',
    );
  }
}
