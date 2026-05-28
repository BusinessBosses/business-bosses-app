import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';

import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

/// Displays the subscription upgrade bottom sheet.
void showSubscriptionBottomSheet(BuildContext context) {
  Get.bottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    SizedBox(
      height: Get.height * 0.9,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ProSubscribeSection(isGrow: true),
        ),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

/// Handles the tap on a sell option (product, service, or supplier).
void handleSellOptionTap({
  required BuildContext context,
  required int index,
  required ProfileController profileController,
  required ShopController shopController,
}) {
  Navigator.pop(context);

  // Options for selling a product or service.
  if (index == 0 || index == 1) {
    if (!profileController.myProfile.hasShop) {
      showSubscriptionBottomSheet(context);
    } else {
      Get.to(
        () => index == 0
            ? const CreateProductListing(isMarketplace: true)
            : const CreateServiceListing(isMarketplace: true),
      );
    }
  } else {
    // Option for becoming a partner.
    if (!profileController.myProfile.isSubscribed) {
      showPremiumPaywall();
    } else {
      Get.to(() => const BecomeaPartnerScreen());
    }
  }
}

/// Main function to show the sell product bottom sheet.
void sellProduct(BuildContext context) {
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    // Determine title and SVG asset based on the index.
                    String title;
                    Widget leading;
                    switch (index) {
                      case 0:
                        title = 'Sell your product';
                        leading = SvgPicture.asset(
                          'assets/svgs/addproduct.svg',
                          height: 25,
                          colorFilter: ColorFilter.mode(
                            textColor.withValues(alpha: 1),
                            BlendMode.srcIn,
                          ),
                        );
                        break;
                      case 1:
                        title = 'Sell your service';
                        leading = SvgPicture.asset(
                          'assets/svgs/addservice.svg',
                          height: 25,
                          colorFilter: ColorFilter.mode(
                            textColor.withValues(alpha: 1),
                            BlendMode.srcIn,
                          ),
                        );
                        break;
                      default:
                        title = 'Post a Deal';
                        leading = Icon(
                          LucideIcons.trophy,
                          color: textColor.withValues(alpha: 1),
                          size: 26,
                        );
                    }

                    return ListTile(
                      onTap: () {
                        if (!profileController.myProfile.hasShop &&
                            index != 2) {
                          Get.to(() => const MyProfileScreen(
                                currentIndex: 1,
                              ));
                        } else {
                          handleSellOptionTap(
                            context: context,
                            index: index,
                            profileController: profileController,
                            shopController: shopController,
                          );
                        }
                      },
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 10),
                      leading: leading,
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
