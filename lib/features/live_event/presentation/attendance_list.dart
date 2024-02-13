import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AttendanceList extends StatefulWidget {
  final int eventId;
  const AttendanceList({super.key, required this.eventId});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final LiveController liveController = Get.find();

  @override
  void initState() {
    liveController.initUsers(widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Attendance List'),
        leading: IconButton(
          onPressed: () {
            liveController.usersLoading(true);
            Get.back();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
      ),
      body: Obx(() {
        return liveController.usersLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: liveController.attendUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  final UserModel user = liveController.attendUsers[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () async {
                          Get.toNamed(Routes.publicProfile, arguments: user);
                        },
                        leading: UserAvatarWithBadge(
                          user: user,
                          height: 48.0,
                          width: 48.0,
                          radius: 30.0,
                          placeHolder: Icons.person,
                        ),
                        title: user.isSubscribed == true
                            ? Row(
                                children: <Widget>[
                                  Text(user.name ?? user.username),
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                    'assets/svgs/premiumbadge.svg',
                                    height: 9,
                                    color: primaryColorLT,
                                  )
                                ],
                              )
                            : Text(user.name ?? user.username),
                        subtitle: Text(
                          user.bio ?? '',
                          maxLines: 1,
                        ),
                      ),
                      const Divider(
                        height: 0.0,
                        indent: 0.0,
                        endIndent: 0.0,
                      ),
                    ],
                  );
                },
              );
      }),
    );
  }
}
