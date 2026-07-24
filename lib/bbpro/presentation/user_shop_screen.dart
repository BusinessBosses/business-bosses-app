// ignore_for_file: empty_catches

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/bizcentersearch.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/expandedcustomitemscreen.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_item_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/impact/presentation/verify_business_screen.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/presentation/leaderboard_screen.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class UserShopScreen extends StatefulWidget {
  final UserModel? user;
  final bool? ismyshop;
  const UserShopScreen({super.key, this.user, this.ismyshop});

  @override
  State<UserShopScreen> createState() => _UserShopScreenState();
}

class _UserShopScreenState extends State<UserShopScreen> {
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();
  late final ReachController reachController;

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

  bool loading = true;
  @override
  void initState() {
    super.initState();
    reachController = Get.put(ReachController(), tag: widget.user!.uid);
    loadData();
  }

  void loadData() async {
    setState(() {
      loading = true;
    });
    await shopController.initUserShop(widget.user!).then((bool value) {
      setState(() {
        loading = false;
      });
    });
    reachController.loadShopData(shopController.userShop!.id);
    _loadReferralReward();
  }

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void _shareBizCenter() {
    String message =
        'Have a look at ${shopController.userShop!.user?.username}\'s BizCenter on Business Bosses\n'
        'https://bizcenter.ai/${shopController.userShop!.name.toLowerCase().replaceAll(' ', '-')}';
    socialShare(message);
  }

  /// This shop's active referral reward (coins per successful referral), 0 if none.
  int _referralReward = 0;

  Future<void> _loadReferralReward() async {
    try {
      final String? sid = shopController.userShop?.id;
      if (sid == null) return;
      final ApiResponseModel res =
          await ApiService.get(path: 'shop-referral/$sid');
      if (res.success == true &&
          res.data != null &&
          res.data['active'] == true) {
        final int coins =
            int.tryParse('${res.data['coinsPerReferral'] ?? 0}') ?? 0;
        if (mounted) setState(() => _referralReward = coins);
      }
    } catch (_) {
      // no banner if the reward can't be loaded
    }
  }

  void _shareReferral() {
    final String? shopName = shopController.userShop?.name;
    if (shopName == null) return;
    final String message =
        'Shop at $shopName on Business Bosses!\n'
        'https://bizcenter.ai/${shopName.toLowerCase().replaceAll(' ', '-')}\n'
        'Sign up with my invite ID ${profileController.myProfile.inviteId} and shop here — we both earn coins!';
    socialShare(message);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildActionButtons(List<Map<String, String>> actions) {
      return actions.map((Map<String, String> action) {
        return GestureDetector(
          onTap: () {
            if (action['text'] == 'Chat') {
              Get.to(
                () => const ChatRoomScreen(
                  frommarketplace: false,
                ),
                arguments: shopController.userShop!.user,
              );
            } else if (action['text'] == 'Search') {
              Get.to(() => const BizCenterSearch());
            } else if (action['text'] == 'Share') {
              _shareBizCenter();
            } else if (action['text'] == 'Follow' ||
                action['text'] == 'Following') {
              Future<void> connectToUser() async {
                final int checkConnected =
                    profileController.myProfile.connecteds == null
                        ? -1
                        : profileController.myProfile.connecteds!.indexWhere(
                            (String element) => element == widget.user!.uid);

                if (checkConnected == -1) {
                  // Add connection
                  profileController.updateConnections(widget.user!.uid);
                  // setState(() {
                  //   _user = UserModel.fromMap(<dynamic, dynamic>{
                  //     ...widget.user!.toMap(),
                  //     'connectionCount':
                  //         (widget.user!.connectionCount ?? 0) + 1,
                  //   });
                  // });
                  await connect(widget.user!.uid);
                } else {
                  // Remove connection
                  profileController.updateConnections(widget.user!.uid);
                  // setState(() {
                  //   _user = UserModel.fromMap(<dynamic, dynamic>{
                  //     ...widget.user!.toMap(),
                  //     'connectionCount':
                  //         (widget.user!.connectionCount ?? 1) - 1,
                  //   });
                  // });
                  await disconnect(widget.user!.uid);
                }
              }

              // Call the function
              connectToUser();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: backgroundColor,
                  child: SvgPicture.asset(
                    action['icon']!,
                    height: 23,
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
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                ),
              ),
              title: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.publicProfile, arguments: widget.user);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '@${widget.user!.username.toLowerCase()}',
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 3,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 10,
                              color: textColor,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: textColor,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: loading
          ? const SafetyModel()
          : shopController.userShop == null
              ? const SafetyModel(
                  isLoading: false,
                  title: 'Coming Soon',
                  icon: Icon(Icons.shopping_bag),
                )
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
                                    if (widget.ismyshop == true &&
                                        shopController
                                                .userShop!.verificationStatus !=
                                            'approved')
                                      _buildVerificationBanner(),
                                    // const SizedBox(
                                    //   height: 10.0,
                                    // ),
                                    if (shopController.userShop!.imageType ==
                                        'circle')
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            // ignore: always_specify_types
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ImagesViewerScreen(
                                                // ignore: always_specify_types
                                                urls: [
                                                  shopController
                                                          .userShop!.image ??
                                                      ''
                                                ],
                                                index: 0,
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
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
                                                child:
                                                    NetworkImageWithPlaceHolder(
                                                  imageUrl: shopController
                                                          .userShop!.image ??
                                                      '',
                                                  radius: radius,
                                                  placeHolder: Icons.person,
                                                  iconSize: 50.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (shopController.userShop!.imageType ==
                                        'banner')
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  ImagesViewerScreen(
                                                urls: <String>[
                                                  shopController
                                                          .userShop?.image ??
                                                      ''
                                                ],
                                                index: 0,
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRect(
                                          child: Align(
                                            alignment: Alignment
                                                .topCenter, // Ensures the top part is visible
                                            heightFactor:
                                                0.7, // Clips the height to 30%
                                            child: SizedBox(
                                              width: double
                                                  .infinity, // Stretches the image to full width
                                              child: ClipRRect(
                                                child:
                                                    NetworkImageWithPlaceHolder(
                                                  imageUrl: shopController
                                                          .userShop?.image ??
                                                      '',
                                                  radius: 0,
                                                  placeHolder: Icons.person,
                                                  iconSize: 50.0,
                                                  fit: BoxFit
                                                      .cover, // Ensures the image fills the width properly
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  shopController.userShop!.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                              if (shopController.userShop!
                                                      .verificationStatus ==
                                                  'approved')
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                )
                                              else if (widget.ismyshop == true)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: InkWell(
                                                    onTap: () => Get.to(() =>
                                                        VerifyBusinessScreen(
                                                          shop: shopController
                                                              .userShop,
                                                        )),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: primaryColorLT
                                                            .withValues(
                                                                alpha: 0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                primaryColorLT,
                                                            width: 0.5),
                                                      ),
                                                      child: const Text(
                                                        'Get Verified',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: primaryColorLT,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Obx(
                                            () => reachController.loading.value
                                                ? const SizedBox(
                                                    height: 12,
                                                    width: 12,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : reachController.shopData?[
                                                                'industryRank']
                                                            ['industryRank'] !=
                                                        null
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              const LeaderboardScreen());
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            const Icon(
                                                                Icons
                                                                    .leaderboard,
                                                                size: 16,
                                                                color: Colors
                                                                    .green),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              '#${reachController.shopData?['industryRank']['industryRank'] ?? "0"} in ${(shopController.userShop?.category ?? "Health")}',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 0,
                                                            ),
                                                            Icon(
                                                              LucideIcons
                                                                  .chevronRight,
                                                              size: 18,
                                                              color: textColor,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                                          ),
                                          const SizedBox(height: 2),
                                          DetectableText(
                                            text: shopController
                                                .userShop!.description,
                                            detectionRegExp: detectionRegExp(
                                                hashtag: false)!,
                                            detectedStyle: bodyText2.copyWith(
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                            moreStyle: bodyText2.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            lessStyle: bodyText2.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            trimLength: 100,
                                            trimExpandedText: '  show less',
                                            basicStyle: bodyText2.copyWith(
                                                fontSize: 12, color: textColor),
                                            onTap: (String text) async {
                                              final Uri url = Uri.parse(text);
                                              if ((url.scheme == 'http' ||
                                                  url.scheme == 'https')) {
                                                if (!await launchUrl(url)) {
                                                  throw Exception(
                                                      'Could not launch $url');
                                                }
                                              } else if (text
                                                  .startsWith('wa.me')) {
                                                final Uri whatsappUrl =
                                                    Uri.parse('https://$text');
                                                if (await launchUrl(
                                                    whatsappUrl)) {
                                                  await launchUrl(whatsappUrl);
                                                } else {
                                                  throw Exception(
                                                      'Could not launch $whatsappUrl');
                                                }
                                              }
                                            },
                                          ),
                                          if (_referralReward > 0 &&
                                              widget.ismyshop != true)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                        'assets/svgs/coin.svg',
                                                        height: 26,
                                                        width: 26),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Refer & earn ${CurrencyFormatter.formatCoins(_referralReward)} coins',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                            'Invite a friend with your invite ID — when they buy here you earn ${CurrencyFormatter.coinEquivalent(_referralReward)}',
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    GestureDetector(
                                                      onTap: _shareReferral,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 14,
                                                                vertical: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: const Text(
                                                          'Refer',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  const Icon(Icons.location_on,
                                                      color: Colors.red,
                                                      size: 15),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    shopController
                                                                .userShop!
                                                                .location
                                                                .length >
                                                            15
                                                        ? '${shopController.userShop!.location.substring(0, 15)}...'
                                                        : shopController
                                                            .userShop!.location,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 13),
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
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    SellerReviewScreen(
                                                      user: widget.user!,
                                                      refreshCallback: loadData,
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    const Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      shopController
                                                              .userShop!
                                                              .user
                                                              ?.averageRating
                                                              ?.toStringAsFixed(
                                                                  1) ??
                                                          '0.0',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: buildActionButtons(<Map<
                                                String, String>>[
                                              <String, String>{
                                                'icon':
                                                    'assets/svgs/shopchat.svg',
                                                'text': 'Chat'
                                              },
                                              // <String, String>{
                                              //   'icon':
                                              //       'assets/svgs/homesearch.svg',
                                              //   'text': 'Search'
                                              // },
                                              <String, String>{
                                                'icon':
                                                    'assets/svgs/shopshare.svg',
                                                'text': 'Share'
                                              },
                                              <String, String>{
                                                'icon': profileController
                                                                .myProfile
                                                                .connecteds !=
                                                            null &&
                                                        profileController
                                                            .myProfile
                                                            .connecteds!
                                                            .contains(widget
                                                                .user!.uid)
                                                    ? 'assets/svgs/following.svg'
                                                    : 'assets/svgs/addclient.svg',
                                                'text': profileController
                                                                .myProfile
                                                                .connecteds !=
                                                            null &&
                                                        profileController
                                                            .myProfile
                                                            .connecteds!
                                                            .contains(widget
                                                                .user!.uid)
                                                    ? 'Following'
                                                    : 'Follow',
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
                                      Tab(text: 'Showcase'),
                                      Tab(text: 'Reviews'),
                                      Tab(text: 'Contact'),
                                    ]),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[],
                                            ),
                                          ),
                                          if ((shopController
                                              .userItems.isEmpty)) ...<Widget>{
                                            const SafetyModel(
                                              isLoading: false,
                                              title: 'No Items In Shop!',
                                            )
                                          } else
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 15.0,
                                                      ),
                                                      child:
                                                          MasonryGridView.count(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 15,
                                                                bottom: 100),
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 10.0,
                                                        crossAxisSpacing: 10.0,
                                                        itemCount:
                                                            shopController
                                                                .userItems
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final Object item =
                                                              shopController
                                                                      .userItems[
                                                                  index];
                                                          if (item is Product) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Get.to(() =>
                                                                    OrderProductScreen(
                                                                      product:
                                                                          item,
                                                                      shop: shopController
                                                                          .userShop!,
                                                                    ));
                                                              },
                                                              child:
                                                                  InventoryCard(
                                                                product: item,
                                                                shop: shopController
                                                                    .userShop!,
                                                                myShop: false,
                                                              ),
                                                            );
                                                          } else if (item
                                                              is Service) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Get.to(() =>
                                                                    BookServiceScreen(
                                                                      service:
                                                                          item,
                                                                      shop: shopController
                                                                          .userShop!,
                                                                    ));
                                                              },
                                                              child:
                                                                  ServiceCard(
                                                                shop: shopController
                                                                    .userShop!,
                                                                myShop: false,
                                                                service: item,
                                                              ),
                                                            );
                                                          } else if (item
                                                              is Customitem) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                if (item.link ==
                                                                        null ||
                                                                    item.link!
                                                                        .isEmpty) {
                                                                  Get.to(() =>
                                                                      ExpandedCustomItemScreen(
                                                                        customitem:
                                                                            item,
                                                                      ));
                                                                } else {
                                                                  final Uri
                                                                      url =
                                                                      Uri.parse(
                                                                          item.link!);
                                                                  if (await canLaunchUrl(
                                                                      url)) {
                                                                    await launchUrl(
                                                                        url,
                                                                        mode: LaunchMode
                                                                            .externalApplication);
                                                                  } else {
                                                                    throw Exception(
                                                                        'Could not launch $url');
                                                                  }
                                                                }
                                                              },
                                                              child:
                                                                  CustomItemCard(
                                                                myShop: true,
                                                                customitem:
                                                                    item,
                                                              ),
                                                            );
                                                          } else {
                                                            return const SizedBox
                                                                .shrink();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),

                                      ///Tab 2 Content
                                      SellerReviewScreen(
                                        isShop: true,
                                        user: widget.user!,
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
          _buildContactRow(
            'assets/svgs/website.svg',
            'Virtual Address',
            '${shopController.userShop!.appId} Biz-Center,\nBusiness Bosses, ${shopController.userShop!.location}',
            12,
            () async {
              await Clipboard.setData(
                ClipboardData(
                  text:
                      '${shopController.userShop!.appId} Biz-Center, Business Bosses, ${shopController.userShop!.location}',
                ),
              );

              // Show toast
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Virtual Address copied to clipboard'),
                  ),
                );
              }
            },
          ),
          _buildDivider(),
          if (shopController.userShop?.user?.website?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.userShop?.email?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.userShop?.email?.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/email.svg',
              'Email',
              shopController.userShop!.email,
              9,
              () async {
                await Clipboard.setData(
                  ClipboardData(text: shopController.userShop!.email!),
                );

                // Show toast
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(content: Text('Email copied to clipboard')),
                );
                final Uri uri =
                    Uri.parse('mailto:${shopController.userShop!.email}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          if (shopController.userShop?.email?.isNotEmpty ?? false)
            _buildDivider(),
          if (shopController.userShop?.email?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          if (shopController.userShop?.phone?.isNotEmpty ?? false)
            _buildContactRow(
              'assets/svgs/phone.svg',
              'Phone',
              shopController.userShop!.phone,
              11,
              () async {
                // Copy to clipboard
                await Clipboard.setData(
                  ClipboardData(text: shopController.userShop!.phone!),
                );

                // Show toast
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(
                      content: Text('Phone number copied to clipboard')),
                );

                final Uri uri =
                    Uri.parse('tel:${shopController.userShop!.phone}');

                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
          if (shopController.userShop!.facebook != null ||
              shopController.userShop!.twitter != null ||
              shopController.userShop!.linkedIn != null ||
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
                    if (shopController.userShop!.linkedIn != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.linkedIn;
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
                                child: SvgPicture.asset(
                                  'assets/svgs/lsl.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    if (shopController.userShop!.url != null) ...<Widget>{
                      GestureDetector(
                        onTap: () async {
                          String? website = shopController.userShop!.url;
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
                                child: SvgPicture.asset(
                                  'assets/svgs/url.svg',
                                ),
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

  Widget _buildVerificationBanner() {
    final String status = shopController.userShop!.verificationStatus;

    String message =
        'Get your Biz-Center verified to build trust and increase reach.';
    if (status == 'pending') {
      message = 'Biz-Center verification is pending review.';
    } else if (status == 'rejected') {
      message = 'Verification rejected. Tap to update documents.';
    }

    return GestureDetector(
      onTap: () => Get.to(() => const VerifyBusinessScreen()),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: status == 'rejected'
              ? Colors.red.withValues(alpha: 0.1)
              : primaryColorLT.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status == 'rejected'
                ? Colors.red.withValues(alpha: 0.3)
                : primaryColorLT.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              status == 'pending' ? Icons.hourglass_top : Icons.verified_user,
              color: status == 'rejected' ? Colors.red : primaryColorLT,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    status == 'rejected'
                        ? 'Action Required'
                        : 'Get Verified Badge',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: status == 'rejected' ? Colors.red : primaryColorLT,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
