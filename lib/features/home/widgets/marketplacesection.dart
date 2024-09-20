import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MarketplaceSection extends StatelessWidget {
  const MarketplaceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketController marketController = Get.find();
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.marketPlace);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Marketplace',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text(
                          'View all',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 5.0),
                        SvgPicture.asset(
                          'assets/svgs/nexticon.svg',
                          // ignore: deprecated_member_use
                          color: textColor,
                          height: 8,
                        ),
                      ]),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  final List<MarketModel> filteredMarkets =
                      marketController.isfiltered.value
                          ? marketController.searchResult
                              .where((MarketModel market) =>
                                  market.images != null &&
                                  market.images!.isNotEmpty)
                              .toList()
                          : marketController.markets
                              .where((MarketModel market) =>
                                  market.images != null &&
                                  market.images!.isNotEmpty)
                              .toList();
                  final MarketModel market = filteredMarkets[index];
                  return MarketTile(
                    ishome: true,
                    post: market,
                    controller: marketController,
                    key: ValueKey<String>(market.marketId),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
