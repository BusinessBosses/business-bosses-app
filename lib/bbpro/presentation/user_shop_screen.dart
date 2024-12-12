import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserShopScreen extends StatefulWidget {
  final UserModel user;
  final bool? ismyshop;
  const UserShopScreen({super.key, required this.user, this.ismyshop});

  @override
  State<UserShopScreen> createState() => _UserShopScreenState();
}

class _UserShopScreenState extends State<UserShopScreen> {
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();
  String _selectedItem = 'All Products';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState(() {
      loading = true;
    });
    shopController.initUserShop(widget.user).then((bool value) {
      if (value) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void _shareBizCenter() {
    String message =
        'Have a look at ${shopController.userShop!.user?.username ?? 'Business Bosses'}\'s BizCenter on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    socialShare(message);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildActionButtons(List<Map<String, String>> actions) {
      return actions.map((Map<String, String> action) {
        return GestureDetector(
          onTap: () {
            if (action['text'] == 'Chat') {
              print('object');
              Get.to(
                () => const ChatRoomScreen(
                  frommarketplace: false,
                ),
                arguments: shopController.userShop!.user,
              );
            } else if (action['text'] == 'Call') {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: shopController.shop!.phone,
              );
              launchUrl(launchUri);
            } else if (action['text'] == 'Share') {
              _shareBizCenter();
            } else if (action['text'] == 'Review') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SellerReviewScreen(
                    user: widget.user,
                    refreshCallback: loadData,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: backgroundColor,
                  child: SvgPicture.asset(
                    action['icon']!,
                    height: 17,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  action['text']!,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.ismyshop != null
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                widget.ismyshop != null
                    ? Container()
                    : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                            onPressed: () {},
                            icon:
                                SvgPicture.asset('assets/svgs/shopshare.svg')),
                      )
              ],
            ),
      body: loading
          ? const SafetyModel()
          : Obx(
              () => shopController.userShop == null
                  ? const SafetyModel(
                      isLoading: false,
                      title: 'No Shop Found For This User!',
                    )
                  : NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverStickyHeader(
                              sticky: false,
                              header: Column(children: <Widget>[
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                Stack(children: <Widget>[
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: SizedBox(
                                      height: 80.0,
                                      width: 80.0,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          child: NetworkImageWithPlaceHolder(
                                            imageUrl: shopController
                                                    .userShop!.image ??
                                                '',
                                            radius: radius,
                                            placeHolder: Icons.person,
                                            iconSize: 22.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(shopController.userShop!.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      const SizedBox(height: 2),
                                      DetectableText(
                                        text: shopController
                                            .userShop!.description,
                                        detectionRegExp:
                                            detectionRegExp(hashtag: false)!,
                                        detectedStyle: bodyText2.copyWith(
                                            color: Colors.blue),
                                        textAlign: TextAlign.center,
                                        moreStyle: bodyText2.copyWith(
                                            color: Colors.black),
                                        lessStyle: bodyText2.copyWith(
                                            color: Colors.black),
                                        trimLength: 40,
                                        trimExpandedText: '  show less',
                                        basicStyle: bodyText2.copyWith(
                                            color: textColor),
                                        onTap: (String text) async {
                                          final Uri url = Uri.parse(text);
                                          if ((url.scheme == 'http' ||
                                              url.scheme == 'https')) {
                                            if (!await launchUrl(url)) {
                                              throw Exception(
                                                  'Could not launch $url');
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              const Icon(Icons.location_on,
                                                  color: Colors.red, size: 15),
                                              // const SizedBox(width: 5),
                                              Text(
                                                shopController.userShop!
                                                            .location.length >
                                                        15
                                                    ? '${shopController.userShop!.location.substring(0, 15)}...'
                                                    : shopController
                                                        .userShop!.location,
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
                                                  color: Colors.amber,
                                                  size: 18),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Text(
                                                  '${shopController.userShop!.user?.averageRating} Reviews',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _buildActionButtons(<Map<
                                            String, String>>[
                                          <String, String>{
                                            'icon': 'assets/svgs/shopchat.svg',
                                            'text': 'Chat'
                                          },
                                          <String, String>{
                                            'icon': 'assets/svgs/shopcall.svg',
                                            'text': 'Call'
                                          },
                                          <String, String>{
                                            'icon': 'assets/svgs/shopshare.svg',
                                            'text': 'Share'
                                          },
                                          <String, String>{
                                            'icon':
                                                'assets/svgs/shopreview.svg',
                                            'text': 'Review'
                                          },
                                        ]),
                                      )
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
                                  Tab(text: 'Listings'),
                                  Tab(text: 'Reviews'),
                                  Tab(text: 'About'),
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Showcase (${shopController.userProducts.length + shopController.userServices.length})',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                final RenderBox button =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final RenderBox overlay =
                                                    Overlay.of(context)
                                                            .context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                final RelativeRect position =
                                                    RelativeRect.fromRect(
                                                  Rect.fromPoints(
                                                    button.localToGlobal(
                                                        button.size.topRight(
                                                            const Offset(
                                                                0, 380)),
                                                        ancestor: overlay),
                                                    button.localToGlobal(
                                                        button.size.bottomRight(
                                                            const Offset(
                                                                0, 20)),
                                                        ancestor: overlay),
                                                  ),
                                                  Offset.zero & overlay.size,
                                                );

                                                showMenu(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
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
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: option,
                                                      child: Text(
                                                        option,
                                                        style: const TextStyle(
                                                            fontSize: 14),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          backgroundColor,
                                                      child: SvgPicture.asset(
                                                          'assets/svgs/filterprosections.svg'),
                                                    ),
                                                    Text(
                                                      _selectedItem,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if ((shopController.userProducts.length +
                                              shopController
                                                  .userServices.length) ==
                                          0) ...<Widget>{
                                        const SafetyModel(
                                          isLoading: false,
                                          title: 'No Items In Shop!',
                                        )
                                      } else
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child:
                                                StaggeredGridView.countBuilder(
                                              crossAxisCount: 2,
                                              staggeredTileBuilder: (int
                                                      index) =>
                                                  const StaggeredTile.fit(1),
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                              itemCount: shopController
                                                      .userProducts
                                                      .where((Product p) =>
                                                          p.isActive)
                                                      .length +
                                                  shopController.userServices
                                                      .where((Service s) =>
                                                          s.isActive)
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final List<Product>
                                                    activeProducts =
                                                    shopController.userProducts
                                                        .where((Product p) =>
                                                            p.isActive)
                                                        .toList();
                                                final List<Service>
                                                    activeServices =
                                                    shopController.userServices
                                                        .where((Service s) =>
                                                            s.isActive)
                                                        .toList();

                                                if (index <
                                                    activeProducts.length) {
                                                  final Product product =
                                                      activeProducts[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          OrderProductScreen(
                                                            product: product,
                                                            shop: shopController
                                                                .userShop!,
                                                          ));
                                                    },
                                                    child: InventoryCard(
                                                      shop: shopController
                                                          .userShop!,
                                                      product: product,
                                                      myShop: false,
                                                    ),
                                                  );
                                                } else {
                                                  final Service service =
                                                      activeServices[index -
                                                          activeProducts
                                                              .length];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          BookServiceScreen(
                                                            service: service,
                                                            shop: shopController
                                                                .userShop!,
                                                          ));
                                                    },
                                                    child: ServiceCard(
                                                      shop: shopController
                                                          .userShop!,
                                                      myShop: false,
                                                      service: service,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  ///Tab 2 Content
                                  SellerReviewScreen(
                                    isShop: true,
                                    user: widget.user,
                                  ),

                                  ///Tab 3 Content
                                  Center(child: _buildContactInfo()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
          const Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactRow(
            'assets/svgs/website.svg',
            'Virtual Address',
            '#${shopController.userShop!.appId}, Biz-Centre, Business Bosses, United Kingdom',
            12,
            null,
          ),
          _buildDivider(),
          if (shopController.userShop?.user?.website?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.userShop?.email.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/email.svg',
              'Email',
              shopController.userShop!.email,
              9,
              () async {
                final Uri uri =
                    Uri.parse('mailto:${shopController.userShop!.email}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (shopController.userShop?.email.isNotEmpty ?? false)
            _buildDivider(),
          if (shopController.userShop?.email.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.userShop?.phone.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/phone.svg',
              'Phone',
              shopController.userShop!.phone,
              11,
              () async {
                final Uri uri =
                    Uri.parse('tel:${shopController.userShop!.phone}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (shopController.userShop!.facebook != null ||
              shopController.userShop!.twitter != null ||
              shopController.userShop!.linkedin != null ||
              shopController.userShop!.facebook != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
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
                    if (shopController.userShop!.facebook != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.facebook;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            final bool launched = await launchUrl(uri,
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
                    if (shopController.userShop!.twitter != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.twitter;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            final bool launched = await launchUrl(uri,
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
                    if (shopController.userShop!.instagram != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.instagram;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            final bool launched = await launchUrl(uri,
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
                    if (shopController.userShop!.linkedin != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.linkedin;
                          try {
                            if (!website!.startsWith('http://') &&
                                !website.startsWith('https://')) {
                              website = 'https://$website';
                            }
                            final Uri uri = Uri.parse(website);
                            final bool launched = await launchUrl(uri,
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
}
