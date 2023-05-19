import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/widgets/profileinfodisplay.dart';
import 'package:business_bosses_v2/features/profile/widgets/profilepostsdisplay.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../controller/profile_controller.dart';
import '../widgets/friendoutlinebuttonheader.dart';
import '../widgets/friendprofileheader.dart';

// ignore: public_member_api_docs
class PublicProfileScreen extends StatefulWidget {
  static const String routeName = '/public-profile-screen';

  // ignore: public_member_api_docs
  PublicProfileScreen({Key? key}) : super(key: key);

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final ProfileController _profileController = Get.find();
  List<PostModel> _posts = [];
  late UserModel publicUser;
  bool isLoading = true;
  bool blocked = false;

  bool hasUser = true;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    final res = await ProfileController.loadData(publicUser.uid);

    _posts = res;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> report(
      BuildContext context, String type, String publicUserUid) async {}

  Future<void> connect(String userId) async {
    final res = await ApiService.post(path: '/connection/connect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  Future<void> disconnect(String userId) async {
    final res = await ApiService.post(path: '/connection/disconnect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  void connectToUser() async {
    final checkConnected = _profileController.myProfile.connecteds == null
        ? -1
        : _profileController.myProfile.connecteds!
            .indexWhere((element) => element == publicUser.uid);
    if (checkConnected == -1) {
      // connecteds.add(user);
      _profileController.updateConnections(publicUser.uid);
      setState(() {
        publicUser = UserModel.fromMap({
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? 1
              : publicUser.connectionCount! + 1
        });
      });
      await connect(publicUser.uid);
    } else {
      _profileController.updateConnections(publicUser.uid);

      setState(() {
        publicUser = UserModel.fromMap({
          ...publicUser.toMap(),
          'connectionCount': publicUser.connectionCount == null
              ? null
              : publicUser.connectionCount! - 1
        });
      });
      // connecteds.removeAt(checkConnected);
      await disconnect(publicUser.uid);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      // print("back");
      Get.back();
    } else {
      // print("yo");

      publicUser = Get.arguments;
      // print(publicUser.username);
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text(publicUser.username),
        actions: [
          publicUser.uid != _profileController.myProfile.uid
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    navigateTo(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const TextWidget(
                                          text: 'Do you want to block user?',
                                          centralize: true,
                                          fontWeight: FontWeight.w700,
                                          size: 20,
                                        ),
                                        content: TextWidget(
                                          text: blocked == true
                                              ? 'You will see posts and comments related to user on your feed'
                                              : 'You will no longer see undefined posts and comments on your feed',
                                          centralize: true,
                                          color: Colors.black.withOpacity(.6),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                navigateTo(context),
                                            child: const TextWidget(
                                              text: 'Cancel',
                                              fontWeight: FontWeight.w700,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              navigateTo(context);
                                              // print(_post.user.uid);

                                              // widget
                                              //     .onBlock(_post.user.uid);
                                              showSnackBar(context,
                                                  message: blocked == true
                                                      ? 'User has been blocked'
                                                      : 'User has been unblocked');
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 7,
                                                horizontal: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primaryColorLT,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: TextWidget(
                                                text: blocked == true
                                                    ? 'Unblock'
                                                    : 'Block',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: TextWidget(
                                    text: blocked == true
                                        ? 'Unblock @${publicUser.name}'
                                        : 'Block @${publicUser.name}',
                                    color: Colors.blue,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    navigateTo(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const TextWidget(
                                          text: 'Do you want to report user?',
                                          centralize: true,
                                          fontWeight: FontWeight.w700,
                                          size: 20,
                                        ),
                                        content: TextWidget(
                                          text:
                                              'The user will be reported to admin to evaluate if it violates any community policy',
                                          centralize: true,
                                          color: Colors.black.withOpacity(.6),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                navigateTo(context),
                                            child: const TextWidget(
                                              text: 'Cancel',
                                              fontWeight: FontWeight.w700,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              navigateTo(context);
                                              await report(
                                                context,
                                                'accountReport',
                                                publicUser.uid,
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 7,
                                                horizontal: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primaryColorLT,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const TextWidget(
                                                text: 'Report',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: const TextWidget(
                                    text: 'Report this user',
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );

                        // _showMorePostOptions(context, "accountReport",
                        //     _publicUser?.uid.toString(), "Report this User.");
                      },
                      child: SvgPicture.asset('assets/svgs/more.svg')),
                )
              : Container()
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverStickyHeader(
              sticky: false,
              header: FriendProfileHeader(publicUser),
            )
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // if (_publicUser.uid !=
              //     'FirebaseAuth.instance.currentUser.uid') ...{
              OutlineButtonHeader(
                  publicUser, _profileController.myProfile, connectToUser),
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
                          profileinfodisplay(context, publicUser),
                        ],
                      ),
                    ),
                    // Container()
                    profilepostsdisplay(
                      context,
                      publicUser,
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
    );
  }
}
