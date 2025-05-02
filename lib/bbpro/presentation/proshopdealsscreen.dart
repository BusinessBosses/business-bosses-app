import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProshopdealsScreen extends StatefulWidget {
  final int? initialIndex;
  const ProshopdealsScreen({
    super.key,
    this.initialIndex = 0,
  });

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
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Object> proItems =
        marketController.proItems.where((Object object) {
      if (object is Product) {
        if (object.user!.isSubscribed) return true;
      } else if (object is Service) {
        if (object.user!.isSubscribed) return true;
      }
      return false;
    }).toList();
    final List<Product> proProducts =
        marketController.proProducts.where((Product object) {
      if (object.user!.isSubscribed) return true;
      return false;
    }).toList();
    final List<Service> proServices =
        marketController.proServices.where((Service object) {
      if (object.user!.isSubscribed) return true;

      return false;
    }).toList();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text('Featured Listing'),
            const SizedBox(height: 3),
            Text(
              'Select a listing to share',
              style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
            ),
          ],
        ),
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
        actions: <Widget>[
          profileController.myProfile.isSubscribed
              ? PopupMenuButton<String>(
                  onSelected: (String item) {
                    switch (item) {
                      case 'Item 1':
                        Get.to(() => const CreateProductListing());
                        break;
                      case 'Item 2':
                        Get.to(() => const CreateServiceListing());
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Item 1',
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/addproduct.svg',
                              colorFilter: const ColorFilter.mode(
                                textColor,
                                BlendMode.srcIn,
                              ),
                              height: 15,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Create a Product',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Item 2',
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/addservice.svg',
                              height: 15,
                              colorFilter: const ColorFilter.mode(
                                textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Create a Service',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  offset: const Offset(0, 60),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/addtolist.svg',
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                                primaryColorLT, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Get listing featured',
                            style: TextStyle(
                              color: primaryColorLT,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              : GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.9,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, top: 0, bottom: 10),
                                  child: PremiumScreen()),
                            ],
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset('assets/svgs/addtolist.svg',
                              color: primaryColorLT, height: 16),
                          const SizedBox(width: 3),
                          const Text(
                            'Get listing featured',
                            style: TextStyle(
                              color: primaryColorLT,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // ALL ITEMS
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              itemCount: proItems.length,
              itemBuilder: (BuildContext context, int index) {
                if (proItems[index] is Product) {
                  final Product product = proItems[index] as Product;
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
                      marketplace: true,
                      product: product,
                      shop: product.shop!,
                      myShop:
                          product.user!.uid == profileController.myProfile.uid
                              ? true
                              : false,
                    ),
                  );
                } else {
                  final Service service = proItems[index] as Service;
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
                        Get.to(() => BookServiceScreen(
                              service: service,
                              shop: service.shop!,
                            ));
                      }
                    },
                    child: ServiceCard(
                      shop: service.shop!,
                      service: service,
                      marketplace: true,
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
          if (proProducts.isEmpty) ...<Widget>{
            const SafetyModel(
              isLoading: false,
              title: 'No Products Yet!',
            )
          } else ...<Widget>{
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                itemCount: proProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product product = proProducts[index];
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
                      marketplace: true,
                      shop: product.shop!,
                      myShop:
                          product.user!.uid == profileController.myProfile.uid
                              ? true
                              : false,
                    ),
                  );
                },
              ),
            ),
          },
          // SERVICES
          if (proServices.isEmpty) ...<Widget>{
            const SafetyModel(
              isLoading: false,
              title: 'No Services Yet!',
            )
          } else ...<Widget>{
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                itemCount: proServices.length,
                itemBuilder: (BuildContext context, int index) {
                  final Service service = proServices[index];
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
                      myShop:
                          service.user!.uid == profileController.myProfile.uid
                              ? true
                              : false,
                    ),
                  );
                },
              ),
            ),
          }
        ],
      ),
    );
  }
}
