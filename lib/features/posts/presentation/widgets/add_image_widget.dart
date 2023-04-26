// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({Key? key, required this.controller}) : super(key: key);
  final CreatePostController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          const TextWidget(
            text: 'Add image',
            fontWeight: FontWeight.w700,
            size: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              controller.onPickImage();
            },
            child: CircleAvatar(
              radius: 26 / 1.38,
              backgroundColor: backgroundColor,
              child: SvgPicture.asset(
                'assets/svgs/addimagepost.svg',
                height: 18,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Max file size for images is 3MB',
            style: TextStyle(fontSize: 11, color: Colors.red),
          )
        ],
      ),
    );
  }
}
