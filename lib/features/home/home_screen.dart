// ignore_for_file: public_member_api_docs, always_specify_types

import 'dart:io';

import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/bottomnavigationscreen.dart';
import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/floatingbutton.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:upgrader/upgrader.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/constants/constants.dart';
import '../../utils/theme/theme.dart';
import '../chat/controllers/chat_controller.dart';
import '../chat/models/my_message.dart';
import '../forum/models/forum_model.dart';
import '../home/controller/home_controller.dart';
import '../home/widgets/home_appbar.dart';
import '../marketplace/controllers/market_controller.dart';
import '../posts/models/post_model.dart';
import '../posts/widgets/userpost_tile.dart';
import '../profile/controller/profile_controller.dart';
import '../profile/widgets/boss_of_the_week_tile.dart';
import 'widgets/forum_item.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onPageChange});

  final Function(int)? onPageChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver {
  final ProfileController _profileController = Get.find();
  final LiveController liveEventController = Get.put(LiveController());
  late IO.Socket socket;
  bool isScrolled = true;
  // List<TargetFocus> targets = [];

  // int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  // final GetStorage sandBox = GetStorage();
  final ScrollController _scrollController = ScrollController();
  final MarketController marketController = Get.put(MarketController());
  final CommunitiesController _communitiesController =
      Get.put(CommunitiesController());
  final BossUpController bossUpController = Get.put(BossUpController());

  // final GlobalKey<NavigatorState> postButtonKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // showTutorial();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tutorialShown = prefs.getString('tutorialShown');
      if (tutorialShown == null || tutorialShown.isEmpty) {
        // showTutorial();
        await prefs.setString('tutorialShown', 'true');
      }
    });
    final HomeController homeController = Get.find();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !homeController.loadingMore.value) {
        homeController.fetchPosts();
      }
    });

    // Function to establish the WebSocket connection
    void connectSocket() {
      socket = IO.io(Constants.socketUrl, <String, dynamic>{
        'transports': ['websocket'],
      });

      socket.onConnect((_) {
        print('Connection established');
      });

      socket.on('newPostEvent', (data) {
        // homeController.sinkPosts(data);
        print(data['newPost']);
        final int postIndex = homeController.mixedPosts.indexWhere(
            (Map<String, dynamic> element) =>
                element['shouldCount'] == null &&
                !element['isForum'] &&
                element['data'].postId == data['newPost']['postId']);
        print("================postIndex $postIndex");
        if (postIndex == -1) {
          homeController.sinkPosts(data);
        }
      });

      socket.onDisconnect((_) {
        print('Connection Disconnection');
        // Reconnect the socket when it's disconnected
        Future.delayed(Duration(seconds: 5), () {
          connectSocket();
        });
      });

      socket.onConnectError((err) {
        print(err);
        // Handle connection errors as needed
      });

      socket.onError((err) {
        print(err);
        // Handle socket errors as needed
      });
    }

    // Initial connection
    connectSocket();

    // targets.add(TargetFocus(
    //     identify: 'Searchtarget',
    //     keyTarget: Homeappbar.searchkey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),

    //               SizedBox(
    //                 height: 200,
    //                 child: Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Row(
    //                     children: [
    //                       Text(
    //                         'Tap higlighted areas to skip',
    //                         style: TextStyle(
    //                             color: Colors.white.withAlpha(150),
    //                             fontSize: 15),
    //                       ),
    //                       const SizedBox(
    //                         width: 10,
    //                       ),
    //                       SvgPicture.asset(
    //                         'assets/svgs/up.svg',
    //                         height: 20,
    //                         color: Colors.white,
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               const Text(
    //                 'Search',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               const Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Find users and posts through the homepage search',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               const Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Find groups and topics through the community search',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //             ],
    //           ))
    //     ]));

    // targets.add(TargetFocus(
    //     identify: 'Notificationtarget',
    //     keyTarget: Homeappbar.notificationkey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.bottom,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               SizedBox(
    //                 height: 200,
    //               ),
    //               Text(
    //                 'Notifications',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Receive Daily motivational quotes',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Receive alerts from your network activities',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));

    // targets.add(TargetFocus(
    //     identify: 'Hometarget',
    //     // keyTarget: BottomNavigationScreen.homekey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Image.asset(
    //               //   'assets/images/test.gif',
    //               //   height: 500.0,
    //               //   width: 500.0,
    //               // ),
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Text(
    //                 'Content Feed',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Engage with content from posts and topics you\'re inrterested in',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Create and post relevant content for an opportunity to get discovered',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));
    // targets.add(TargetFocus(
    //     identify: 'Bossuptarget',
    //     // keyTarget: BottomNavigationScreen.bossupkey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               Text(
    //                 'Community',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Network with new contacts & easily find your industry experts',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Join groups with topics that support your educational & business goals',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Enter Boss Up Challenge for a chance to become \"Boss of the week\"',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));
    // targets.add(TargetFocus(
    //     identify: 'Liveventtarget',
    //     // keyTarget: BottomNavigationScreen.eventskey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               Text(
    //                 'Live Events',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Create live events with description, date, and time.',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Participants can attend, share and save live events.',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));

    // targets.add(TargetFocus(
    //     identify: 'marketplacetarget',
    //     // keyTarget: BottomNavigationScreen.marketplacekey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               Text(
    //                 'Marketplace',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Sell your products and services',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Selling is easy, you can add price, description, photos.',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));

    // targets.add(TargetFocus(
    //     identify: 'Profiletarget',
    //     // keyTarget: BottomNavigationScreen.profilekey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               Text(
    //                 'Profile',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Keep your bio up to date as a virtual business card',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Showcase your products or services to find new opportunities',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ]));

    // targets.add(
    //   TargetFocus(
    //     identify: 'Createbuttontarget',
    //     keyTarget: postButtonKey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.top,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               Text(
    //                 'Create',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Create Posts',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Post polls and surveys to gather feedback and use the feedback to improve your business offerings.',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 200,
    //               )
    //             ],
    //           ))
    //     ],
    //   ),
    // );

    // targets.add(TargetFocus(
    //     identify: 'connecttarget',
    //     keyTarget: connectbuttonkey,
    //     contents: [
    //       TargetContent(
    //           align: ContentAlign.bottom,
    //           child: const Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               // Lottie.asset(
    //               //   'assets/anim/liveevent.json',
    //               //   height: 85,
    //               // ),
    //               SizedBox(
    //                 height: 100,
    //               ),
    //               Text(
    //                 'Networking & Referrals',
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.white,
    //                     fontSize: 25.0),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   '- Get Connected & connections from entrepreneurs around the globe',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Invite contacts for a quick & easy way to grow your network & get free promotion',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- 1 to 1 chat to follow up meaningful conversations',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 5.0),
    //                 child: Text(
    //                   '- Give and receive Business referrals',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w700),
    //                 ),
    //               ),
    //             ],
    //           ))
    //     ]));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final HomeController homeController = Get.find();

    if (state.index == 0) {
      homeController.fetchPosts(fromBackground: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socket.off('newPostEvent'); // Remove the listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            }).then((dynamic exit) {
          if (exit == true) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        });
        return false;
      },
      child: GetBuilder<HomeController>(
        builder: (HomeController controller) {
          return UpgradeAlert(
            child: Scaffold(
              backgroundColor: backgroundcolorinterface,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: GetBuilder<ChatController>(
                    builder: (ChatController chatController) {
                  final List<MessageModel> unseenChats = chatController.chats
                      .where((MessageModel element) =>
                          element.receiverUid ==
                              controller.profileController.myProfile.uid &&
                          !element.seen)
                      .toList();
                  final bool hasBadge = unseenChats.isNotEmpty;
                  return GetBuilder<ProfileController>(
                    builder: (ProfileController profileController) =>
                        Homeappbar(
                      hasBadge: hasBadge,
                      coinsCount:
                          profileController.myProfile.coinscount?.toString() ??
                              '',
                      hasUnreadNotification:
                          profileController.myProfile.unReadCount != null &&
                              profileController.myProfile.unReadCount! > 0,
                    ),
                  );
                }),
              ),
              // floatingActionButton: !controller.loading.value
              //     ? FloatingActionButton(
              //         child: Icon(Icons.add),
              //         shape: CircleBorder(),
              //         onPressed: () {
              //           showModalBottomSheet(
              //               context: context,
              //               shape: const RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.vertical(
              //                   top: Radius.circular(25.0),
              //                 ),
              //               ),
              //               builder: (context) {
              //                 return SizedBox(
              //                   height: 250,
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(15.0),
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: <Widget>[
              //                         Expanded(
              //                           // Set a specific height
              //                           child: ListView.separated(
              //                             itemCount: 3,
              //                             separatorBuilder:
              //                                 (BuildContext context,
              //                                         int index) =>
              //                                     const Divider(),
              //                             itemBuilder: (BuildContext context,
              //                                 int index) {
              //                               return ListTile(
              //                                 onTap: () {
              //                                   Navigator.pop(context);
              //                                   index == 0
              //                                       ? Get.toNamed(
              //                                           Routes.createPost)
              //                                       : index == 1
              //                                           ? sellProduct(context)
              //                                           : Get.toNamed(
              //                                               Routes.createevent);
              //                                 },
              //                                 minVerticalPadding: 0,
              //                                 contentPadding:
              //                                     const EdgeInsets.only(
              //                                         left: 10),
              //                                 leading: SvgPicture.asset(
              //                                   index == 0
              //                                       ? 'assets/svgs/text.svg'
              //                                       : index == 1
              //                                           ? 'assets/svgs/sellicon.svg'
              //                                           : 'assets/svgs/liveevent.svg',
              //                                   height: index == 0
              //                                       ? 25
              //                                       : index == 1
              //                                           ? 30
              //                                           : 22,
              //                                   color: textColor.withOpacity(1),
              //                                 ),
              //                                 title: Text(
              //                                   index == 0
              //                                       ? 'Create a Post'
              //                                       : index == 1
              //                                           ? 'Sell your product & service'
              //                                           : 'Create a Live Event',
              //                                   style: const TextStyle(
              //                                       fontSize: 18,
              //                                       fontWeight:
              //                                           FontWeight.w700),
              //                                 ),
              //                               );
              //                             },
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               });
              //         },
              //         // key: postButtonKey,
              //         backgroundColor: primaryColorLT,
              //       )
              //     : Container(),
              body: controller.loading.value
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/app/app_logo_2.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Start, Grow and Promote Your Business Globally',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    )
                  : controller.noConnection.value
                      ? SafetyModel(
                          isLoading: false,
                          title:
                              'Error While Loading Data\nCheck your Internet Connection',
                          subTitle: 'Try Reloading Again',
                          clickableText: 'Refresh',
                          onTap: () {
                            controller.loadData();
                            _profileController.fetchData();
                            _profileController.loadBoss();
                            marketController.initMarket();
                            marketController.initUsers();
                            _communitiesController.fetchIndustries();
                            bossUpController.fetchForums();
                          },
                          icon: const Icon(
                            Icons.warning,
                            size: 60,
                          ),
                        )
                      : controller.error.value
                          ? SafetyModel(
                              isLoading: false,
                              title: 'Error While Loading Data',
                              subTitle: 'Try Reloading Again',
                              clickableText: 'Refresh',
                              onTap: () {
                                controller.loadData();
                                _profileController.fetchData();
                                _profileController.loadBoss();
                                marketController.initMarket();
                                marketController.initUsers();
                                _communitiesController.fetchIndustries();
                                bossUpController.fetchForums();
                              },
                              icon: const Icon(
                                Icons.warning,
                                size: 60,
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: RefreshIndicator(
                                      onRefresh: refreshData,
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification: (notification) {
                                          if (notification
                                              is ScrollUpdateNotification) {
                                            if (notification.dragDetails !=
                                                    null &&
                                                notification.dragDetails!
                                                        .primaryDelta !=
                                                    null) {
                                              double primaryDelta = notification
                                                  .dragDetails!.primaryDelta!;

                                              if (primaryDelta > 0) {
                                                // Scrolling downward
                                                setState(() {
                                                  isScrolled = true;
                                                });
                                              } else if (primaryDelta < 0) {
                                                // Scrolling upward
                                                setState(() {
                                                  isScrolled = false;
                                                });
                                              }
                                            }
                                          }

                                          return true;
                                        },
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.mixedPosts.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index == 0) {
                                              return Column(
                                                children: [
                                                  const BossOfWeekProfileTile(),
                                                  liveEventController
                                                          .ongoing.isNotEmpty
                                                      ? Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    26,
                                                                    26,
                                                                    26),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 6),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center, // Adjust alignment as needed
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15.0),
                                                                child: Lottie
                                                                    .asset(
                                                                  'assets/anim/liveevent.json',
                                                                  height: 25,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      const TextScroll(
                                                                    '     Live Events - Create or Start listening to live events from bosses.           ',
                                                                    mode: TextScrollMode
                                                                        .bouncing,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15),
                                                                    velocity:
                                                                        Velocity(
                                                                      pixelsPerSecond:
                                                                          Offset(
                                                                              30,
                                                                              0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              15.0),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .grey
                                                                              .shade300),
                                                                    ),
                                                                    onPressed: () =>
                                                                        Navigator
                                                                            .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                const LiveEvent(),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      'Live Events',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ))
                                                      : Container()
                                                ],
                                              );
                                            } else {
                                              final Map<String, dynamic>
                                                  mixedPost =
                                                  controller.mixedPosts[index];

                                              if (mixedPost['isForum']) {
                                                // Handle ForumModel
                                                final ForumModel forumModel =
                                                    mixedPost['data']
                                                        as ForumModel;
                                                final bool hasIncrementedView =
                                                    controller
                                                        .itemsWithIncrementedViews
                                                        .contains(
                                                            forumModel.forumId);
                                                return VisibilityDetector(
                                                  key: Key(index.toString()),
                                                  onVisibilityChanged:
                                                      (VisibilityInfo info) {
                                                    if (info.visibleFraction ==
                                                            1.0 &&
                                                        !hasIncrementedView) {
                                                      controller
                                                          .updateForumViews(
                                                              forumModel);
                                                      setState(() {
                                                        controller
                                                            .itemsWithIncrementedViews
                                                            .add(forumModel
                                                                .forumId); // Set the flag to prevent further increments
                                                      });
                                                    }
                                                  },
                                                  child: ForumItem(
                                                    forum: forumModel,
                                                    controller: controller,
                                                  ),
                                                );
                                              } else if (mixedPost[
                                                  'isSponsored']) {
                                                // Handle Sponsored PostModel
                                                final int sponsoredIndex =
                                                    (index / 3).floor();
                                                if (sponsoredIndex <
                                                    controller.sponsoredPosts
                                                        .length) {
                                                  final PostModel
                                                      promotedPosts =
                                                      controller.sponsoredPosts[
                                                              sponsoredIndex]
                                                          ['data'];
                                                  final bool
                                                      hasIncrementedView =
                                                      controller
                                                          .itemsWithIncrementedViews
                                                          .contains(
                                                              promotedPosts
                                                                  .postId);
                                                  return VisibilityDetector(
                                                    key: Key(index.toString()),
                                                    onVisibilityChanged:
                                                        (VisibilityInfo info) {
                                                      if (info.visibleFraction ==
                                                              1.0 &&
                                                          !hasIncrementedView) {
                                                        controller.updateViews(
                                                            promotedPosts);
                                                        setState(() {
                                                          controller
                                                              .itemsWithIncrementedViews
                                                              .add(promotedPosts
                                                                  .postId); // Set the flag to prevent further increments
                                                        });
                                                      }
                                                    },
                                                    child: PostTile(
                                                      controller: controller,
                                                      post: promotedPosts,
                                                      onPageChange: (int page) {
                                                        if (widget
                                                                .onPageChange !=
                                                            null) {
                                                          widget.onPageChange!(
                                                              page);
                                                        }
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  // Handle case where there are no more sponsored posts
                                                  return const SizedBox(); // You can return an empty widget or something else
                                                }
                                              } else if (index % 4 == 0) {
                                                // Display Sponsored Post after every 3 non-sponsored posts
                                                final int sponsoredIndex =
                                                    (index / 4).floor();
                                                if (sponsoredIndex <
                                                    controller.sponsoredPosts
                                                        .length) {
                                                  final PostModel
                                                      promotedPosts =
                                                      controller.sponsoredPosts[
                                                              sponsoredIndex]
                                                          ['data'] as PostModel;
                                                  final bool
                                                      hasIncrementedView =
                                                      controller
                                                          .itemsWithIncrementedViews
                                                          .contains(
                                                              promotedPosts
                                                                  .postId);
                                                  return VisibilityDetector(
                                                    key: Key(index.toString()),
                                                    onVisibilityChanged:
                                                        (VisibilityInfo info) {
                                                      if (info.visibleFraction ==
                                                              1.0 &&
                                                          !hasIncrementedView) {
                                                        controller.updateViews(
                                                            promotedPosts);
                                                        setState(() {
                                                          controller
                                                              .itemsWithIncrementedViews
                                                              .add(promotedPosts
                                                                  .postId);
                                                        });
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        // Sponsored Post
                                                        PostTile(
                                                          controller:
                                                              controller,
                                                          post: promotedPosts,
                                                          onPageChange:
                                                              (int page) {
                                                            if (widget
                                                                    .onPageChange !=
                                                                null) {
                                                              widget.onPageChange!(
                                                                  page);
                                                            }
                                                          },
                                                        ),
                                                        // Non-promoted posts
                                                        // Adjust the height based on your design
                                                        PostTile(
                                                          controller:
                                                              controller,
                                                          post:
                                                              mixedPost['data']
                                                                  as PostModel,
                                                          onPageChange:
                                                              (int page) {
                                                            if (widget
                                                                    .onPageChange !=
                                                                null) {
                                                              widget.onPageChange!(
                                                                  page);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  // Handle case where there are no more sponsored posts
                                                  return const SizedBox(); // You can return an empty widget or something else
                                                }
                                              } else {
                                                // Handle regular non-promoted PostModel
                                                final PostModel
                                                    nonPromotedPostModel =
                                                    mixedPost['data']
                                                        as PostModel;
                                                final bool hasIncrementedView =
                                                    controller
                                                        .itemsWithIncrementedViews
                                                        .contains(
                                                            nonPromotedPostModel
                                                                .postId);
                                                return VisibilityDetector(
                                                  key: Key(index.toString()),
                                                  onVisibilityChanged:
                                                      (VisibilityInfo info) {
                                                    if (info.visibleFraction ==
                                                            1.0 &&
                                                        !hasIncrementedView) {
                                                      controller.updateViews(
                                                          nonPromotedPostModel);
                                                      setState(() {
                                                        controller
                                                            .itemsWithIncrementedViews
                                                            .add(
                                                                nonPromotedPostModel
                                                                    .postId);
                                                      });
                                                    }
                                                  },
                                                  child: PostTile(
                                                    controller: controller,
                                                    post: nonPromotedPostModel,
                                                    onPageChange: (int page) {
                                                      if (widget.onPageChange !=
                                                          null) {
                                                        widget.onPageChange!(
                                                            page);
                                                      }
                                                    },
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const BottomBar(
                                    activeIndex: 0,
                                  ),
                                  const Floatingbutton(),
                                ],
                              ),
                            ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadData() async {
    setState(() {});

    // Call the loadPosts() function from the PostsController
    // await Get.find<PostsController>().loadPosts();
    await Get.find<HomeController>().refreshData();

    setState(() {});
  }

  Future<void> refreshData() async {
    await loadData(); // Trigger data reload
  }

  // void showTutorial() {
  //   TutorialCoachMark(
  //     targets: targets, // List<TargetFocus>
  //     colorShadow: Colors.black, // DEFAULT Colors.black
  //     alignSkip: const AlignmentDirectional(0.95, -0.6),
  //     skipWidget: Container(
  //       decoration: BoxDecoration(
  //         color: primaryColorLT,
  //         borderRadius:
  //             BorderRadius.circular(50.0), // Adjust the radius as needed
  //       ),
  //       padding:
  //           const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
  //       child: const Row(
  //         mainAxisSize: MainAxisSize.min, // Set to 'min' to wrap the content
  //         children: [
  //           Text(
  //             'Close',
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w700),
  //           ),
  //           Icon(
  //             Icons.close_rounded,
  //             color: Colors.white,
  //           ),
  //         ],
  //       ),
  //     ),

  //     textStyleSkip: const TextStyle(
  //         fontSize: 20, fontWeight: FontWeight.w700, color: primaryColorLT),
  //     paddingFocus: 2,
  //     opacityShadow: 0.9,
  //     onClickTarget: (target) {
  //       print(target);
  //     },
  //     onClickTargetWithTapPosition: (target, tapDetails) {
  //       print("target: $target");
  //       print(
  //           "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
  //     },
  //     onClickOverlay: (target) {
  //       print(target);
  //     },
  //     onSkip: () {
  //       print("skip");
  //       return true;
  //     },
  //     onFinish: () {
  //       print("finish");
  //     },
  //   ).show(context: context);
  // }
}
