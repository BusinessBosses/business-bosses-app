import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _marketController.isfiltered.value
            ? _marketController.searchResult.length
            : _marketController.products.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index <
              (_marketController.isfiltered.value
                  ? _marketController.searchResult.length
                  : _marketController.products.length)) {
            final MarketModel market = _marketController.isfiltered.value
                ? _marketController.searchResult[index]
                : _marketController.products[index];
            return VisibilityDetector(
              key: Key(index.toString()),
              onVisibilityChanged: (VisibilityInfo info) {
                final bool hasIncrementedView = hmeController
                    .itemsWithIncrementedViews
                    .contains(_marketController.products[index].marketId);
                if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                  _marketController
                      .updatemarketViews(_marketController.products[index]);
                  setState(() {
                    hmeController.itemsWithIncrementedViews.add(_marketController
                        .products[index]
                        .marketId); // Set the flag to prevent further increments
                  });
                }
              },
              child: MarketTile(
                post: market,
                controller: _marketController,
                key: ValueKey(_marketController.products[index].marketId),
              ),
            );
          } else {
            // Display a loading indicator at the end of the list
            if (_marketController.loadingMore.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      );
    });
  }
}
