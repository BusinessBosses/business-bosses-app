import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/add_supplier_shop.dart';
import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void sellProduct(BuildContext context) {
  ProfileController profileController = Get.find();
  ShopController shopController = Get.find();
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, top: 0, bottom: 10),
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
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    index == 0
                                                        ? Get.to(() =>
                                                            AddSupplierShopScreen(
                                                              shop:
                                                                  shopController
                                                                      .shop!,
                                                            ))
                                                        : Get.to(() =>
                                                            const AddSupplierScreen());
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
