import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
          child: Column(
            children: <Widget>[
              Container(
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
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(150, 45)),
                              onPressed: () {
                                setState(() {});
                                setState(() {});
                                if (shopController.shop == null) {
                                  showSnackbar(
                                    message: 'Create a Biz-Center First',
                                    error: true,
                                  );
                                  return;
                                }
                                Get.to(() => const CreateProductListing());
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
                                  const SizedBox(width: 5),
                                  SvgPicture.asset(
                                      'assets/svgs/startatopic.svg')
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ProshopdealsWidget(
                  title: 'NEW',
                  products: _marketController.proProducts
                      .where((Product item) =>
                          item.images != null &&
                          item.images!.isNotEmpty &&
                          item.images![0].isNotEmpty &&
                          item.user!.isSubscribed)
                      .take(10)
                      .toList(),
                  initialIndex: 1,
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
                  itemCount: _marketController.proProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final Product product =
                        _marketController.proProducts[index];
                    return GestureDetector(
                      onTap: () {
                        if (product.user!.uid ==
                            profileController.myProfile.uid) {
                          // Navigate to edit listing
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
                        myShop: product.user!.uid ==
                            profileController.myProfile.uid,
                      ),
                    );
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
