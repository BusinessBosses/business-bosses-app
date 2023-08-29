// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:business_bosses_v2/features/posts/widgets/image_item.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
    required this.controller,
    this.isUrl = false,
    this.isUpdating = false,
  }) : super(key: key);
  final dynamic controller;
  final bool isUpdating;
  final bool isUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isUpdating
            ? controller.updatingImageFileList.length
            : isUrl
                ? controller.imageUrlList.length
                : controller.imageFileList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 5
                  : 3,
          childAspectRatio: (1 / 1),
        ),
        itemBuilder: (BuildContext context, int i) {
          return Stack(
            children: [
              if (isUpdating)
                ImageItem(
                  file: controller.updatingImageFileList[i].contains('http')
                      ? null
                      : File(controller.updatingImageFileList[i]),
                  onRemove: () => controller.removeUpdatingImage(i),
                  imageUrl: controller.updatingImageFileList[i].contains('http')
                      ? controller.updatingImageFileList[i]
                      : null,
                )
              else
                ImageItem(
                  file: isUrl ? null : File(controller.imageFileList[i].path),
                  onRemove: () => controller.removeImage(i),
                  imageUrl: isUrl ? controller.imageUrlList[i] : null,
                ),
            ],
          );
        },
      ),
    );
  }
}
