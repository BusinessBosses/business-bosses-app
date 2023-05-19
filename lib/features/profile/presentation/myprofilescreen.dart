import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/widgets/friendprofileheader.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../../navigation/routes.dart';
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
    final res =
        await ProfileController.loadData(prefs.getString(Constants.USER_ID)!);

    _posts = res;

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
      builder: (ProfileController _profileController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('@${_profileController.myProfile.username}'),
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
                    myProfile: _profileController.myProfile,
                  ),
                )
              ];
            },
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // if (_publicUser.uid !=
                  //     'FirebaseAuth.instance.currentUser.uid') ...{
                  OutlineButtonHeader(context, _profileController.myProfile),
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
                        // Container(),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              profileinfodisplay(
                                  context, _profileController.myProfile),
                            ],
                          ),
                        ),
                        // Container()
                        profilepostsdisplay(
                          context,
                          _profileController.myProfile,
                          _posts,
                          loading: isLoading,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // body: NestedScrollView(
          //   headerSliverBuilder:
          //       (BuildContext context, bool innerBoxIsScrolled) {
          //     return <Widget>[
          //       SliverStickyHeader(
          //         sticky: false,
          //         // header: MyProfileHeader(
          //         //   myProfile: _profileController.myProfile,
          //         // ),
          //         header: Container(),
          //       ),
          //     ];
          //   },
          //   body: DefaultTabController(
          //     length: 2,
          //     child: Column(
          //       children: [
          //         OutlineButtonHeader(context, _profileController.myProfile),
          //         const SizedBox(height: 8.0),

          //         TabBar(
          //           labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          //           labelColor: Colors.black,
          //           indicatorColor: primaryColorLT,
          //           tabs: [
          //             Tab(
          //               icon: SvgPicture.asset(
          //                 'assets/svgs/portfolio.svg',
          //                 height: 20.0,
          //               ),
          //             ),
          //             Tab(
          //               icon: SvgPicture.asset(
          //                 'assets/svgs/posts.svg',
          //                 height: 20.0,
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(
          //           width: double.infinity,
          //           height: 1.5,
          //           child: ColoredBox(color: backgroundcolorinterface),
          //         ),
          //         // Container(

          //         Expanded(
          //           child: TabBarView(
          //             children: [
          //               Expanded(
          //                 child: TabBarView(children: [
          //                   SingleChildScrollView(
          //                     child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           const SizedBox(
          //                             height: 30,
          //                           ),
          //                           profileinfodisplay(
          //                               context, _profileController.myProfile),
          //                         ]),
          //                   ),
          //                   profilepostsdisplay(
          //                       context, _profileController.myProfile, [])
          //                 ]),
          //               )
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
