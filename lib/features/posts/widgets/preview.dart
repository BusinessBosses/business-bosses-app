// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:business_bosses_v2/features/posts/widgets/image_item.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({Key? key, required this.controller}) : super(key: key);
  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.imageFileList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 5
                  : 3,
          childAspectRatio: (1 / 1),
        ),
        itemBuilder: (BuildContext context, int i) {
          return ImageItem(
            file: File(controller.imageFileList[i].path),
            onRemove: () => controller.removeImage(i),
          );
        },
      ),
    );
  }
}
