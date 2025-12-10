// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../utils/theme/theme.dart';

class UserProfileImageItem extends StatelessWidget {
  final String? imageUrl;
  final double width, height;
  final File? imageFile;
  final bool isNetWorkImage;
  final bool isUploading;
  final Function onImagePicker;
  final bool isPickerRequired;

  /// USER PROFILE IMAGE
  const UserProfileImageItem({
    super.key,
    required this.imageUrl,
    required this.imageFile,
    required this.onImagePicker,
    this.isNetWorkImage = true,
    this.isUploading = false,
    this.height = 86.0,
    this.width = 86.0,
    this.isPickerRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          isUploading
              ? Center(
                  child: SizedBox(
                    height: height * 0.3,
                    width: height * 0.3,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Container(),
          ClipRRect(
            borderRadius: BorderRadius.circular(height),
            child: isNetWorkImage
                ? imageUrl != null
                    ? NetworkImageWithPlaceHolder(
                        imageUrl: imageUrl!,
                        fit: BoxFit.fill,
                        height: height,
                        width: width,
                      )
                    : modelChild()
                : imageFile != null
                    ? Image.file(
                        imageFile!,
                        fit: BoxFit.fill,
                        height: height,
                        width: width,
                      )
                    : modelChild(),
          ),
          isPickerRequired
              ? Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      await onImagePicker();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0),
                          color: primaryColorLT,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: SvgPicture.asset('assets/svgs/add.svg'),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  /// MODEL CHILD
  Widget modelChild() {
    return CircleAvatar(
      backgroundColor: primaryColorLT.withValues(alpha: 0.2),
      radius: height / 2,
      child: SizedBox(
        height: 100,
        width: 50,
        child: SvgPicture.asset(
          'assets/svgs/person.svg',
          colorFilter: ColorFilter.mode(
              primaryColorLT.withValues(alpha: 0.5), BlendMode.srcIn),
        ),
      ),
    );
  }
}
