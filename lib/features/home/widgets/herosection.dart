import 'dart:async';
import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String image;
  final String action;
  final String icon;
  final String description;

  HeroItem({
    this.icon = '',
    this.description = '',
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.action,
  });
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  DateTime _lastInteraction = DateTime.now();
  late UserModel? user;
  final HomeController homeController = Get.find();
  late List<HeroItem> heroItems;
  final ProfileController _profileController = Get.find();
  final ChallengeController challengeController = Get.find();
  late Industry industry;

  @override
  void initState() {
    super.initState();
    user = homeController.bossOfTheWeek;
    industry = challengeController.categories[0];
    _startAutoRotation();
    heroItems = <HeroItem>[
      HeroItem(
        id: '1',
        type: 'boss',
        icon: 'assets/images/app_logo_2.png',
        title: 'Boss of the Week',
        subtitle: user?.name ?? '',
        description: user?.bio ?? '',
        image: user?.photoUrl ?? '',
        action: user?.connecteds != null &&
                _profileController.myProfile.connecteds!.contains(user!.uid)
            ? 'Refer'
            : 'Follow',
      ),
      HeroItem(
        id: '2',
        type: 'deals',
        title: 'Partner Deals',
        subtitle: 'Up to 70% Off Premium Services',
        image:
            'https://images.pexels.com/photos/3184301/pexels-photo-3184301.jpeg',
        action: 'View Deals',
      ),
      HeroItem(
        id: '3',
        type: 'challenges',
        title: 'Challenges',
        subtitle: '12 Challenges Available to Join',
        image:
            'https://images.pexels.com/photos/8422751/pexels-photo-8422751.jpeg',
        action: 'View Challenges',
      ),
      HeroItem(
        id: '4',
        type: 'events',
        title: 'Events',
        subtitle: '12 Events Available to Join',
        image:
            'https://images.pexels.com/photos/9088850/pexels-photo-9088850.jpeg',
        action: 'View Events',
      ),
      HeroItem(
        id: '5',
        type: 'matches',
        title: 'Matches',
        subtitle: 'Find Your Business Match',
        image:
            'https://images.pexels.com/photos/8380089/pexels-photo-8380089.jpeg',
        action: 'View Matches',
      )
    ];
  }

  void _startAutoRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final Duration timeSinceLast =
          DateTime.now().difference(_lastInteraction);
      if (timeSinceLast.inSeconds >= 5) {
        final int nextIndex = (_currentIndex + 1) % heroItems.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextIndex;
        });
      }
    });
  }

  void _onUserInteraction() {
    _lastInteraction = DateTime.now();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onSlideTap(HeroItem item) {
    _onUserInteraction();
    debugPrint('Navigate to ${item.type}: ${item.title}');
  }

  Future<void> onRefer(UserModel publicUser) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    final ApiResponseModel res = await ApiService.get(
        path: 'connection/connecteds/referals/${publicUser.uid}');
    Get.back();

    if (res.success) {
      if (res.data.isEmpty) {
        String message =
            'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
            'https://businessbosses.onelink.me/xLWk/36a2ff16';
        logEvent(publicUser.uid, 'user');
        socialShare(message);
      } else {
        Get.toNamed(
          Routes.referscreen,
          arguments: <String, dynamic>{'user': publicUser},
        );
      }
    }
  }

  Future<void> connectToUser() async {
    final int checkConnected = _profileController.myProfile.connecteds == null
        ? -1
        : _profileController.myProfile.connecteds!
            .indexWhere((String element) => element == user?.uid);

    if (checkConnected == -1) {
      _profileController.updateConnections(user!.uid);
      setState(() {
        user = UserModel.fromMap(<dynamic, dynamic>{
          ...user!.toMap(),
          'connectionCount':
              user?.connectionCount == null ? 1 : user!.connectionCount! + 1
        });
      });
      await connect(user!.uid);
    } else {
      _profileController.updateConnections(user!.uid);
      setState(() {
        user = UserModel.fromMap(<dynamic, dynamic>{
          ...user!.toMap(),
          'connectionCount':
              user?.connectionCount == null ? null : user!.connectionCount! - 1
        });
      });
      await disconnect(user!.uid);
    }

    // update heroItems[0] action text after follow/unfollow
    setState(() {
      heroItems[0] = HeroItem(
        id: heroItems[0].id,
        type: heroItems[0].type,
        icon: heroItems[0].icon,
        title: heroItems[0].title,
        subtitle: user?.name ?? '',
        description: user?.bio ?? '',
        image: user?.photoUrl ?? '',
        action: _profileController.myProfile.connecteds != null &&
                _profileController.myProfile.connecteds!
                    .contains(user?.uid ?? '')
            ? 'Following'
            : 'Follow',
      );
    });
  }

  Future<void> disconnect(String userId) async {
    ApiService.post(path: 'connection/disconnect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      homeController.bossOfTheWeek?.connecteds?.removeWhere(
          (String string) => string == _profileController.myProfile.uid);

      user?.connecteds?.removeWhere(
          (String string) => string == _profileController.myProfile.uid);
    });
  }

  Future<void> connect(String userId) async {
    ApiService.post(path: 'connection/connect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    setState(() {
      homeController.bossOfTheWeek?.connecteds
          ?.add(_profileController.myProfile.uid);

      user?.connecteds?.add(_profileController.myProfile.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: (_onUserInteraction),
            onPanDown: (_) => _onUserInteraction(),
            child: SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: heroItems.length,
                onPageChanged: (int index) {
                  setState(() => _currentIndex = index);
                  _onUserInteraction();
                },
                itemBuilder: (BuildContext context, int index) {
                  final HeroItem item = heroItems[index];
                  return GestureDetector(
                    onTap: () => _onSlideTap(item),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            CachedNetworkImage(
                              key: ValueKey(item.image),
                              imageUrl: item.image,
                              fit: BoxFit.cover,
                              memCacheHeight: 1000,
                              errorWidget: (BuildContext context, String url,
                                      Object error) =>
                                  const Icon(Icons.error),
                            ),
                            GestureDetector(
                              onTap: () {
                                switch (item.action) {
                                  case 'Follow':
                                  case 'Refer':
                                    Get.toNamed(Routes.publicProfile,
                                        arguments: user);
                                    break;
                                  case 'View Deals':
                                    Get.to(() => const Bossuppartner());
                                    break;
                                  case 'View Challenges':
                                    Get.toNamed(Routes.allCommunitiesScreen);
                                    break;
                                  case 'View Matches':
                                    Get.toNamed(Routes.expandedmatchesscreen);
                                    break;
                                  default:
                                    Get.toNamed(Routes.liveEvents);
                                    break;
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Colors.transparent,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          spacing: 5,
                                          children: <Widget>[
                                            Text(
                                              item.title,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item.subtitle,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        if (item.description != '')
                                          Text(
                                            item.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFE5E7EB),
                                            ),
                                          ),
                                        const SizedBox(height: 12),
                                        Row(
                                          spacing: 5,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () async {
                                                switch (item.action) {
                                                  case 'Follow':
                                                    await connectToUser();
                                                    break;
                                                  case 'Refer':
                                                    await onRefer(user!);
                                                    break;
                                                  case 'View Deals':
                                                    Get.to(() =>
                                                        const Bossuppartner());
                                                    break;
                                                  case 'View Challenges':
                                                    Get.toNamed(Routes
                                                        .allCommunitiesScreen);
                                                    break;
                                                  default:
                                                    Get.toNamed(
                                                        Routes.liveEvents);
                                                    break;
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: primaryColorLT,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  spacing: 5,
                                                  children: <Widget>[
                                                    Icon(
                                                      (item.action ==
                                                                  'Follow' ||
                                                              item.action ==
                                                                  'Following')
                                                          ? LucideIcons.userPlus
                                                          : item.action ==
                                                                  'Refer'
                                                              ? LucideIcons
                                                                  .forward
                                                              : item.action ==
                                                                      'View Challenges'
                                                                  ? LucideIcons
                                                                      .trophy
                                                                  : item.action ==
                                                                          'View Events'
                                                                      ? LucideIcons
                                                                          .calendar
                                                                      : item.action ==
                                                                              'View Matches'
                                                                          ? LucideIcons
                                                                              .users
                                                                          : LucideIcons
                                                                              .arrowUpRight,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      item.action,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (item.title ==
                                                'Boss of the Week')
                                              GestureDetector(
                                                onTap: () {
                                                  int now = DateTime.now()
                                                      .millisecondsSinceEpoch;
                                                  int previousStamp =
                                                      _profileController
                                                              .myProfile
                                                              .bossOfTheWeekTimeStamp ??
                                                          0;
                                                  if ((previousStamp +
                                                              1209600000) >
                                                          now &&
                                                      industry.industryId ==
                                                          '-MsUOGcOT9oRXGakCcJv') {
                                                    const SnackBar snackBar =
                                                        SnackBar(
                                                      duration:
                                                          Duration(seconds: 4),
                                                      content: Text(
                                                          'You may have posted in Boss Up Challenge'
                                                          ' in the past 12 weeks. You Can only post once in 12 weeks.'),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    if (industry.industryId ==
                                                        '-MsUOGcOT9oRXGakCcJv') {
                                                      Get.to(
                                                        () =>
                                                            CreateBossUpScreen(
                                                                industryModel:
                                                                    industry),
                                                        arguments: <String,
                                                            Object?>{
                                                          'isBossUp': true,
                                                          'industryId': industry
                                                              .industryId
                                                        },
                                                        binding: BindingsBuilder
                                                            .put(() =>
                                                                CreateBossUpController()),
                                                      );
                                                    } else {
                                                      if (_profileController
                                                          .myProfile
                                                          .postChallenges!
                                                          .contains(industry
                                                              .industryId)) {
                                                        const SnackBar
                                                            snackBar = SnackBar(
                                                          duration: Duration(
                                                              seconds: 4),
                                                          content: Text(
                                                              'You can only post once in a challenge'),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                        return;
                                                      }
                                                      Get.to(
                                                        () =>
                                                            CreateBossUpScreen(
                                                                industryModel:
                                                                    industry),
                                                        arguments: <String,
                                                            Object?>{
                                                          'isBossUp': true,
                                                          'industryId': industry
                                                              .industryId
                                                        },
                                                        binding: BindingsBuilder<
                                                                CreateBossUpController>.put(
                                                            () =>
                                                                CreateBossUpController()),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                                  child: Row(
                                                    spacing: 5,
                                                    children: <Widget>[
                                                      Text(
                                                        'Become Boss of the Week',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        LucideIcons.plus,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            // if (item.title ==
                                            //     'Boss of the Week')
                                            //   CircleAvatar(
                                            //     backgroundColor: Colors.white,
                                            //     child: Icon(LucideIcons.info,
                                            //         color: Colors.black87,
                                            //         size: 16),
                                            //   ),
                                            if (item.title == 'Partner Deals')
                                              GestureDetector(
                                                onTap: () async {
                                                  if (await canLaunchUrl(Uri.parse(
                                                      'https://businessbosses.co.uk/landingpageforpartners'))) {
                                                    await launchUrl(Uri.parse(
                                                        'https://businessbosses.co.uk/landingpageforpartners'));
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                                  child: Row(
                                                    spacing: 5,
                                                    children: <Widget>[
                                                      Text(
                                                        'Become a Partner',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        LucideIcons.plus,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(heroItems.length, (int index) {
              final bool isActive = index == _currentIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() => _currentIndex = index);
                  _onUserInteraction();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.black : const Color(0xFFD1D5DB),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
