// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onRemove;
  final File? file;
  const ImageItem({
    Key? key,
    this.imageUrl,
    required this.onRemove,
    this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: imageUrl != null
              ? NetworkImageWithPlaceHolder(imageUrl: imageUrl!)
              : Image.file(
                  file!,
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 5.0,
          top: 5.0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              height: 30.0,
              width: 30.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: const Icon(
                Icons.close,
                size: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
