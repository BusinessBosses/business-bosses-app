import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/bookservice.dart';
import 'package:business_bosses_v2/bbpro/presentation/orderproduct.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
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
  String? _selectedItem = 'All Products';
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
          actions: const <Widget>[],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
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
                  const SizedBox(height: 10),
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
                          detectedStyle: bodyText2.copyWith(color: Colors.blue),
                          textAlign: TextAlign.center,
                          moreStyle:
                              bodyText2.copyWith(color: Colors.redAccent),
                          lessStyle:
                              bodyText2.copyWith(color: Colors.redAccent),
                          trimLength: 100,
                          trimExpandedText: '  show less',
                          basicStyle: bodyText2.copyWith(color: textColor),
                          onTap: (String text) async {
                            final Uri url = Uri.parse(text);
                            if ((url.scheme == 'http' ||
                                url.scheme == 'https')) {
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            } else if (text.startsWith('wa.me')) {
                              final Uri whatsappUrl =
                                  Uri.parse('https://$text');
                              if (await launchUrl(whatsappUrl)) {
                                await launchUrl(whatsappUrl);
                              } else {
                                throw Exception(
                                    'Could not launch $whatsappUrl');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
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
                              Text(
                                shopController.shop!.location.length > 15
                                    ? '${shopController.shop!.location.substring(0, 15)}...'
                                    : shopController.shop!.location,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return _buildContactInfo();
                                },
                              );
                            },
                            child: const Text(
                              'Contact',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => SellerReviewScreen(
                                      user: shopController.shop!.user!));
                                },
                                child: const Text(
                                  '0.0 Reviews',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
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
                          'All (${shopController.products.length + shopController.services.length})',
                          style: const TextStyle(fontSize: 14),
                        ),
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
                                    button.size.topRight(const Offset(0, 380)),
                                    ancestor: overlay),
                                button.localToGlobal(
                                    button.size
                                        .bottomRight(const Offset(0, 20)),
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
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ).then((String? selected) {
                              if (selected != null) {
                                setState(() {
                                  _selectedItem = selected;
                                });
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
                                Text(
                                  _selectedItem!,
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              sliver: SliverStaggeredGrid.countBuilder(
                crossAxisCount: 2,
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
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
          ],
        ));
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 50),
          if (shopController.shop?.user?.website?.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/website.svg',
              'Shop Url',
              shopController.shop!.user!.website,
              12,
              () async {
                final Uri uri =
                    Uri.parse('https://${shopController.shop!.user!.website}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (shopController.shop?.user?.website?.isNotEmpty ?? false)
            _buildDivider(),
          if (shopController.shop?.user?.website?.isNotEmpty ?? false)
            const SizedBox(height: 20),
          if (shopController.shop?.email.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/email.svg',
              'Email',
              shopController.shop!.email,
              9,
              () async {
                final Uri uri =
                    Uri.parse('mailto:${shopController.shop!.email}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (shopController.shop?.email.isNotEmpty ?? false) _buildDivider(),
          if (shopController.shop?.email.isNotEmpty ?? false)
            const SizedBox(height: 20),
          if (shopController.shop?.phone.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/phone.svg',
              'Phone',
              shopController.shop!.phone,
              11,
              () async {
                final Uri uri = Uri.parse('tel:${shopController.shop!.phone}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildContactRow(String iconPath, String label, String? value,
      double height, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              height: height,
            ),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Text(
            value!,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor.withAlpha(200),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(color: Colors.black12, height: 0.5);
  }
}
