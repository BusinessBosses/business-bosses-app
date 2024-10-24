import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/bookservice.dart';
import 'package:business_bosses_v2/bbpro/presentation/orderproduct.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: const Text(
            'Shop',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          //  Row(
          //   children: <Widget>[
          //     SizedBox(
          //       height: 40.0,
          //       width: 40.0,
          //       child: Align(
          //         alignment: Alignment.topLeft,
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(1000),
          //           child: NetworkImageWithPlaceHolder(
          //             imageUrl: shopController.shop!.image ?? '',
          //             radius: radius,
          //             placeHolder: Icons.person,
          //             iconSize: 22.0,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Text(shopController.shop!.name,
          //             style: const TextStyle(
          //                 fontWeight: FontWeight.bold, fontSize: 14)),
          //         const SizedBox(height: 2),
          //         Text(shopController.shop!.description,
          //             style: const TextStyle(
          //                 fontWeight: FontWeight.normal, fontSize: 12)),
          //       ],
          //     ),
          //   ],
          // ),
          actions: const <Widget>[],
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height: 100.0,
            width: 100.0,
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(shopController.shop!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                DetectableText(
                  text: shopController.shop!.description,
                  detectionRegExp: detectionRegExp(hashtag: false)!,
                  detectedStyle: bodyText2.copyWith(
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                  moreStyle: bodyText2.copyWith(
                    color: Colors.redAccent,
                  ),
                  lessStyle: bodyText2.copyWith(
                    color: Colors.redAccent,
                  ),
                  trimLength: 100,
                  trimExpandedText: '  show less',
                  basicStyle: bodyText2.copyWith(color: textColor),
                  onTap: (String text) async {
                    final Uri url = Uri.parse(text);
                    if ((url.scheme == 'http' || url.scheme == 'https')) {
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    } else if (text.startsWith('wa.me')) {
                      // Handle "wa.me" links
                      final Uri whatsappUrl = Uri.parse('https://$text');
                      if (await launchUrl(whatsappUrl)) {
                        await launchUrl(whatsappUrl);
                      } else {
                        throw Exception('Could not launch $whatsappUrl');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_on,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text(shopController.shop!.location),
                    ],
                  ),
                  const Text('Contact'),
                  const Row(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    'All(${shopController.products.length + shopController.services.length})'),
                GestureDetector(
                  onTap: () {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(
                            button.size.topRight(const Offset(0, 0)),
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
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: backgroundColor,
                          child: SvgPicture.asset(
                              'assets/svgs/filterprosections.svg'),
                        ),
                        const Text('All')
                      ],
                    ),
                  ),
                ),
              ],
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
              itemCount: shopController.products.length +
                  shopController.services.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < shopController.products.length) {
                  final Product product = shopController.products[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => OrderProductScreen(product: product));
                    },
                    child: InventoryCard(
                      product: product,
                      myShop: true,
                    ),
                  );
                } else {
                  final Service service = shopController
                      .services[index - shopController.products.length];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => BookServiceScreen(service: service));
                    },
                    child: ServiceCard(
                      myShop: true,
                      service: service,
                    ),
                  );
                }
              },
            ),
          )
        ]));
  }
}
