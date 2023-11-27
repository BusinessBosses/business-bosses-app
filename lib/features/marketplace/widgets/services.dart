import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _marketController.isfiltered.value
            ? _marketController.searchResult.length
            : _marketController.services.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index <
              (_marketController.isfiltered.value
                  ? _marketController.searchResult.length
                  : _marketController.services.length)) {
            final MarketModel market = _marketController.isfiltered.value
                ? _marketController.searchResult[index]
                : _marketController.services[index];
            return VisibilityDetector(
              key: Key(index.toString()),
              onVisibilityChanged: (VisibilityInfo info) {
                final bool hasIncrementedView = hmeController
                    .itemsWithIncrementedViews
                    .contains(_marketController.services[index].marketId);
                if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                  _marketController
                      .updatemarketViews(_marketController.services[index]);
                  setState(() {
                    hmeController.itemsWithIncrementedViews.add(_marketController
                        .services[index]
                        .marketId); // Set the flag to prevent further increments
                  });
                }
              },
              child: ServiceTile(
                post: market,
                controller: _marketController,
                key: ValueKey(_marketController.services[index].marketId),
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
