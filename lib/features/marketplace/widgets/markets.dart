import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _marketController.isfiltered.value
            ? _marketController.searchResult.length
            : _marketController.markets.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index <
              (_marketController.isfiltered.value
                  ? _marketController.searchResult.length
                  : _marketController.markets.length)) {
            final MarketModel market = _marketController.isfiltered.value
                ? _marketController.searchResult[index]
                : _marketController.markets[index];
            return VisibilityDetector(
              key: Key(index.toString()),
              onVisibilityChanged: (VisibilityInfo info) {
                final bool hasIncrementedView = hmeController
                    .itemsWithIncrementedViews
                    .contains(_marketController.markets[index].marketId);
                if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                  _marketController
                      .updatemarketViews(_marketController.markets[index]);
                  setState(() {
                    hmeController.itemsWithIncrementedViews.add(_marketController
                        .markets[index]
                        .marketId); // Set the flag to prevent further increments
                  });
                }
              },
              child: _marketController.markets[index].isProduct
                  ? MarketTile(
                      post: market,
                      controller: _marketController,
                      key: ValueKey(_marketController.markets[index].marketId),
                    )
                  : ServiceTile(
                      post: market,
                      controller: _marketController,
                      key: ValueKey(_marketController.markets[index].marketId),
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
