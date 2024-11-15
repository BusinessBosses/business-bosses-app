import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();
  // ignore: unused_field
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(
                        button.size.topRight(const Offset(0, 110)),
                        ancestor: overlay),
                    button.localToGlobal(
                        button.size.bottomRight(const Offset(0, 20)),
                        ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );

                showMenu(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  context: context,
                  shadowColor: Colors.black,
                  position: position,
                  items: <String>[
                    'All Products',
                    'Low Stock',
                    'Out of Stock',
                    'Most Popular',
                    'Newest First',
                  ].map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ).then((String? selected) {
                  if (selected != null) {
                    setState(() {
                      _selectedItem = selected;
                    });
                    // Implement filter logic here
                  }
                });
              },
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                child: SvgPicture.asset('assets/svgs/filterprosections.svg'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(children: <Widget>[
                  const Text(
                    'Products List',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Obx(
                    () => Text(
                      '(${shopController.products.length})',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ]),
                ProCustomButton(
                  text: 'Add Products',
                  onPressed: () {
                    Get.to(() => const CreateProductListing());
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Obx(
            () => shopController.products.isEmpty
                ? const SafetyModel(
                    isLoading: false,
                    title: 'No Products In Your Inventory!',
                  )
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      itemCount: shopController.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Product product = shopController.products[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CreateProductListing(
                                product: product,
                              ),
                            );
                          },
                          child: InventoryCard(
                            product: product,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
