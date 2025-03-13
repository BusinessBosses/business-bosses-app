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
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void sellProduct(BuildContext context) {
  ProfileController profileController = Get.find();
  ShopController shopController = Get.find();
  SupplierController supplierController = Get.put(SupplierController());
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
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
                // Set a specific height
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);

                        if (index == 0 || index == 1) {
                          if (!profileController.myProfile.hasShop) {
                            supplierController.allSuppliers.any(
                                    (SuppliersModel supplier) =>
                                        supplier.name ==
                                        shopController.shop?.name)
                                ? Get.to(() => const AddSupplierScreen())
                                : Get.bottomSheet(
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0.0,
                                                    top: 0,
                                                    bottom: 10),
                                                child: ProSubscribeSection(
                                                  isGrow: true,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                  );
                          } else {
                            Get.to(() => index == 0
                                ? const CreateProductListing(
                                    isMarketplace: true)
                                : const CreateServiceListing(
                                    isMarketplace: true));
                          }
                        } else {
                          if (profileController.myProfile.hasShop) {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount: 2,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    if (index == 0) {
                                                      // Show loader dialog similar to the migration loader
                                                      Get.dialog(
                                                        const AlertDialog(
                                                          content: Row(
                                                            children: <Widget>[
                                                              CircularProgressIndicator(),
                                                              SizedBox(
                                                                  width: 20),
                                                              Text(
                                                                  'Adding Biz-Center to Supplier...'),
                                                            ],
                                                          ),
                                                        ),
                                                        barrierDismissible:
                                                            false,
                                                      );

                                                      // Execute your async logic (replace with your actual function)
                                                      final dynamic data =
                                                          <String, Object?>{
                                                        'category':
                                                            shopController
                                                                .shop!.category,
                                                        'location':
                                                            shopController
                                                                .shop!.location,
                                                        'description':
                                                            shopController.shop!
                                                                .description,
                                                        'userId':
                                                            profileController
                                                                .myProfile.uid,
                                                        'name': shopController
                                                            .shop!.name,
                                                        'email': shopController
                                                            .shop!.email,
                                                        'phone': shopController
                                                            .shop!.phone,
                                                        'url': shopController
                                                            .shop!.url,
                                                        'images': <String?>[
                                                          shopController
                                                              .shop!.image
                                                        ],
                                                        'isBiz': true,
                                                        'shopId': shopController
                                                            .shop!.id,
                                                      };
                                                      ApiResponseModel
                                                          response =
                                                          await supplierController
                                                              .addSupplier(
                                                                  data);
                                                      Get.back();
                                                      // Show a snackbar or perform additional actions based on success/failure
                                                      if (response.success) {
                                                        await Get.dialog(
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Supplier Added Succesfully!'),
                                                            content: const Text(
                                                                'It will show in marketplace when the admin approves it.'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context); // dismiss migration dialog
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Close'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        showSnackbar(
                                                            message:
                                                                'Error adding Biz-Center to supplier.',
                                                            error: true);
                                                      }
                                                    } else {
                                                      Get.to(() =>
                                                          const AddSupplierScreen());
                                                    }
                                                  },
                                                  minVerticalPadding: 0,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 10,
                                                  ),
                                                  leading: SvgPicture.asset(
                                                    index == 0
                                                        ? 'assets/svgs/addproduct.svg'
                                                        : 'assets/svgs/addservice.svg',
                                                    height: 25,
                                                    color: textColor
                                                        .withOpacity(1),
                                                  ),
                                                  title: Text(
                                                    index == 0
                                                        ? 'Add My Biz-Center To Supplier'
                                                        : 'Add New Supplier',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Get.to(() => const AddSupplierScreen());
                          }
                        }
                      },
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 10),
                      leading: SvgPicture.asset(
                        index == 0
                            ? 'assets/svgs/addproduct.svg'
                            : index == 1
                                ? 'assets/svgs/addservice.svg'
                                : 'assets/svgs/addclient.svg',
                        height: 25,
                        color: textColor.withOpacity(1),
                      ),
                      title: Text(
                        index == 0
                            ? 'Sell your product'
                            : index == 1
                                ? 'Sell your service'
                                : 'Add a supplier',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
