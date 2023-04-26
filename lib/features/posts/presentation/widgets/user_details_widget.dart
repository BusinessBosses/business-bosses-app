// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/create_post_user_tile.dart';
import 'package:flutter/material.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          CreatePostUserTile(
            user: UserModel.fromMap(<String, dynamic>{
              'bio': 'yo',
              'uid': 'uid',
              'username': 'vic',
              'email': 'email@email.com',
              'name': 'vick'
            }),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
