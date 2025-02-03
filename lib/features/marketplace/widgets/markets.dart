import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_item_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();

  @override
  Widget build(BuildContext context) {
    _marketController.proItems.sort((Object a, Object b) {
      final DateTime aDate = (a is Product)
          ? a.createdAt
          : (a is Service)
              ? a.createdAt
              : (a as Customitem).createdAt;
      final DateTime bDate = (b is Product)
          ? b.createdAt
          : (b is Service)
              ? b.createdAt
              : (b as Customitem).createdAt;

      final String? aLocation = (a is Product)
          ? a.location
          : (a is Service)
              ? a.location
              : (a as Customitem).shop!.location;
      final String? bLocation = (b is Product)
          ? b.location
          : (b is Service)
              ? b.location
              : (b as Customitem).shop!.location;

      final String? myLocation =
          profileController.myProfile.location?.toLowerCase();

      // Ensure case-insensitive comparison
      final String aLoc = aLocation?.toLowerCase() ?? '';
      final String bLoc = bLocation?.toLowerCase() ?? '';

      // Step 1: Prioritize myLocation (Nigeria) at the top
      final bool aIsMyLocation = aLoc == myLocation;
      final bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1; // a (Nigeria) goes up
      if (!aIsMyLocation && bIsMyLocation) return 1; // b (Nigeria) goes up

      // Step 2: If both are Nigeria (or both are not Nigeria), sort by date (newest first)
      final DateTime safeADate = aDate;
      final DateTime safeBDate = bDate;

      return safeBDate.compareTo(safeADate);
    });

    _marketController.proItemsWithImages.sort((Object a, Object b) {
      final DateTime aDate = (a is Product)
          ? a.createdAt
          : (a is Service)
              ? a.createdAt
              : (a as Customitem).createdAt;
      final DateTime bDate = (b is Product)
          ? b.createdAt
          : (b is Service)
              ? b.createdAt
              : (b as Customitem).createdAt;

      final String? aLocation = (a is Product)
          ? a.location
          : (a is Service)
              ? a.location
              : (a as Customitem).shop!.location;
      final String? bLocation = (b is Product)
          ? b.location
          : (b is Service)
              ? b.location
              : (b as Customitem).shop!.location;

      final String? myLocation =
          profileController.myProfile.location?.toLowerCase();

      // Ensure case-insensitive comparison
      final String aLoc = aLocation?.toLowerCase() ?? '';
      final String bLoc = bLocation?.toLowerCase() ?? '';

      // Step 1: Prioritize myLocation (Nigeria) at the top
      final bool aIsMyLocation = aLoc == myLocation;
      final bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1; // a (Nigeria) goes up
      if (!aIsMyLocation && bIsMyLocation) return 1; // b (Nigeria) goes up

      // Step 2: If both are Nigeria (or both are not Nigeria), sort by date (newest first)
      final DateTime safeADate = aDate;
      final DateTime safeBDate = bDate;

      return safeBDate.compareTo(safeADate);
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ProshopdealsWidget(
                  title: 'NEW',
                  combinedList:
                      _marketController.proItemsWithImages.take(10).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  itemCount: _marketController.proItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (_marketController.proItems[index] is Product) {
                      final Product product =
                          _marketController.proItems[index] as Product;
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
                    } else if (_marketController.proItems[index] is Service) {
                      final Service service =
                          _marketController.proItems[index] as Service;
                      return GestureDetector(
                        onTap: () {
                          if (service.user!.uid ==
                              profileController.myProfile.uid) {
                            // Get.to(() => CreateServiceListing(service: service));
                          } else {
                            Get.to(() => BookServiceScreen(
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
                    } else {
                      final Customitem customitem =
                          _marketController.proItems[index] as Customitem;
                      print(customitem.toJson());
                      return GestureDetector(
                        onTap: () {
                          if (customitem.user!.uid ==
                              profileController.myProfile.uid) {
                            // Get.to(() => CreateServiceListing(service: service));
                          } else {}
                        },
                        child: CustomItemCard(
                          customitem: customitem,
                          myShop: customitem.user!.uid ==
                                  profileController.myProfile.uid
                              ? true
                              : false,
                          shop: customitem.shop,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
