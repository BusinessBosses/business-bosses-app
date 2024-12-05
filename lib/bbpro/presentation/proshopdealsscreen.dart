import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProshopdealsScreen extends StatefulWidget {
  const ProshopdealsScreen({super.key});

  @override
  State<ProshopdealsScreen> createState() => _ProshopdealsScreenState();
}

class _ProshopdealsScreenState extends State<ProshopdealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MarketController marketController = Get.find();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Featured Listing'),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          labelColor: Colors.black,
          indicatorColor: primaryColorLT,
          tabs: const <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Products'),
            Tab(text: 'Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // ALL ITEMS
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              itemCount: marketController.proItems.length,
              itemBuilder: (BuildContext context, int index) {
                if (marketController.proItems[index] is Product) {
                  final Product product =
                      marketController.proItems[index] as Product;
                  return GestureDetector(
                    onTap: () {
                      if (product.user!.uid ==
                          profileController.myProfile.uid) {
                        Get.to(
                          () => CreateProductListing(
                            product: product,
                          ),
                        );
                      } else {
                        Get.to(() => OrderProductScreen(
                              product: product,
                              shop: product.shop!,
                            ));
                      }
                    },
                    child: InventoryCard(
                      product: product,
                      shop: product.shop!,
                      myShop:
                          product.user!.uid == profileController.myProfile.uid
                              ? true
                              : false,
                    ),
                  );
                } else {
                  final Service service =
                      marketController.proItems[index] as Service;
                  return GestureDetector(
                    onTap: () {
                      if (service.user!.uid ==
                          profileController.myProfile.uid) {
                        Get.to(
                          () => CreateServiceListing(
                            service: service,
                          ),
                        );
                      } else {
                        BookServiceScreen(
                          service: service,
                          shop: service.shop!,
                        );
                      }
                    },
                    child: ServiceCard(
                      shop: service.shop!,
                      service: service,
                      myShop:
                          service.user!.uid == profileController.myProfile.uid
                              ? true
                              : false,
                    ),
                  );
                }
              },
            ),
          ),
          // PRODUCTS
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              itemCount: marketController.proProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final Product product = marketController.proProducts[index];
                return GestureDetector(
                  onTap: () {
                    if (product.user!.uid == profileController.myProfile.uid) {
                      Get.to(
                        () => CreateProductListing(
                          product: product,
                        ),
                      );
                    } else {
                      Get.to(() => OrderProductScreen(
                            product: product,
                            shop: product.shop!,
                          ));
                    }
                  },
                  child: InventoryCard(
                    product: product,
                    shop: product.shop!,
                    myShop: product.user!.uid == profileController.myProfile.uid
                        ? true
                        : false,
                  ),
                );
              },
            ),
          ),
          // SERVICES
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              itemCount: marketController.proServices.length,
              itemBuilder: (BuildContext context, int index) {
                final Service service = marketController.proServices[index];
                return GestureDetector(
                  onTap: () {
                    if (service.user!.uid == profileController.myProfile.uid) {
                      Get.to(
                        () => CreateServiceListing(
                          service: service,
                        ),
                      );
                    } else {
                      BookServiceScreen(
                        service: service,
                        shop: service.shop!,
                      );
                    }
                  },
                  child: ServiceCard(
                    shop: service.shop!,
                    service: service,
                    myShop: service.user!.uid == profileController.myProfile.uid
                        ? true
                        : false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
