import 'package:business_bosses_v2/features/profile/presentation/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
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

/// Displays the supplier options bottom sheet.
void showSupplierOptionsBottomSheet(
  BuildContext context,
  ShopController shopController,
  ProfileController profileController,
  SupplierController supplierController,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        if (index == 0) {
                          if (!profileController.myProfile.hasShop) {
                            showSubscriptionBottomSheet(context);
                            return;
                          }
                          // "Add My Biz-Center To Supplier" option.
                          Get.dialog(
                            const AlertDialog(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text('Adding Biz-Center to Supplier...'),
                                ],
                              ),
                            ),
                            barrierDismissible: false,
                          );

                          final Map<String, dynamic> data = <String, dynamic>{
                            'category': shopController.shop!.category,
                            'location': shopController.shop!.location,
                            'description': shopController.shop!.description,
                            'userId': profileController.myProfile.uid,
                            'name': shopController.shop!.name,
                            'email': shopController.shop!.email,
                            'phone': shopController.shop!.phone,
                            'url': shopController.shop!.url,
                            'images': <String?>[shopController.shop!.image],
                            'isBiz': true,
                            'shopId': shopController.shop!.id,
                          };

                          final ApiResponseModel response =
                              await supplierController.addSupplier(data);
                          Get.back(); // Dismiss the loader

                          if (response.success) {
                            await Get.dialog(
                              AlertDialog(
                                title:
                                    const Text('Supplier Added Successfully!'),
                                content: const Text(
                                  'It will show in marketplace when the admin approves it.',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showSnackbar(
                              message: 'Error adding Biz-Center to supplier.',
                              error: true,
                            );
                          }
                        } else {
                          // "Add New Supplier" option.
                          Get.to(() => const AddSupplierScreen());
                        }
                      },
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 10),
                      leading: SvgPicture.asset(
                        index == 0
                            ? 'assets/svgs/addproduct.svg'
                            : 'assets/svgs/addservice.svg',
                        height: 25,
                        colorFilter: ColorFilter.mode(
                          textColor.withValues(alpha: 1),
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(
                        index == 0
                            ? 'Add My Biz-Center To Supplier'
                            : 'Add New Supplier',
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

/// Handles the tap on a sell option (product, service, or supplier).
void handleSellOptionTap({
  required BuildContext context,
  required int index,
  required ProfileController profileController,
  required ShopController shopController,
  required SupplierController supplierController,
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
    // Option for adding a supplier.
    final bool isSupplierExist = supplierController.allSuppliers.any(
      (SuppliersModel supplier) => supplier.name == shopController.shop?.name,
    );
    if (isSupplierExist) {
      Get.to(() => const AddSupplierScreen());
    } else {
      showSupplierOptionsBottomSheet(
        context,
        shopController,
        profileController,
        supplierController,
      );
    }
  }
}

/// Main function to show the sell product bottom sheet.
void sellProduct(BuildContext context) {
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final SupplierController supplierController = Get.put(SupplierController());

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
                    String svgAsset;
                    switch (index) {
                      case 0:
                        title = 'Sell your product';
                        svgAsset = 'assets/svgs/addproduct.svg';
                        break;
                      case 1:
                        title = 'Sell your service';
                        svgAsset = 'assets/svgs/addservice.svg';
                        break;
                      default:
                        title = 'Add a supplier';
                        svgAsset = 'assets/svgs/addclient.svg';
                    }

                    return ListTile(
                      onTap: () => <void>{
                        if (!profileController.myProfile.hasShop)
                          <Future?>{
                            Get.to(() => const MyProfileScreen(
                                  currentIndex: 1,
                                ))
                          }
                        else
                          <void>{
                            handleSellOptionTap(
                              context: context,
                              index: index,
                              profileController: profileController,
                              shopController: shopController,
                              supplierController: supplierController,
                            )
                          },
                      },
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 10),
                      leading: SvgPicture.asset(
                        svgAsset,
                        height: 25,
                        colorFilter: ColorFilter.mode(
                          textColor.withValues(alpha: 1),
                          BlendMode.srcIn,
                        ),
                      ),
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
