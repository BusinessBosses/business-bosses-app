import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/userpost_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../action/action.dart';
import '../../common/widgets/safety_model.dart';
import '../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../functions/my_native_functions.dart';
import '../../navigation/routes.dart';
import 'my_profile_header.dart';

bool isExpanded = false;

class MyProfileScreen extends StatefulWidget {
  static const String routeName = '/my-profile-screen';

  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController _profileController = Get.find();
  List<String> achievements = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    setState(() {
      achievements.insert(0, nameController.text);
      msgCount.insert(0, 0);
    });
  }

  bool _isInit = false;
  bool _isLoading = false;
  int activeIndex = 0;

  late UserModel _user;

  double headHeight = 440.0;
  dynamic myDataStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _onUrlLaunch(context, String url) async {
    try {
      await MyNativeFunctions.onUrlLaunch(url);
    } catch (e) {
      showSnackBar(context, message: e.toString());
      debugPrint('_MyProfileScreenState.onUrlLaunch catch: e: $e');
    }
  }

  Widget _buildChoiceChips(String data) {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data == null ? 0 : data.split("+").length,
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                backgroundColor: backgroundcolorinterface,
                avatar: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 5,
                ),
                label: Text(
                  data.split('+')[index],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(_profileController.myProfile.username),
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
                  header:
                      MyProfileHeader(myProfile: _profileController.myProfile),
                ),
              ];
            },
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  OutlineButtonHeader(context),
                  const SizedBox(height: 8.0),

                  TabBar(
                    labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                    labelColor: Colors.black,
                    indicatorColor: primaryColorLT,
                    tabs: [
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/svgs/portfolio.svg',
                          height: 20.0,
                        ),
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/svgs/posts.svg',
                          height: 20.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 1.5,
                    child: ColoredBox(color: backgroundcolorinterface),
                  ),
                  // Container(

                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                            // children: Consumer<MyPosts>(
                            //   builder: (context, p, _) => p.posts.isEmpty
                            //       ?  const SafetyModel(
                            //           isLoading: false,
                            //           icon: Icon(
                            //             Icons.edit,
                            //             size: 80.0,
                            //             color: Colors.grey,
                            //           ),
                            //           title: 'You\'ve no post',
                            //           subTitle: 'Create a post to view here',
                            //           clickableText: 'Create post',
                            //           // onTab: () => navigateTo(
                            //           //   context,
                            //           //   routeName: CreatePostScreen.routeName,
                            //           // ),
                            //         )
                            //       : Container(
                            //           height: double.infinity,
                            //           width: double.infinity,
                            //           color: backgroundcolorinterface,
                            //           child: GridView.builder(
                            //             gridDelegate:
                            //                 const SliverGridDelegateWithFixedCrossAxisCount(
                            //               crossAxisCount: 2,
                            //               mainAxisSpacing: 5,
                            //               crossAxisSpacing: 5,
                            //             ),
                            //             padding: const EdgeInsets.only(
                            //                 top: 10.0,
                            //                 bottom: 120,
                            //                 left: 10,
                            //                 right: 10),
                            //             itemCount: p.posts.length,
                            //             itemBuilder: (context, i) {
                            //               return PostGridItem(
                            //                 post: p.posts[i],
                            //                 key: ValueKey(p.posts[i].postId),
                            //                 onDeletePost: _onDeletePost,
                            //                 onTap: () => _onPostTap(p.posts[i]),
                            //               );
                            //             },
                            //           ),
                            //         ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[]),
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
