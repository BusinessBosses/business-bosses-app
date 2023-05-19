// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/create_post_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/controller/profile_controller.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          CreatePostUserTile(
            user: profileController.myProfile,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
