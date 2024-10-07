import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/bookservice.dart';
import 'package:business_bosses_v2/bbpro/presentation/orderproduct.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopController shopController = Get.find();
  String? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: Row(
            children: <Widget>[
              SizedBox(
                height: 40.0,
                width: 40.0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: NetworkImageWithPlaceHolder(
                      imageUrl: shopController.shop!.image ?? '',
                      radius: radius,
                      placeHolder: Icons.person,
                      iconSize: 22.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(shopController.shop!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(shopController.shop!.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12)),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
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
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Catalog(10)'),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Location'),
                    ],
                  ),
                  Text('Contact'),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text('0.0 Reviews'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              physics: const AlwaysScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                return index == 2
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => const OrderProductScreen());
                        },
                        child: const InventoryCard(
                          myShop: true,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(() => const BookServiceScreen());
                        },
                        child: const ServiceCard(myShop: true));
              },
            ),
          ),
        ]));
  }
}
