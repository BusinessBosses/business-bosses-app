import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  final HomeController hmeController = Get.find();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      builder: (MarketController controller) {
        // Show loading state
        if (controller.loading.value && controller.proItems.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        bool isFiltering = controller.isfiltered.value;
        List<Object> markets =
            isFiltering ? controller.allFilteredItems : controller.proItems;

        // Show empty state if no items
        if (markets.isEmpty && !controller.loading.value) {
          return const SafetyModel(
            isLoading: false,
            title: 'No Items Available',
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100 &&
                !controller.loadingMore.value &&
                controller.hasMoreItems.value) {
              controller.loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              // Clear filters and reload data
              controller.clearFilter();
              await controller.initMarket();
              controller.sortItems();
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ProshopdealsWidget(
                      title: 'NEW',
                      combinedList: controller.proItems
                          .where((Object item) {
                            if (item is Product) {
                              return item.images != null &&
                                  item.images!.isNotEmpty &&
                                  item.images!.first.isNotEmpty &&
                                  item.user!.isSubscribed;
                            } else {
                              final Service service = item as Service;
                              return service.images != null &&
                                  service.images!.isNotEmpty &&
                                  service.images![0].isNotEmpty &&
                                  service.user!.isSubscribed;
                            }
                          })
                          .take(10)
                          .toList(),
                    ),
                  ),
                  if (isFiltering && markets.isEmpty)
                    const SafetyModel(
                      isLoading: false,
                      title: 'No Items Found For This Search',
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: MasonryGridView.count(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: markets.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Object item = markets[index];
                          if (item is Product) {
                            return GestureDetector(
                              onTap: () {
                                if (item.user!.uid ==
                                    profileController.myProfile.uid) {
                                  // Your own shop item.
                                } else {
                                  Get.to(() => OrderProductScreen(
                                        ismarketplace: true,
                                        product: item,
                                        shop: item.shop!,
                                      ));
                                }
                              },
                              child: InventoryCard(
                                marketplace: true,
                                product: item,
                                shop: item.shop!,
                                myShop: item.user!.uid ==
                                    profileController.myProfile.uid,
                              ),
                            );
                          } else {
                            final Service service = item as Service;
                            return GestureDetector(
                              onTap: () {
                                if (service.user!.uid ==
                                    profileController.myProfile.uid) {
                                  // Your own shop item.
                                } else {
                                  Get.to(() => BookServiceScreen(
                                        isMarketplace: true,
                                        service: service,
                                        shop: service.shop!,
                                      ));
                                }
                              },
                              child: ServiceCard(
                                marketplace: true,
                                service: service,
                                shop: service.shop!,
                                myShop: service.user!.uid ==
                                    profileController.myProfile.uid,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  Obx(() => controller.loadingMore.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox.shrink()),
                  if (!controller.hasMoreItems.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'No more items',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
