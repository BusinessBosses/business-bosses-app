import 'dart:io';

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  final String caption;
  final String subText;
  final String buttonText;
  final VoidCallback onPressed;
  final String imagePath;
  final String? iconpath;
  final bool? buttonvisible;

  const CustomCard({
    super.key,
    required this.caption,
    required this.subText,
    required this.buttonText,
    required this.onPressed,
    required this.imagePath,
    this.iconpath,
    this.buttonvisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                Color(0xffF3F4F8), // Light grey
                Color(0xffFFFFFF), // White
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xff4680A6).withAlpha(50), // Border color
              width: 0.5, // Border width
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (buttonvisible == true)
                      ElevatedButton.icon(
                        onPressed: onPressed,
                        icon: SvgPicture.asset(
                          iconpath!,
                          colorFilter: const ColorFilter.mode(
                              primaryColorLT, BlendMode.srcIn),
                        ),
                        label: Text(
                          buttonText,
                          style: const TextStyle(color: primaryColorLT),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          backgroundColor:
                              Colors.white, // Button background color
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        const Color(0xff4680A6).withAlpha(50), // Border color
                    width: 0.5, // Border width
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imagePath.startsWith('http')
                      ? NetworkImageWithPlaceHolder(imageUrl: imagePath)
                      : imagePath.startsWith('assets/')
                          ? Image.asset(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imagePath),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
