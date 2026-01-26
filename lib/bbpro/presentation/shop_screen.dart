// ignore_for_file: empty_catches

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_custom_listing.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_item_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  final bool? isPro;
  const ShopScreen({super.key, this.isPro});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();

  late final Map<String, dynamic> dataMap = profileController.impact is Map
      ? profileController.impact
      : <String, dynamic>{};
  late final double profileScore = (dataMap['profileReach'] ?? 10).toDouble();
  late final double engagementScore =
      (dataMap['engagementReach'] ?? 30).toDouble();
  late final double discoveryScore =
      (dataMap['discoveryReach'] ?? 20).toDouble();
  late final double trustScore = (dataMap['trustReach'] ?? 20).toDouble();

  late final int totalLikes = profileController.impact['totalLikes'] ?? 0;
  late final int totalViews = profileController.impact['totalViews'] ?? 0;

  late final int totalReachScore = (totalLikes +
          totalViews +
          profileScore +
          engagementScore +
          discoveryScore +
          trustScore)
      .toInt();

  void showbottomsheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return ListTile(
                  subtitle: const Text(
                      'To showcase your products in biz-center & marketplace'),
                  leading: SvgPicture.asset(
                    'assets/svgs/addproduct.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    height: 24,
                  ),
                  title: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  horizontalTitleGap: 20.0,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CreateProductListing());
                  },
                );
              } else if (index == 1) {
                return ListTile(
                  subtitle: const Text(
                      'To showcase your services in biz-center & marketplace'),
                  leading: SvgPicture.asset(
                    'assets/svgs/addservice.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    height: 24,
                  ),
                  title: const Text(
                    'Add Service',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  horizontalTitleGap: 20.0,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CreateServiceListing());
                  },
                );
              } else {
                return ListTile(
                  leading: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                  subtitle: const Text(
                      'To showcase your portfolio, demo or affiliate links '),
                  title: const Text(
                    'Add Custom Item',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  horizontalTitleGap: 20.0,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CreateCustomListing());
                  },
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: 3,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isPro == null
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              title: const Text(
                'My Biz-Center',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: backgroundColor,
                        child: IconButton(
                            onPressed: () {
                              Get.to(() => Setupshop(
                                    shop: shopController.shop,
                                  ));
                            },
                            icon: SvgPicture.asset(
                              'assets/svgs/editshop.svg',
                              height: 18,
                            )),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: backgroundColor,
                        child: IconButton(
                            onPressed: () {
                              showbottomsheet();
                            },
                            icon: Icon(
                              Icons.add,
                              color: textColor,
                            )),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: backgroundColor,
                        child: IconButton(
                            onPressed: () {
                              _sharePost();
                            },
                            icon: SvgPicture.asset(
                              'assets/svgs/shopshare.svg',
                              height: 20,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverStickyHeader(
                sticky: false,
                header: Column(children: <Widget>[
                  if (widget.isPro != null)
                    const SizedBox(
                      height: 10.0,
                    ),
                  if (shopController.shop!.imageType == 'circle')
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: SizedBox(
                        height: 80.0,
                        width: 80.0,
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
                    ),
                  if (shopController.shop!.imageType == 'banner')
                    ClipRect(
                      child: Align(
                        alignment:
                            Alignment.topCenter, // Keeps the top part visible
                        heightFactor: 0.7, // Shows only 30% of the image height
                        child: SizedBox(
                          width: double.infinity, // Stretches to full width
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                0), // Optional: Adjust corner radius
                            child: NetworkImageWithPlaceHolder(
                              imageUrl: shopController.shop?.image ?? '',
                              radius: 0,
                              placeHolder: Icons.person,
                              iconSize: 22.0,
                              fit: BoxFit.cover, // Ensures it stretches
                            ),
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
                          moreStyle: bodyText2.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: proprimaryColor),
                          lessStyle: bodyText2.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: proprimaryColor),
                          trimLength: 100,
                          trimExpandedText: '  show less',
                          basicStyle: bodyText2.copyWith(
                              color: textColor, fontSize: 12),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 15),
                                // const SizedBox(width: 5),
                                Text(
                                  shopController.shop!.location.length > 15
                                      ? '${shopController.shop!.location.substring(0, 15)}...'
                                      : shopController.shop!.location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const CircleAvatar(
                              radius: 2,
                              backgroundColor: Colors.black87,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    '${shopController.shop!.user?.averageRating!.toStringAsFixed(2)} Reviews',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const CircleAvatar(
                              radius: 2,
                              backgroundColor: Colors.black87,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$totalReachScore Reach',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]))
          ];
        },
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  tabs: <Widget>[
                    Tab(text: 'Showcase'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Contact'),
                  ]),
              const Divider(
                height: 1,
                // thickness: 1,
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    ///Tab 1 Content
                    Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[],
                          ),
                        ),
                        Obx(
                          () => shopController.items.isEmpty
                              ? const SafetyModel(
                                  title: 'Coming Soon',
                                  isLoading: false,
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: MasonryGridView.count(
                                            padding: const EdgeInsets.only(
                                                top: 15, bottom: 100),
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            itemCount:
                                                shopController.items.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final Object item =
                                                  shopController.items[index];
                                              if (item is Product) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        CreateProductListing(
                                                            product: item));
                                                  },
                                                  child: InventoryCard(
                                                    product: item,
                                                    myShop: true,
                                                  ),
                                                );
                                              } else if (item is Service) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        CreateServiceListing(
                                                            service: item));
                                                  },
                                                  child: ServiceCard(
                                                    myShop: true,
                                                    service: item,
                                                  ),
                                                );
                                              } else if (item is Customitem) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        CreateCustomListing(
                                                          customItem: item,
                                                        ));
                                                  },
                                                  child: CustomItemCard(
                                                    myShop: true,
                                                    customitem: item,
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),

                    ///Tab 2 Content
                    SellerReviewScreen(
                        isShop: true, user: profileController.myProfile),

                    ///Tab 3 Content
                    Center(child: _buildContactInfo()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showbottomsheet();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
          // const Text(
          //   'Contact Information',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w700,
          //     fontSize: 18,
          //     color: textColor,
          //   ),
          // ),
          // const SizedBox(height: 20),
          // if (shopController.shop?.user?.virtualAddress?.isNotEmpty ?? false)
          _buildContactRow(
            'assets/svgs/website.svg',
            'Virtual Address',
            '${shopController.shop!.appId} Biz-Center,\nBusiness Bosses, ${shopController.shop!.location}',
            12,
            null,
          ),
          _buildDivider(),
          if (shopController.shop!.appId.isNotEmpty) const SizedBox(height: 10),
          if (shopController.shop?.email?.isNotEmpty ?? false)
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
          if (shopController.shop?.email?.isNotEmpty ?? false) _buildDivider(),
          if (shopController.shop?.email?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.shop?.phone?.isNotEmpty ?? false)
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
          _buildDivider(),

          const SizedBox(height: 10),
          // if (shopController.shop?.user?.location?.isNotEmpty ?? false)
          _buildContactRow(
            'assets/svgs/website.svg',
            'Address',
            shopController.shop!.location,
            12,
            () async {
              final Uri uri =
                  Uri.parse('https://${shopController.shop!.user!.website}');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          if (shopController.shop!.facebook != null ||
              shopController.shop!.twitter != null ||
              shopController.shop!.linkedIn != null ||
              shopController.shop!.instagram != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                const Text(
                  'Social Links',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    if (shopController.shop!.facebook != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.shop!.facebook;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            await launchUrl(uri,
                                mode: LaunchMode.platformDefault,
                                webOnlyWindowName: '_self');
                          } catch (e) {}
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: SvgPicture.asset('assets/svgs/fbsl.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    if (shopController.shop!.twitter != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.shop!.twitter;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            await launchUrl(uri,
                                mode: LaunchMode.platformDefault,
                                webOnlyWindowName: '_self');
                          } catch (e) {}
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: SvgPicture.asset('assets/svgs/xsl.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    if (shopController.shop!.instagram != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.shop!.instagram;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            await launchUrl(uri,
                                mode: LaunchMode.platformDefault,
                                webOnlyWindowName: '_self');
                          } catch (e) {}
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child:
                                    SvgPicture.asset('assets/svgs/insta.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    if (shopController.shop!.linkedIn != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.shop!.linkedIn;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            await launchUrl(uri,
                                mode: LaunchMode.platformDefault,
                                webOnlyWindowName: '_self');
                          } catch (e) {}
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: SvgPicture.asset('assets/svgs/lsl.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    if (shopController.shop!.url != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.shop!.url;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            await launchUrl(uri,
                                mode: LaunchMode.platformDefault,
                                webOnlyWindowName: '_self');
                          } catch (e) {}
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: SvgPicture.asset('assets/svgs/url.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    }
                  ],
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _buildContactRow(String iconPath, String label, String? value,
      double height, Function()? onTap) {
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
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(color: Colors.black12, height: 0.5);
  }

  void _sharePost() {
    String message =
        'Have a look at ${shopController.shop!.user?.username}\'s biz-center on Business Bosses\n'
        'https://biz-center.io/${shopController.shop?.name.toLowerCase().replaceAll(' ', '-')}';
    socialShare(message);
  }
}
