import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GotoshopWidget extends StatelessWidget {
  const GotoshopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWithPlaceHolder(
                    imageUrl: 'profileController.myProfile.photoUrl' ?? '',
                    radius: 8,
                    placeHolder: Icons.person,
                    iconSize: 22.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text('Gotoshop name'),
            ]),
            SvgPicture.asset(
              'assets/svgs/nexticon.svg',
              color: proprimaryColor,
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
      ),
    );
  }
}
