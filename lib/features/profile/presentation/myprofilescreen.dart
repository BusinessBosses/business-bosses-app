import 'package:business_bosses_v2/features/marketplace/presentation/seller_reviews.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../../navigation/routes.dart';
import '../../marketplace/controllers/market_controller.dart';
import '../../marketplace/models/market_model.dart';
import '../../marketplace/widgets/marketplace_item.dart';
import '../widgets/my_profile_header.dart';

bool isExpanded = false;

// ignore: public_member_api_docs
class MyProfileScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/my-profile-screen';

  // ignore: public_member_api_docs
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool isLoading = true;
  List<PostModel> _posts = [];

  final ProfileController profileController = Get.find();

  Future<void> loadData(String uid) async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> res =
        await ProfileController.loadData(prefs.getString(Constants.USER_ID)!);

    _posts = res['posts'];

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData(profileController.myProfile.uid);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return GetBuilder<ProfileController>(
      builder: (ProfileController profileController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('@${profileController.myProfile.username}'),
            actions: [
              IconButton(
                  icon: SvgPicture.asset(
                    'assets/svgs/settings.svg',
                    height: 24.0,
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/settingsScreen');
                    Get.toNamed(Routes.settings);
                  })
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverStickyHeader(
                  sticky: false,
                  header: MyProfileHeader(
                    myProfile: profileController.myProfile,
                  ),
                )
              ];
            },
            body: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  // if (_publicUser.uid !=
                  //     'FirebaseAuth.instance.currentUser.uid') ...{
                  OutlineButtonHeader(context, profileController.myProfile),
                  // const SizedBox(height: 8.0),
                  // },

                  Material(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: primaryColorLT,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      labelColor: Colors.black,
                      tabs: [
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/svgs/portfolio.svg',
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/svgs/posts.svg',
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/svgs/market.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 1.5,
                    child: ColoredBox(color: backgroundcolorinterface),
                  ), // Container(

                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              profileinfodisplay(
                                  context, profileController.myProfile),
                            ],
                          ),
                        ),
                        profilepostsdisplay(
                          context,
                          profileController.myProfile,
                          _posts,
                          loading: isLoading,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    height: 100,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.asset(
                                            'assets/images/sellerbackground.jpg'),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 11, top: 11),
                                        child: const Text(
                                          'Store',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(11.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                  top: 8,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: const Color.fromRGBO(
                                                    128, 128, 128, 1),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/svgs/star.svg'),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text:
                                                              profileController
                                                                  .myProfile
                                                                  .averageRating
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => SellerReviewScreen(
                                              user:
                                                  profileController.myProfile));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 8,
                                              top: 8,
                                              left: 20,
                                              right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            color: const Color.fromRGBO(
                                                128, 128, 128, 1),
                                          ),
                                          child: Row(
                                            children: [
                                              RichText(
                                                text: const TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text:
                                                          'See Seller Reviews',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => SellerReviewScreen(
                                                    user: profileController
                                                        .myProfile));
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8,
                                                    top: 8,
                                                    left: 20,
                                                    right: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200),
                                                  color: const Color.fromRGBO(
                                                      128, 128, 128, 1),
                                                ),
                                                child: Row(
                                                  children: [
                                                    RichText(
                                                      text: const TextSpan(
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text:
                                                                'See Seller Reviews',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    const Text(
                                                      '>',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              const Text(
                                                '>',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GetBuilder<MarketController>(
                                builder: (MarketController marketController) {
                                  return Obx(() {
                                    if (marketController.loading.value) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (marketController.error.value) {
                                      return const SafetyModel(
                                        isLoading: false,
                                        title: 'Error While Loading Data',
                                        subTitle: 'Try Reloading Again',
                                        icon: Icon(
                                          Icons.warning,
                                          size: 60,
                                        ),
                                      );
                                    } else {
                                      return marketController.markets
                                              .where((MarketModel market) =>
                                                  market.userId ==
                                                  profileController
                                                      .myProfile.uid)
                                              .isEmpty
                                          ? const SafetyModel(
                                              isLoading: false,
                                              icon: Icon(
                                                Icons.warning,
                                                color: Colors.grey,
                                                size: 80.0,
                                              ),
                                              title:
                                                  'This user has no items in store',
                                              // subTitle: '',
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: marketController
                                                  .markets
                                                  .where((MarketModel market) =>
                                                      market.userId ==
                                                      profileController
                                                          .myProfile.uid)
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final List<MarketModel>
                                                    filteredMarkets =
                                                    marketController.markets
                                                        .where((MarketModel
                                                                market) =>
                                                            market.userId ==
                                                            profileController
                                                                .myProfile.uid)
                                                        .toList();
                                                final MarketModel market =
                                                    filteredMarkets[index];

                                                return MarketTile(
                                                  post: market,
                                                );
                                              },
                                            );
                                    }
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
