import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../utils/theme/theme.dart';

class AttendeesItem extends StatefulWidget {
  final EventModel event;
  const AttendeesItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _AttendeesItemState createState() => _AttendeesItemState();
}

class _AttendeesItemState extends State<AttendeesItem> {
  final LiveController liveController = Get.find();
  @override
  void initState() {
    liveController.initUsers(widget.event.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Attendees (${widget.event.totalAttendees.toString()})',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                    child: Obx(() => liveController.usersLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : widget.event.totalAttendees == 0
                              ? SafetyModel(
                                  isLoading: false,
                                  icon: SvgPicture.asset(
                                    'assets/svgs/person.svg',
                                    height: 80.0,
                                    color: hintColor,
                                  ),
                                  title: 'There is no attendee for now',
                                  subTitle: 'Be the first one to attend!',
                                )
                              : ListView.builder(
                                  itemCount: liveController.attendUsers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final UserModel user =
                                        liveController.attendUsers[index];
                                    return Column(
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () async {
                                            Get.toNamed(Routes.publicProfile,
                                                arguments: user);
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
                                                    Text(user.name ??
                                                        user.username),
                                                    const SizedBox(width: 5),
                                                    SvgPicture.asset(
                                                      'assets/svgs/premiumbadge.svg',
                                                      height: 9,
                                                      color: primaryColorLT,
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  user.name ?? user.username),
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
                                )),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
