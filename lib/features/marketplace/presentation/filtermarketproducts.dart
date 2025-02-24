import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';

import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class FilterMarketplaceProducts extends StatelessWidget {
  /// CONSTRUCTOR
  const FilterMarketplaceProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          builder: (MarketController marketController) =>
              marketController.filteredProducts.isEmpty
                  ? marketController.searchQuery.isEmpty &&
                          (marketController.selectedCategory == null ||
                              (marketController.selectedCategory != null &&
                                  marketController.selectedCategory!.isEmpty))
                      ? const SafetyModel(
                          isLoading: false,
                          icon: Icon(
                            Icons.search,
                            size: 50,
                          ),
                          title: 'Search For Products',
                        )
                      : const SafetyModel(
                          isLoading: false,
                          icon: Icon(Icons.warning),
                          title: 'No Product Found!',
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
                          itemCount: marketController.filteredProducts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final Product product =
                                marketController.filteredProducts[index];
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
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
