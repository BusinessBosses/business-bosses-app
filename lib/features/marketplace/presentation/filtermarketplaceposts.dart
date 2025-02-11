import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_item_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';

import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class FilterMarketplacePosts extends StatefulWidget {
  /// CONSTRUCTOR
  const FilterMarketplacePosts({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterMarketplacePosts> createState() => _FilterMarketplacePostsState();
}

class _FilterMarketplacePostsState extends State<FilterMarketplacePosts> {
  @override
  Widget build(BuildContext context) {
    final MarketController marketController = Get.find();
    final ProfileController profileController = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: GetBuilder<MarketController>(
          builder: (MarketController controller) =>
              marketController.allFilteredItems.isEmpty
                  ? const SafetyModel(
                      isLoading: false,
                      icon: Icon(Icons.warning),
                      title: 'No Item Found!',
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (int index) =>
                              const StaggeredTile.fit(1),
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          itemCount: marketController.allFilteredItems.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (marketController.allFilteredItems[index]
                                is Product) {
                              final Product product = marketController
                                  .allFilteredItems[index] as Product;
                              return GestureDetector(
                                onTap: () {
                                  if (product.user!.uid ==
                                      profileController.myProfile.uid) {
                                    // Get.to(() => CreateProductListing(product: product));
                                  } else {
                                    Get.to(() => OrderProductScreen(
                                          product: product,
                                          shop: product.shop!,
                                        ));
                                  }
                                },
                                child: InventoryCard(
                                  marketplace: true,
                                  product: product,
                                  shop: product.shop!,
                                  myShop: product.user!.uid ==
                                          profileController.myProfile.uid
                                      ? true
                                      : false,
                                ),
                              );
                            } else if (marketController.allFilteredItems[index]
                                is Service) {
                              final Service service = marketController
                                  .allFilteredItems[index] as Service;
                              return GestureDetector(
                                onTap: () {
                                  if (service.user!.uid ==
                                      profileController.myProfile.uid) {
                                    // Get.to(() => CreateServiceListing(service: service));
                                  } else {
                                    Get.to(() => BookServiceScreen(
                                          service: service,
                                          shop: service.shop!,
                                        ));
                                  }
                                },
                                child: ServiceCard(
                                  shop: service.shop!,
                                  marketplace: true,
                                  service: service,
                                  myShop: service.user!.uid ==
                                          profileController.myProfile.uid
                                      ? true
                                      : false,
                                ),
                              );
                            } else {
                              final Customitem customitem = marketController
                                  .allFilteredItems[index] as Customitem;

                              return GestureDetector(
                                onTap: () {
                                  if (customitem.user!.uid ==
                                      profileController.myProfile.uid) {
                                    // Get.to(() => CreateServiceListing(service: service));
                                  } else {}
                                },
                                child: CustomItemCard(
                                  customitem: customitem,
                                  myShop: customitem.user!.uid ==
                                          profileController.myProfile.uid
                                      ? true
                                      : false,
                                  shop: customitem.shop,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
