// ignore_for_file: dead_code

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import '../../../common/models/my_connect.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../widgets/connection_user_tile.dart';

class ReferalsScreen extends StatelessWidget {
  const ReferalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    Future<void> connect(String userId) async {
      await ApiService.post(path: 'connection/connect', body: <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'connectedId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }

    return GetBuilder<ReachController>(
      builder: (ReachController controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: const Text(
              'Referrals',
              textAlign: TextAlign.center,
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: controller.referrals.isEmpty
                        ? getSafetyModel('No User Reffered!')
                        : ListView.separated(
                            separatorBuilder: (_, __) =>
                                const Divider(height: 0.0),
                            itemCount: controller.referrals.length,
                            itemBuilder: (BuildContext context, int i) {
                              final bool checkConnected = profileController
                                  .myProfile.connecteds!
                                  .contains(controller.referrals[i].uid);
                              return ConnectionUserItem(
                                label: 'skd',
                                user: controller.referrals[i],
                                status: checkConnected,
                                isMe: controller.referrals[i].uid ==
                                        profileController.myProfile.uid
                                    ? true
                                    : false,
                                onChangeConnectionStatus:
                                    (UserModel user) async {
                                  final bool isConnected = profileController
                                              .myProfile.connecteds !=
                                          null &&
                                      profileController.myProfile.connecteds!
                                          .contains(user.uid);
                                  if (!isConnected) {
                                    await connect(user.uid);
                                    profileController
                                        .updateConnections(user.uid);
                                  }
                                },
                              );
                            },
                          ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getSafetyModel(String title) {
    return SafetyModel(
      isLoading: false,
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        colorFilter: ColorFilter.mode(hintColor, BlendMode.srcIn),
        height: 80.0,
      ),
      title: title,
      subTitle: '',
    );
  }
}
