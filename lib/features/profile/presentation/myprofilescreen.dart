import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
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
  final MarketController marketController = Get.put(MarketController());

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
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: NestedScrollView(
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
                      length: marketController.markets
                              .where((MarketModel market) =>
                                  market.userId ==
                                  profileController.myProfile.uid)
                              .isEmpty
                          ? 2
                          : 3,
                      child: Column(
                        children: [
                          // if (_publicUser.uid !=
                          //     'FirebaseAuth.instance.currentUser.uid') ...{
                          OutlineButtonHeader(
                              context, profileController.myProfile),
                          const SizedBox(height: 15.0),
                          // },

                          const SizedBox(
                            width: double.infinity,
                            height: 1.5,
                            child: ColoredBox(color: backgroundcolorinterface),
                          ),
                          Material(
                            color: const Color(0xFFF9F9F9),
                            child: TabBar(
                              indicatorColor:
                                  primaryColorLT, // Replace primaryColorLT with the desired color
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              labelColor: Colors.black,
                              tabs: marketController.markets
                                      .where((MarketModel market) =>
                                          market.userId ==
                                          profileController.myProfile.uid)
                                      .isEmpty
                                  ? [
                                      const Tab(
                                        text: 'About',
                                      ),
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                    ]
                                  : [
                                      const Tab(
                                        text: 'About',
                                      ),
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                      const Tab(
                                        text: 'Shop',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                if (marketController.markets
                                    .where((MarketModel market) =>
                                        market.userId !=
                                        profileController.myProfile.uid)
                                    .isNotEmpty)
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        GetBuilder<MarketController>(
                                          builder: (MarketController
                                              marketController) {
                                            return Obx(() {
                                              if (marketController
                                                  .loading.value) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (marketController
                                                  .error.value) {
                                                return const SafetyModel(
                                                  isLoading: false,
                                                  title:
                                                      'Error While Loading Data',
                                                  subTitle:
                                                      'Try Reloading Again',
                                                  icon: Icon(
                                                    Icons.warning,
                                                    size: 60,
                                                  ),
                                                );
                                              } else {
                                                return marketController.markets
                                                        .where((MarketModel
                                                                market) =>
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
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: marketController
                                                            .markets
                                                            .where((MarketModel
                                                                    market) =>
                                                                market.userId ==
                                                                profileController
                                                                    .myProfile
                                                                    .uid)
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final List<
                                                                  MarketModel>
                                                              filteredMarkets =
                                                              marketController
                                                                  .markets
                                                                  .where((MarketModel
                                                                          market) =>
                                                                      market
                                                                          .userId ==
                                                                      profileController
                                                                          .myProfile
                                                                          .uid)
                                                                  .toList();
                                                          final MarketModel
                                                              market =
                                                              filteredMarkets[
                                                                  index];

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
                ),
                BottomBar(
                  activeIndex: 3,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
