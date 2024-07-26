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

  @override
  Widget build(BuildContext context) {
    // int userCount = _marketController.users.length;
    // String formattedUserCount = formatCount(userCount);
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          itemCount: _marketController.isfiltered.value
              ? _marketController.searchResult.length + 1
              : _marketController.products.length +
                  1 +
                  1, // Add 1 for static text
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                color: backgroundcolorinterface,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 25),
                      child: GestureDetector(
                        onTap: (() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                sellingGuide(context),
                          );
                        }),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'Guidelines ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            SvgPicture.asset(
                              'assets/svgs/info.svg',
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150,
                                    45) // put the width and height you want
                                ),
                            onPressed: () {
                              Get.toNamed(Routes.sellscreen);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Sell',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/svgs/startatopic.svg')
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ],
                ),
              );
            } else if (index <=
                (_marketController.isfiltered.value
                    ? _marketController.searchResult.length
                    : _marketController.products.length)) {
              final MarketModel market = _marketController.isfiltered.value
                  ? _marketController
                      .searchResult[index - 1] // Adjust for static text
                  : _marketController
                      .products[index - 1]; // Adjust for static text
              return VisibilityDetector(
                key: Key(index.toString()),
                onVisibilityChanged: (VisibilityInfo info) {
                  final bool hasIncrementedView = hmeController
                      .itemsWithIncrementedViews
                      .contains(_marketController.products[index - 1]
                          .marketId); // Adjust for static text
                  if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                    _marketController.updatemarketViews(_marketController
                        .products[index - 1]); // Adjust for static text
                    setState(() {
                      hmeController.itemsWithIncrementedViews.add(
                          _marketController.products[index - 1]
                              .marketId); // Adjust for static text
                    });
                  }
                },
                child: MarketTile(
                  post: market,
                  controller: _marketController,
                  key: ValueKey(_marketController
                      .products[index - 1].marketId), // Adjust for static text
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
      }),
    );
  }
}
