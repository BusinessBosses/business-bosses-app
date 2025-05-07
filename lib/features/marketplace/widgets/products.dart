import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

String formatCount(int count) {
  if (count >= 1000) {
    double countInK = count / 1000;
    if (countInK >= 1000) {
      return '${(countInK / 1000).toStringAsFixed(1)}M';
    } else {
      return '${countInK.toStringAsFixed(1)}K';
    }
  } else {
    return count.toString();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: GetBuilder<MarketController>(
              builder: (MarketController controller) {
            bool isFiltering = _marketController.isfiltered.value;
            List<Product> products = !isFiltering
                ? _marketController.proProducts
                : _marketController.filteredProducts;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ProshopdealsWidget(
                    title: 'NEW',
                    products: _marketController.proProducts
                        .where((Product item) =>
                            item.images != null &&
                            item.images!.isNotEmpty &&
                            item.images![0].isNotEmpty &&
                            item.user!.isSubscribed)
                        .take(10)
                        .toList(),
                    initialIndex: 1,
                  ),
                ),
                if (isFiltering && products.isEmpty)
                  const SafetyModel(
                    isLoading: false,
                    title: 'No Products Found For This Search',
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final Product product = products[index];
                        return GestureDetector(
                          onTap: () {
                            if (product.user!.uid ==
                                profileController.myProfile.uid) {
                              // Navigate to edit listing
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
                                profileController.myProfile.uid,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
