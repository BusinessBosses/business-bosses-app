import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
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
      final DateTime aDate =
          (a is Product) ? a.createdAt : (a as Service).createdAt;
      final DateTime bDate =
          (b is Product) ? b.createdAt : (b as Service).createdAt;

      final String? aLocation =
          (a is Product) ? a.location : (a as Service).location;
      final String? bLocation =
          (b is Product) ? b.location : (b as Service).location;

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
      final DateTime aDate =
          (a is Product) ? a.createdAt : (a as Service).createdAt;
      final DateTime bDate =
          (b is Product) ? b.createdAt : (b as Service).createdAt;

      final String? aLocation =
          (a is Product) ? a.location : (a as Service).location;
      final String? bLocation =
          (b is Product) ? b.location : (b as Service).location;

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
    // Print sorted locations
    print('Sorted Locations:');
    for (Object item in _marketController.proItems) {
      final String? location =
          (item is Product) ? item.location : (item as Service).location;
      print(location);
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 25),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/marketplace.svg',
                          height: 16,
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Listings (${formatCount(_marketController.proItems.length)})',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
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
                                minimumSize: const Size(150, 45)),
                            onPressed: () {
                              setState(() {});
                              if (shopController.shop == null) {
                                showSnackbar(
                                  message: 'Create a Biz-Center First',
                                  error: true,
                                );
                                return;
                              }
                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.separated(
                                                itemCount: 2,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const Divider(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      index == 0
                                                          ? Get.to(() =>
                                                              const CreateProductListing())
                                                          : Get.to(() =>
                                                              const CreateServiceListing());
                                                    },
                                                    minVerticalPadding: 0,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    leading: SvgPicture.asset(
                                                      index == 0
                                                          ? 'assets/svgs/sellicon.svg'
                                                          : 'assets/svgs/sellicon.svg',
                                                      height: 25,
                                                      color: textColor
                                                          .withOpacity(1),
                                                    ),
                                                    title: Text(
                                                      index == 0
                                                          ? 'Sell your product'
                                                          : 'Sell your service',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
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
                                SvgPicture.asset(
                                  'assets/svgs/startatopic.svg',
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                    } else {
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
