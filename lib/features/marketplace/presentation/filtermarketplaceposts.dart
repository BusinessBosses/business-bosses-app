import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';

class FilterMarketplacePosts extends StatelessWidget {
  final List<MarketModel> filterItems;
  final bool isLoading;
  final bool isSearch;

  /// CONSTRUCTOR
  const FilterMarketplacePosts({
    Key? key,
    this.filterItems = const <MarketModel>[],
    this.isLoading = false,
    this.isSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MarketController controller = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: filterItems.isEmpty
          ? SafetyModel(
              icon: const Icon(
                Icons.search,
                size: 80.0,
                color: hintColor,
              ),
              title: 'No results found',
              subTitle: 'Your results will be displayed here!',
              isLoading: isLoading,
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollNotification) {
                FocusScope.of(context).unfocus();
                return false;
              },
              child: ListView.separated(
                key: key,
                separatorBuilder: (_, __) => const SizedBox(height: 0.0),
                padding: const EdgeInsets.all(0.0),
                itemCount: filterItems.length,
                itemBuilder: (BuildContext context, int i) {
                  return MarketTile(
                    post: filterItems[i],
                    controller: controller,
                  );
                },
              ),
            ),
    );
  }
}
