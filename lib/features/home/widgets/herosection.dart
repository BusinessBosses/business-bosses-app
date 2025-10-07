import 'dart:async';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/learningpage.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class WinnerCardConfig {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconColor;
  final Color accentColor;

  const WinnerCardConfig({
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.iconColor,
    required this.accentColor,
  });
}

class HeroItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String image;
  final String action;
  final String icon;
  final String description;
  final String action2;

  HeroItem({
    this.icon = '',
    this.description = '',
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.action,
    this.action2 = '',
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
  late UserModel? mentor;
  late UserModel? backer;
  final HomeController homeController = Get.find();
  late List<HeroItem> heroItems;
  final ProfileController _profileController = Get.find();
  final ChallengeController challengeController = Get.find();
  late Industry industry;

  static const Map<String, WinnerCardConfig> cardConfigs =
      <String, WinnerCardConfig>{
    'boss': WinnerCardConfig(
      title: 'Boss of the Week',
      icon: LucideIcons.trophy,
      gradientColors: <Color>[
        Color(0xFFFBBF24),
        Color(0xFFF97316),
        Color(0xFFEF4444)
      ],
      iconColor: Color(0xFFFCD34D),
      accentColor: Color(0x33FBBf24),
    ),
    'backer': WinnerCardConfig(
      title: 'Backer of the Week',
      icon: LucideIcons.dollarSign,
      gradientColors: <Color>[
        Color(0xFF34D399),
        Color(0xFF14B8A6),
        Color(0xFF0891B2)
      ],
      iconColor: Color(0xFF6EE7B7),
      accentColor: Color(0x3334D399),
    ),
    'mentor': WinnerCardConfig(
      title: 'Mentor of the Week',
      icon: LucideIcons.graduationCap,
      gradientColors: <Color>[
        Color(0xFF60A5FA),
        Color(0xFF0EA5E9),
        Color(0xFF06B6D4)
      ],
      iconColor: Color(0xFF93C5FD),
      accentColor: Color(0x3360A5FA),
    ),
    'partner': WinnerCardConfig(
      title: 'Partner of the Week',
      icon: LucideIcons.heartHandshake,
      gradientColors: <Color>[
        Color(0xFFFB7185),
        Color(0xFFEC4899),
        Color(0xFFD946EF)
      ],
      iconColor: Color(0xFFFDA4AF),
      accentColor: Color(0x33FB7185),
    ),
  };

  @override
  void initState() {
    super.initState();
    user = homeController.bossOfTheWeek;
    mentor = homeController.mentorOfTheWeek;
    backer = homeController.backerOfTheWeek;
    industry = challengeController.categories[0];
    _startAutoRotation();
    heroItems = <HeroItem>[
      HeroItem(
          id: '1',
          type: 'boss',
          icon: 'assets/images/app_logo_2.png',
          title: 'Boss of the Week',
          subtitle: user?.name ?? user!.username,
          description: user?.bio ?? '',
          image: user?.photoUrl ?? '',
          action: _profileController.myProfile.connecteds!.contains(user!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Enter Challenge'),
      HeroItem(
          id: '2',
          type: 'mentor',
          title: 'Mentor of the Week',
          subtitle: mentor?.name ?? mentor!.username,
          image: mentor?.photoUrl ?? '',
          description: mentor?.bio ?? '',
          action: _profileController.myProfile.connecteds!.contains(mentor!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Enter Challenge'),
      HeroItem(
          id: '3',
          type: 'backer',
          title: 'Backer of the Week',
          subtitle: backer?.name ?? backer!.username,
          image: backer?.photoUrl ?? '',
          description: backer?.bio ?? '',
          action: _profileController.myProfile.connecteds!.contains(backer!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Enter Challenge'),
      HeroItem(
          id: '4',
          type: 'partner',
          title: 'Partner of the Week',
          subtitle: user?.name ?? '',
          image: 'none',
          description: user?.bio ?? '',
          action: user?.connecteds != null &&
                  _profileController.myProfile.connecteds!.contains(user!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Claim Deal'),
      HeroItem(
        id: '7',
        type: 'events',
        title: 'Events',
        subtitle: 'Share your thoughts with bosses',
        image:
            'https://images.pexels.com/photos/9088850/pexels-photo-9088850.jpeg',
        action: 'View Events',
      ),
      HeroItem(
          id: '8',
          type: 'matches',
          title: 'Matches',
          subtitle: 'Find Your Business Match',
          image:
              'https://images.pexels.com/photos/8380089/pexels-photo-8380089.jpeg',
          action: 'View Matches',
          action2: ''),
    ];
  }

  void _startAutoRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      final Duration timeSinceLast =
          DateTime.now().difference(_lastInteraction);
      if (timeSinceLast.inSeconds >= 2) {
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
    // Check if current user (you) already have this Boss in your connecteds
    final bool isConnected = _profileController.myProfile.connecteds != null &&
        _profileController.myProfile.connecteds!.contains(user?.uid);

    // Toggle connection state locally
    _profileController.updateConnections(user!.uid);

    // Update UI (for button text etc.)
    setState(() {
      final String actionText = isConnected ? 'Follow' : 'Refer';
      for (int i = 0; i < 4; i++) {
        heroItems[i] = HeroItem(
          id: heroItems[i].id,
          type: heroItems[i].type,
          icon: heroItems[i].icon,
          title: heroItems[i].title,
          subtitle: user?.name ?? '',
          description: user?.bio ?? '',
          image: heroItems[i].image,
          action: actionText,
          action2: heroItems[i].action2,
        );
      }
    });

    // API call: connect or disconnect depending on current state
    if (!isConnected) {
      await connect(user!.uid);
    } else {
      await disconnect(user!.uid);
    }
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: 'connection/connect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void enterChallenge() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int previousStamp =
        _profileController.myProfile.bossOfTheWeekTimeStamp ?? 0;

    if ((previousStamp + 1209600000) > now &&
        industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
      const SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'You may have posted in Boss Up Challenge'
          ' in the past 12 weeks. You can only post once in 12 weeks.',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (industry.industryId == '-MsUOGcOT9oRXGakCcJv') {
        Get.to(
          () => CreateBossUpScreen(industryModel: industry),
          arguments: <String, Object?>{
            'isBossUp': true,
            'industryId': industry.industryId,
          },
          binding: BindingsBuilder<CreateBossUpController>.put(
              () => CreateBossUpController()),
        );
      } else {
        if (_profileController.myProfile.postChallenges!
            .contains(industry.industryId)) {
          const SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 4),
            content: Text('You can only post once in a challenge'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        Get.to(
          () => CreateBossUpScreen(industryModel: industry),
          arguments: <String, Object?>{
            'isBossUp': true,
            'industryId': industry.industryId,
          },
          binding: BindingsBuilder<CreateBossUpController>.put(
            () => CreateBossUpController(),
          ),
        );
      }
    }
  }

  void referuser() async {
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
        path: '/connection/connecteds/referals/${user?.uid}');
    Navigator.pop(context);

    if (res.success) {
      if (res.data.isEmpty) {
        String message =
            'Have a look at ${user?.username}\'s profile on Business Bosses\n'
            'https://businessbosses.onelink.me/xLWk/36a2ff16';
        logEvent(user?.uid, 'user');
        socialShare(message);
      } else {
        Get.toNamed(
          Routes.referscreen,
          arguments: <String, dynamic>{'user': user},
        );
      }
    }
  }

  void enterbackeroftheweek() {
    print('backer of the week');
  }

  void entermentoroftheweek() {
    print('mentor of the week');
  }

  void enterpartneroftheweek() {
    print('partner of the week');
  }

  Widget _buildWinnerCard(HeroItem item) {
    final WinnerCardConfig? config = cardConfigs[item.type];
    if (config == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.gradientColors,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: config.gradientColors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Background icon watermark
          Positioned(
            top: -50,
            right: -20,
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                config.icon,
                size: 128,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Title
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      config.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Winner info card
                GestureDetector(
                  onTap: () {
                    // Determine which user to navigate to based on card type
                    UserModel? targetUser;
                    switch (item.type) {
                      case 'boss':
                        targetUser = user;
                        break;
                      case 'mentor':
                        targetUser = mentor;
                        break;
                      case 'backer':
                        targetUser = backer;
                        break;
                      case 'partner':
                        targetUser = user;
                        break;
                    }

                    if (targetUser != null) {
                      Get.toNamed(Routes.publicProfile, arguments: targetUser);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        // Avatar
                        item.image != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: NetworkImageWithPlaceHolder(
                                  imageUrl: item.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _buildDefaultAvatar(config, item.subtitle),

                        const SizedBox(width: 12),

                        // Name and description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.description.isNotEmpty)
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        switch (item.action) {
                          case 'Follow':
                            connectToUser();
                            break;
                          case 'Refer':
                            referuser();
                            break;
                          case 'View Matches':
                            Get.to(() => ExpandedMatchesScreen());
                            break;
                          default:
                            Get.toNamed(Routes.liveEvents);
                            break;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                                item.action == 'View Events'
                                    ? LucideIcons.calendar
                                    : item.action == 'Refer'
                                        ? LucideIcons.forward
                                        : LucideIcons.userPlus,
                                size: 16,
                                color: textColor),
                            const SizedBox(width: 5),
                            Text(
                              item.action,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        switch (item.action2.isNotEmpty ? item.action2 : '') {
                          case 'Enter Challenge':
                            item.id == '1'
                                ? enterChallenge()
                                : item.id == '2'
                                    ? entermentoroftheweek()
                                    : item.id == '3'
                                        ? enterbackeroftheweek()
                                        : enterpartneroftheweek();
                            break;
                          case 'View Matches':
                            Get.to(() => ExpandedMatchesScreen());
                            break;
                          default:
                            Get.toNamed(Routes.liveEvents);
                            break;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              item.action == 'View Events'
                                  ? LucideIcons.calendar
                                  : LucideIcons.plus,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item.action2.isNotEmpty ? item.action2 : '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(WinnerCardConfig config, String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: _onUserInteraction,
            onPanDown: (_) => _onUserInteraction(),
            child: SizedBox(
              height: 270,
              child: PageView.builder(
                controller: _pageController,
                itemCount: heroItems.length,
                onPageChanged: (int index) {
                  setState(() => _currentIndex = index);
                  _onUserInteraction();
                },
                itemBuilder: (BuildContext context, int index) {
                  final HeroItem item = heroItems[index];
                  final Industry category = challengeController.categories[0];

                  // Use winner card for boss, mentor, backer, partner
                  if (cardConfigs.containsKey(item.type)) {
                    return GestureDetector(
                      onTap: () {
                        switch (item.type) {
                          case 'boss':
                            DateTime now = DateTime.now();
                            if (category.startAt != null &&
                                now.isBefore(category.startAt!)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'How It Works!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          category.criteria!,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _calculateStartDate(
                                              category.startAt!),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            Get.to(() => BossUpSection(
                                  industry: category,
                                  bossUp: challengeController.categories[0],
                                ));

                            break;
                          case 'mentor':
                            Get.to(LearningPage());
                            break;
                          case 'backer':
                            Get.to(DonationsPage(
                              ishome: false,
                            ));
                            break;
                          case 'partner':
                            Get.to(Bossuppartner());
                            break;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _buildWinnerCard(item),
                      ),
                    );
                  }

                  // Use original card for matches and events
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
                                decoration: BoxDecoration(
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
                              child: GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: () async {
                                          switch (item.action) {
                                            case 'View Deals':
                                              Get.to(
                                                  () => const Bossuppartner());
                                              break;
                                            case 'View Challenges':
                                              Get.toNamed(
                                                  Routes.allCommunitiesScreen);
                                              break;
                                            case 'View Matches':
                                              Get.to(() =>
                                                  ExpandedMatchesScreen());
                                              break;
                                            default:
                                              Get.toNamed(Routes.liveEvents);
                                              break;
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                item.action == 'View Events'
                                                    ? LucideIcons.calendar
                                                    : item.action ==
                                                            'View Deals'
                                                        ? LucideIcons
                                                            .arrowUpRight
                                                        : item.action ==
                                                                'View Challenges'
                                                            ? LucideIcons.trophy
                                                            : LucideIcons.users,
                                                size: 16,
                                                color: textColor,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item.action,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (item.action2.isNotEmpty) ...<Widget>[
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            switch (item.action2.isNotEmpty
                                                ? item.action2
                                                : '') {
                                              case 'Become a Partner':
                                                if (await canLaunchUrl(Uri.parse(
                                                    'https://businessbosses.co.uk/landingpageforpartners'))) {
                                                  await launchUrl(Uri.parse(
                                                      'https://businessbosses.co.uk/landingpageforpartners'));
                                                }
                                                break;
                                              case 'Create an event':
                                                Get.toNamed(Routes.liveEvents);
                                                break;
                                              default:
                                                break;
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  LucideIcons.plus,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  item.action2.isNotEmpty
                                                      ? item.action2
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
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
            children: List<Widget>.generate(heroItems.length, (int index) {
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

String _calculateStartDate(DateTime startAt) {
  // Format the endedAt date using DateFormat
  String formattedDate = DateFormat('d MMM').format(startAt);
  return 'Starts $formattedDate';
}
