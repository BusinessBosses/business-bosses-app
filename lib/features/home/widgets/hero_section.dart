import 'dart:async';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:intl/intl.dart';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:business_bosses_v2/features/donations/presentation/create_donations.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_learning_posts.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
  final Map<String, dynamic>? metrics;

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
    this.metrics,
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
  dynamic partner;
  final HomeController homeController = Get.find();
  late List<HeroItem> heroItems;
  final ProfileController _profileController = Get.find();
  final ChallengeController challengeController = Get.find();
  late Industry industry;

  static const Map<String, WinnerCardConfig> cardConfigs =
      <String, WinnerCardConfig>{
    'boss': WinnerCardConfig(
      title: 'Boss of The Week',
      icon: LucideIcons.trophy,
      gradientColors: <Color>[backgroundColor, backgroundColor],
      iconColor: Color(0xFFFCD34D),
      accentColor: Color(0x33FBBf24),
    ),
    'backer': WinnerCardConfig(
      title: 'Backer of the Week',
      icon: LucideIcons.dollarSign,
      gradientColors: <Color>[Color(0xFFE0F2F1), Color(0xFFE0F2F1)],
      iconColor: Color(0xFF6EE7B7),
      accentColor: Color(0x3334D399),
    ),
    'mentor': WinnerCardConfig(
      title: 'Mentor of the Week',
      icon: LucideIcons.graduationCap,
      gradientColors: <Color>[Color(0xFFE0F2FE), Color(0xFFE0F2FE)],
      iconColor: Color(0xFF93C5FD),
      accentColor: Color(0x3360A5FA),
    ),
    'partner': WinnerCardConfig(
      title: 'Partner of the Week',
      icon: LucideIcons.heartHandshake,
      gradientColors: <Color>[
        Color.fromARGB(255, 251, 249, 231),
        Color.fromARGB(255, 251, 249, 231),
      ],
      iconColor: Color(0xFFFDA4AF),
      accentColor: Color(0x33FB7185),
    ),
    'matches': WinnerCardConfig(
      title: 'Matches',
      icon: LucideIcons.users,
      gradientColors: <Color>[Color(0xFFE0F2FE), Color(0xFFE0F2FE)],
      iconColor: Color(0xFF93C5FD),
      accentColor: Color(0x3360A5FA),
    ),
    'ai_visibility': WinnerCardConfig(
      title: 'AI Visibility Score',
      icon: LucideIcons.bot,
      gradientColors: <Color>[Color(0xFFF0F9FF), Color(0xFFF0F9FF)],
      iconColor: Color(0xFF0EA5E9),
      accentColor: Color(0x3338BDF8),
    ),
    'performance': WinnerCardConfig(
      title: 'My Performance',
      icon: LucideIcons.trendingUp,
      gradientColors: <Color>[Color(0xFFF6F5F8), Color(0xFFF6F5F8)],
      iconColor: primaryColorLT,
      accentColor: Color(0x335B4DFF),
    ),
  };

  @override
  void initState() {
    super.initState();
    user = homeController.bossOfTheWeek;
    mentor = homeController.mentorOfTheWeek;
    backer = homeController.backerOfTheWeek;
    partner = homeController.partnerOfTheWeek;

    if (challengeController.categories.isNotEmpty) {
      industry = challengeController.categories[0];
    } else {
      industry = Industry(
        industryId: '',
        industry: '',
        categoryId: '',
        description: '',
      );
    }

    _startAutoRotation();
    homeController.fetchRankWinner();
    _initializeHeroItems();
  }

  void _initializeHeroItems() {
    heroItems = <HeroItem>[
      HeroItem(
        id: '6',
        type: 'performance',
        title: 'My Performance',
        icon: 'assets/images/app_logo_2.png',
        subtitle: '',
        description: '',
        image: '',
        action: 'Increase Visibility',
        action2: 'Visit BizCenter',
      ),
      HeroItem(
        id: '0',
        type: 'boss',
        icon: 'assets/images/app_logo_2.png',
        title: 'Top Ranking of the Week',
        subtitle: user?.name ?? user?.username ?? '',
        description: user?.bio ?? '',
        image: user?.photoUrl ?? '',
        action: (user != null &&
                _profileController.myProfile.connecteds != null &&
                _profileController.myProfile.connecteds!.contains(user!.uid))
            ? 'Refer'
            : 'Follow',
        action2: 'Get Featured',
      ),
      HeroItem(
        id: '1',
        type: 'mentor',
        icon: 'assets/images/app_logo_2.png',
        title: 'Mentor of the Week',
        subtitle: mentor?.name ?? mentor?.username ?? '',
        image: mentor?.photoUrl ?? '',
        description: mentor?.bio ?? '',
        action: (mentor != null &&
                _profileController.myProfile.connecteds != null &&
                _profileController.myProfile.connecteds!.contains(mentor!.uid))
            ? 'Refer'
            : 'Follow',
        action2: 'Share Learning',
      ),
      HeroItem(
        id: '2',
        type: 'backer',
        icon: 'assets/images/app_logo_2.png',
        title: 'Backer of the Week',
        subtitle: backer?.name ?? backer?.username ?? '',
        image: backer?.photoUrl ?? '',
        description: backer?.bio ?? '',
        action: (backer != null &&
                _profileController.myProfile.connecteds != null &&
                _profileController.myProfile.connecteds!.contains(backer!.uid))
            ? 'Refer'
            : 'Follow',
        action2: 'Fund Project',
      ),
      HeroItem(
        id: '3',
        type: 'partner',
        title: 'Partner of the Week',
        icon: 'assets/images/app_logo_2.png',
        subtitle: partner != null ? (partner['companyName'] ?? '') : '',
        image: partner != null ? (partner['companyPhoto'] ?? '') : '',
        description:
            partner != null ? (partner['companyDescription'] ?? '') : '',
        action: 'Claim Deal',
        action2: 'Become a Partner',
      ),
      HeroItem(
        id: '5',
        type: 'matches',
        title: 'Matches',
        icon: 'assets/images/app_logo_2.png',
        subtitle:
            'See your top matches and connect with people and opportunities that can help your business grow.',
        image: '',
        action: 'View your Match',
        action2: '',
      ),
    ];
  }

  UserModel? get rankWinner => homeController.rankWinner;
  Shop? get rankWinnerShop => homeController.rankWinnerShop;

  void _startAutoRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 9), (Timer timer) {
      final Duration timeSinceLast = DateTime.now().difference(
        _lastInteraction,
      );
      if (timeSinceLast.inSeconds >= 9) {
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
    String message =
        'Have a look at ${publicUser.username}\'s profile on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(publicUser.uid, 'user');
    socialShare(message);
  }

  Future<void> connectToUser() async {
    final bool isConnected = _profileController.myProfile.connecteds != null &&
        _profileController.myProfile.connecteds!.contains(user?.uid);

    _profileController.updateConnections(user!.uid);

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
      },
    );
  }

  Future<void> connect(String userId) async {
    await ApiService.post(
      path: 'connection/connect',
      body: <String, dynamic>{
        'userId': _profileController.myProfile.uid,
        'connectedId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
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
            () => CreateBossUpController(),
          ),
        );
      } else {
        if (_profileController.myProfile.postChallenges!.contains(
          industry.industryId,
        )) {
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
    String message =
        'Have a look at ${user?.username}\'s profile on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(user?.uid, 'user');
    socialShare(message);
  }

  void enterbackeroftheweek() {
    Get.to(() => DonationsPage(ishome: false));
  }

  void entermentoroftheweek() {
    Get.to(() => const AllLearningPostsScreen(isCoursesTile: false));
  }

  void enterpartneroftheweek() {
    if (!_profileController.myProfile.isSubscribed) {
      showPremiumPaywall();
    } else {
      Get.to(() => const BecomeaPartnerScreen());
    }
  }

  Widget _buildWinnerCard(HeroItem item) {
    if (item.type == 'performance') {
      return _buildPerformanceCard(item);
    }
    final WinnerCardConfig? config = cardConfigs[item.type];
    if (config == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        switch (item.type) {
          case 'ai_visibility':
            Get.to(() => ReachScreen(
                  user: _profileController.myProfile,
                ));
            break;
          case 'boss':
            Get.to(() => const BossupChallenge(ishome: false));
            break;
          case 'ranking':
            Get.to(() => ReachScreen(
                  user: _profileController.myProfile,
                ));
            break;
          case 'mentor':
            Get.to(() => const AllLearningPostsScreen(isCoursesTile: false));
            break;
          case 'backer':
            Get.to(() => DonationsPage(ishome: false));
            break;
          case 'partner':
            Get.to(() => BossUpPartner());
            break;
          case 'matches':
            Get.to(() => const ExpandedMatchesScreen());
            break;
          default:
            break;
        }
      },
      child: Container(
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
              color: config.gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              right: -20,
              child: Opacity(
                opacity: 0.05,
                child: Icon(config.icon, size: 128, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(item.icon, width: 22, height: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: item.type == 'my_ranking'
                            ? GetBuilder<ReachController>(
                                builder: (ReachController reach) {
                                final String rank =
                                    reach.data?['globalRank']?.toString() ??
                                        'N/A';
                                return Text(
                                  'Your Reach Ranking is #$rank',
                                  style: const TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              })
                            : Text(
                                config.title,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          color: textColor, size: 20),
                    ],
                  ),
                  if (item.type != 'matches' &&
                      item.type != 'ranking' &&
                      item.type != 'my_ranking')
                    GestureDetector(
                      onTap: () {
                        UserModel? targetUser;
                        dynamic partner;
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
                            partner = homeController.partnerOfTheWeek;
                            break;
                        }

                        if (targetUser != null) {
                          Get.toNamed(
                            Routes.publicProfile,
                            arguments: targetUser,
                          );
                        }
                        if (partner != null) {
                          Uri url = Uri.parse(partner['companyUrl']);
                          canLaunchUrl(url).then((bool canLaunch) {
                            if (canLaunch) {
                              launchUrl(url);
                            }
                          });
                        }
                      },
                      child: Container(
                        height: 75,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildHeroAvatar(item, config),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      color: Colors.black,
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
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (item.type == 'matches')
                    Container(
                      height: 75,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (item.type == 'ranking')
                    GetBuilder<HomeController>(
                      builder: (HomeController hController) {
                        if (hController.loadingRankWinner.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 27),
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }

                        // Update the hero item data if rank winner is loaded
                        if (hController.rankWinner != null &&
                            hController.rankWinnerShop != null) {
                          final Shop shop = hController.rankWinnerShop!;
                          final UserModel rWinner = hController.rankWinner!;
                          item = HeroItem(
                            id: '0',
                            type: 'ranking',
                            title: 'Top Ranked This Week',
                            icon: 'assets/images/app_logo_2.png',
                            subtitle: shop.name.isNotEmpty
                                ? shop.name
                                : (rWinner.name ?? rWinner.username),
                            image: shop.image ?? rWinner.photoUrl ?? '',
                            description: shop.description.isNotEmpty
                                ? shop.description
                                : (rWinner.bio ?? ''),
                            action: (_profileController.myProfile.connecteds!
                                    .contains(rWinner.uid))
                                ? 'Refer'
                                : 'Follow',
                            action2: 'Get Featured',
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            if (hController.rankWinner != null) {
                              Get.toNamed(
                                Routes.publicProfile,
                                arguments: hController.rankWinner,
                              );
                            }
                          },
                          child: Container(
                            height: 75,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _buildHeroAvatar(item, config),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          color: Colors.black,
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
                                            color: Colors.black87,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  if (item.type == 'my_ranking')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: GetBuilder<ReachController>(
                        builder: (ReachController reach) => reach
                                    .loading.value &&
                                reach.data == null
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          switch (item.action) {
                            case 'Follow':
                              if (item.type == 'boss' ||
                                  item.type == 'mentor' ||
                                  item.type == 'backer' ||
                                  item.type == 'ranking') {
                                if (item.type == 'ranking' &&
                                    rankWinner != null) {
                                  final bool isConnected = _profileController
                                              .myProfile.connecteds !=
                                          null &&
                                      _profileController.myProfile.connecteds!
                                          .contains(rankWinner!.uid);
                                  _profileController
                                      .updateConnections(rankWinner!.uid);
                                  if (!isConnected) {
                                    await connect(rankWinner!.uid);
                                  } else {
                                    await disconnect(rankWinner!.uid);
                                  }
                                } else {
                                  connectToUser();
                                }
                              }
                              break;
                            case 'Refer':
                              referuser();
                              break;
                            case 'Get Featured':
                              if (item.type == 'ranking' ||
                                  item.type == 'boss') {
                                DateTime now = DateTime.now();
                                if (industry.startAt != null &&
                                    now.isBefore(industry.startAt!)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'How It Works!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
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
                                              industry.criteria!,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              _calculateStartDate(
                                                  industry.startAt!),
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
                                enterChallenge();
                              } else {
                                enterChallenge();
                              }
                              break;
                            case 'View your Match':
                              Get.to(() => const ExpandedMatchesScreen());
                              break;
                            case 'Check Score':
                              Get.to(() => ReachScreen(
                                    user: _profileController.myProfile,
                                  ));
                              break;
                            case 'Claim Deal':
                              final Uri url = Uri.parse(partner['companyUrl']);
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
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
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                item.action == 'View Events'
                                    ? LucideIcons.calendar
                                    : item.action == 'Refer'
                                        ? LucideIcons.forward
                                        : item.action == 'Claim Deal'
                                            ? LucideIcons.checkCircle2
                                            : item.action == 'View your Match'
                                                ? LucideIcons.userPlus
                                                : item.action == 'Get Featured'
                                                    ? LucideIcons.plus
                                                    : LucideIcons.userPlus,
                                size: 16,
                                color: primaryColorLT,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item.action,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColorLT,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.action2.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            switch (
                                item.action2.isNotEmpty ? item.action2 : '') {
                              case 'Get Featured':
                                // Go straight to the "enter the challenge" page.
                                enterChallenge();
                                break;
                              case 'View your Match':
                                Get.to(() => const ExpandedMatchesScreen());
                                break;
                              case 'Crowdfund':
                                enterbackeroftheweek();
                                break;
                              case 'Fund Project':
                                Get.to(() => const CreateDonationScreen());
                                break;
                              case 'Become a Partner':
                                enterpartneroftheweek();
                                break;
                              case 'Visit BizCenter':
                                final Uri url =
                                    Uri.parse('https://bizcenter.ai');
                                launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                                break;
                              case 'Share Learning':
                                entermentoroftheweek();
                                break;
                              case 'View Matches':
                                Get.to(() => const ExpandedMatchesScreen());
                                break;
                              default:
                                Get.toNamed(Routes.liveEvents);
                                break;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColorLT,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: proprimaryColor),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  item.action2 == 'View your Match'
                                      ? LucideIcons.user
                                      : (item.action2 == 'View Events'
                                          ? LucideIcons.calendar
                                          : LucideIcons.plus),
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  item.action2.isNotEmpty ? item.action2 : '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(HeroItem item) {
    return GetBuilder<ReachController>(
      builder: (ReachController reachController) {
        final bool hasShop = _profileController.myProfile.hasShop;
        final Map<String, dynamic> data =
            reachController.data ?? <String, dynamic>{};

        String reachScore = '2.1k';
        String aiVisibility = '0%';
        String ranking = 'N/A';
        String opportunity = '0%';

        if (hasShop && data.isNotEmpty) {
          reachScore = _formatValue(data['totalReachPoints'] as num? ?? 0);
          aiVisibility = '${(data['aiVisibilityScore'] as num? ?? 0).toInt()}%';

          // Industry rank first, then global
          final dynamic shopIndustryRank = data['shopIndustryRank'];
          final dynamic indRank = shopIndustryRank?['industryRank'];
          final dynamic globRank = data['globalRank'];

          if (indRank != null && indRank != 0) {
            ranking = '#$indRank';
          } else if (globRank != null && globRank != 0) {
            ranking = '#$globRank';
          } else {
            ranking = 'N/A';
          }

          double aiScore = (data['aiVisibilityScore'] as num? ?? 0).toDouble();
          opportunity = aiScore < 1 ? '75%' : '${(100 - aiScore).toInt()}%';
        } else {
          // 🔥 Use stable random numbers to prevent UI jitter on rebuild
          reachScore = homeController.getStableMetric(
            'reach',
            () =>
                '${1 + (DateTime.now().second % 5)}.${DateTime.now().second % 10}k',
          );
          aiVisibility = homeController.getStableMetric(
            'ai',
            () => '${10 + (DateTime.now().second % 20)}%',
          );
          ranking = homeController.getStableMetric(
            'rank',
            () => '#${50 + (DateTime.now().second % 100)}',
          );
          opportunity = homeController.getStableMetric(
            'opp',
            () => '${30 + (DateTime.now().second % 30)}%',
          );
        }

        return _buildPerformanceCardLayout(
          reachScore: reachScore,
          aiVisibility: aiVisibility,
          ranking: ranking,
          opportunity: opportunity,
          isLoading: reachController.loading.value && data.isEmpty,
        );
      },
    );
  }

  Widget _buildPerformanceCardLayout({
    required String reachScore,
    required String aiVisibility,
    required String ranking,
    required String opportunity,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ReachScreen(user: _profileController.myProfile));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE31E24),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'B',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'My Performance',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.chevronRight,
                      color: Colors.black54, size: 22),
                ],
              ),
              const SizedBox(height: 14),
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE31E24),
                    ),
                  ),
                )
              else ...<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildMetricBox('Reach Score', reachScore),
                    _buildMetricBox('AI Visibility', aiVisibility),
                    _buildMetricBox('Ranking', ranking),
                    _buildMetricBox('Opportunity', opportunity),
                  ],
                ),
                const Spacer(),
              ],
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ReachScreen(
                              user: _profileController.myProfile,
                            ));
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Increase Visibility',
                          style: TextStyle(
                            color: Color(0xFFE31E24),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        final Uri url = Uri.parse('https://bizcenter.ai');
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE31E24),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(LucideIcons.plus,
                                color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text(
                              'Visit BizCenter',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Container(
      width: (Get.width - 80) / 4,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar(HeroItem item, WinnerCardConfig config) {
    if (item.type == 'performance') return const SizedBox();
    if (item.type == 'ai_visibility') {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: config.iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(config.icon, color: config.iconColor, size: 28),
      );
    }
    UserModel? targetUser;
    bool forceRanked = false;
    switch (item.type) {
      case 'boss':
        targetUser = user;
        forceRanked = true;
        break;
      case 'mentor':
        targetUser = mentor;
        break;
      case 'backer':
        targetUser = backer;
        break;
      case 'ranking':
        targetUser = rankWinner;
        forceRanked = true;
        break;
    }

    if (targetUser != null) {
      return UserAvatarWithBadge(
        user: forceRanked ? targetUser.copyWith(isRanked: true) : targetUser,
        height: 50,
        width: 50,
        radius: 50,
        avatarSize: 18,
      );
    }

    if (item.image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: NetworkImageWithPlaceHolder(
          imageUrl: item.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }

    return _buildDefaultAvatar(config, item.subtitle);
  }

  Widget _buildDefaultAvatar(WinnerCardConfig config, String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFFF3F4F6),
            Color(0xFFE5E7EB),
            Color(0xFFD1D5DB),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController controller) {
        user = controller.bossOfTheWeek;
        final HeroItem bossOfTheWeekItem = HeroItem(
          id: '0',
          type: 'boss',
          icon: 'assets/images/app_logo_2.png',
          title: 'Boss of the week',
          subtitle: user?.name ?? user?.username ?? '',
          description: user?.bio ?? '',
          image: user?.photoUrl ?? '',
          action: (user != null &&
                  _profileController.myProfile.connecteds != null &&
                  _profileController.myProfile.connecteds!.contains(user!.uid))
              ? 'Refer'
              : 'Follow',
          action2: 'Get Featured',
        );

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: _buildWinnerCard(bossOfTheWeekItem),
        );
      },
    );
  }

  String _formatValue(num value) {
    if (value >= 1000) {
      double formatted = value / 1000;
      return '${formatted.toStringAsFixed(formatted % 1 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }

  String _calculateStartDate(DateTime startAt) {
    String formattedDate = DateFormat('d MMM').format(startAt);
    return 'Starts $formattedDate';
  }
}
