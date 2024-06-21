import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/single_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/forum_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandedForumView extends StatefulWidget {
  final ForumModel forum;
  const ExpandedForumView({super.key, required this.forum});

  @override
  State<ExpandedForumView> createState() => _ExpandedForumViewState();
}

class _ExpandedForumViewState extends State<ExpandedForumView> {
  final SingleController controller = Get.put(SingleController());
  final HomeController homeController = Get.find();

  @override
  void initState() {
    controller.loading.value = true;
    controller.error.value = false;
    controller.fetchForum(widget.forum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Post'),
        ),
        body: Obx(
          () => controller.loading.value
              ? const Center(child: SafetyModel())
              : Column(
                  children: <Widget>[
                    ForumItem(
                      forum: controller.forum!,
                      controller: homeController,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
