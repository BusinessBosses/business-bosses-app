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
import 'package:business_bosses_v2/utils/theme/theme.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: GetBuilder<MarketController>(
              builder: (MarketController controller) {
            bool isFiltering = controller.isfiltered.value;
            List<Object> markets =
                isFiltering ? controller.allFilteredItems : controller.proItems;
            return Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ProshopdealsWidget(
                    title: 'NEW',
                    combinedList: controller.proItems
                        .where((Object item) {
                          if (item is Product) {
                            return item.images != null &&
                                item.images!.isNotEmpty &&
                                item.images!.first.isNotEmpty &&
                                (item).user!.isSubscribed;
                          } else {
                            return (item as Service).images != null &&
                                (item).images!.isNotEmpty &&
                                (item).images![0].isNotEmpty &&
                                (item).user!.isSubscribed;
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
                        horizontal: 10.0, vertical: 10.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      itemCount: markets.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        if (markets[index] is Product) {
                          final Product product = markets[index] as Product;
                          return GestureDetector(
                            onTap: () {
                              if (product.user!.uid ==
                                  profileController.myProfile.uid) {
                                // Get.to(() => CreateProductListing(product: product));
                              } else {
                                Get.to(() => OrderProductScreen(
                                      ismarketplace: true,
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
                        } else if (markets[index] is Service) {
                          final Service service = markets[index] as Service;
                          return GestureDetector(
                            onTap: () {
                              if (service.user!.uid ==
                                  profileController.myProfile.uid) {
                                // Get.to(() => CreateServiceListing(service: service));
                              } else {
                                Get.to(() => BookServiceScreen(
                                      isMarketplace: true,
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
                        }
                        return const SizedBox();
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
