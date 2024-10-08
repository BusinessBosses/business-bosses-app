import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/shopscreen.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GotoshopWidget extends StatefulWidget {
  const GotoshopWidget({super.key});

  @override
  State<GotoshopWidget> createState() => _GotoshopWidgetState();
}

class _GotoshopWidgetState extends State<GotoshopWidget> {
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const ShopScreen());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: NetworkImageWithPlaceHolder(
                          imageUrl: shopController.shop!.image ?? '',
                          radius: 8,
                          placeHolder: Icons.person,
                          iconSize: 22.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      shopController.shop!.name,
                    ),
                  ]),
              SvgPicture.asset(
                'assets/svgs/nexticon.svg',
                color: proprimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
