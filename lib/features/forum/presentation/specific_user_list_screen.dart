import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class SpecificUserListScreen extends StatefulWidget {
  static const String routeName = '/specificuserlistScreen';

  const SpecificUserListScreen({Key? key}) : super(key: key);

  @override
  _SpecificUserListScreenState createState() => _SpecificUserListScreenState();
}

class _SpecificUserListScreenState extends State<SpecificUserListScreen> {
  final ScrollController _controller = ScrollController();

  late final ForumController _forumController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<ForumController>()) {
      _forumController = Get.put(ForumController());
    } else {
      _forumController = Get.find();
    }
    if (Get.arguments == null) {
      Get.back();
    } else {
      _forumController.fetchIndustryUsers(Get.arguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForumController>(
      builder: (ForumController controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: const Text(
              // _prarams.title ??
              'Members',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: controller.members.isEmpty
              ? SafetyModel(
                  isLoading: controller.loadingMembers.value,
                  icon: const Icon(
                    Icons.person,
                    size: 80.0,
                    color: hintColor,
                  ),
                  title: 'There is no member',
                  // subTitle: 'Be the first one to like!',
                )
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 48.0),
                      controller: _controller,
                      itemCount: controller.members.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                Get.toNamed(Routes.publicProfile,
                                    arguments: controller.members[i]);
                                // var result = await navigateTo(
                                //   context,
                                //   routeName: PublicProfileScreen.routeName,
                                //   arguments: controller.members[i],
                                // );
                                // if (result == null) {
                                //   Navigator.of(context).pop();
                                // }
                              },
                              leading: UserAvatarWithBadge(
                                user: controller.members[i],
                                height: 48.0,
                                width: 48.0,
                                radius: 30.0,
                                placeHolder: Icons.person,
                              ),
                              // NetworkImageWithPlaceHolder(
                              //   imageUrl: _users[i].photoUrl,
                              //   height: 48.0,
                              //   width: 48.0,
                              //   radius: 30.0,
                              //   placeHolder: Icons.person,
                              // ),
                              title: Text(controller.members[i].name ??
                                  controller.members[i].username),
                              subtitle: Text(
                                controller.members[i].bio ?? '',
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
                    ),
                    if (controller.loadingNextMembers.value)
                      const Positioned(
                        bottom: 10.0,
                        right: 0.0,
                        left: 0.0,
                        child: SafetyModel(isLoading: true),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class ParamData {
  String title;
  dynamic data;

  ParamData(
    this.title,
    this.data,
  );
}
