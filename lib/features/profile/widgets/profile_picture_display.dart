import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfilePictureDisplay extends StatelessWidget {
  final String photoUrl;
  static const String heroTag = 'profile_picture';

  const ProfilePictureDisplay(this.photoUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the shadow
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Hero(
                    tag: heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: buildProfilePicture(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePicture() {
    // ignore: unnecessary_null_comparison
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return NetworkImageWithPlaceHolder(
        imageUrl: photoUrl,
        height: 300.0, // Set the desired larger height
        width: 300.0, // Set the desired larger width
        radius: radius,
        cacheHeight: 120,
        cacheWidth: 120,
        placeHolder: Icons.person,
        iconSize: 64.0,
      );
    } else {
      // Display a placeholder or a message when photoUrl is empty
      return Container(
        width: 300.0,
        height: 300.0,
        color: Colors.grey, // Placeholder color
        child: const Center(
          child: Text(
            'Photo Unavailable',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      );
    }
  }
}
