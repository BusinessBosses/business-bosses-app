import 'dart:async';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_learning_posts.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_bossup_screen.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/invitepage/invitepage.dart';
import 'package:business_bosses_v2/features/matching_feature/presentation/expanded_matches_screen.dart';
import 'package:business_bosses_v2/features/partners/presentation/become_a_partner_screen.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
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
  late UserModel? ambassador;
  dynamic partner;
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
      gradientColors: <Color>[backgroundColor, backgroundColor],
      iconColor: Color(0xFFFCD34D),
      accentColor: Color(0x33FBBf24),
    ),
    'backer': WinnerCardConfig(
      title: 'Backer of the Week',
      icon: LucideIcons.dollarSign,
      gradientColors: <Color>[
        Color(0xFFE0F2F1),
        Color(0xFFE0F2F1),
      ],
      iconColor: Color(0xFF6EE7B7),
      accentColor: Color(0x3334D399),
    ),
    'mentor': WinnerCardConfig(
      title: 'Mentor of the Week',
      icon: LucideIcons.graduationCap,
      gradientColors: <Color>[
        Color(0xFFE0F2FE),
        Color(0xFFE0F2FE),
      ],
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
    'ambassador': WinnerCardConfig(
      title: 'Ambassador of the Week',
      icon: LucideIcons.users,
      gradientColors: <Color>[
        Color(0xFFEDE9FE),
        Color(0xFFEDE9FE),
      ],
      iconColor: Color(0xFFC4B5FD),
      accentColor: Color(0x338B5CF6),
    ),
    'matches': WinnerCardConfig(
      title: 'Matches',
      icon: LucideIcons.users,
      gradientColors: <Color>[
        Color(0xFFE0F2FE),
        Color(0xFFE0F2FE),
      ],
      iconColor: Color(0xFF93C5FD),
      accentColor: Color(0x3360A5FA),
    ),
  };

  @override
  void initState() {
    super.initState();
    user = homeController.bossOfTheWeek;
    mentor = homeController.mentorOfTheWeek;
    backer = homeController.backerOfTheWeek;
    ambassador = homeController.ambassadorOfTheWeek;
    partner = homeController.partnerOfTheWeek;
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
          action2: 'Get Featured'),
      HeroItem(
          id: '2',
          type: 'mentor',
          icon: 'assets/images/app_logo_2.png',
          title: 'Mentor of the Week',
          subtitle: mentor?.name ?? mentor!.username,
          image: mentor?.photoUrl ?? '',
          description: mentor?.bio ?? '',
          action: _profileController.myProfile.connecteds!.contains(mentor!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Share Learning'),
      HeroItem(
          id: '3',
          type: 'backer',
          icon: 'assets/images/app_logo_2.png',
          title: 'Backer of the Week',
          subtitle: backer?.name ?? backer!.username,
          image: backer?.photoUrl ?? '',
          description: backer?.bio ?? '',
          action: _profileController.myProfile.connecteds!.contains(backer!.uid)
              ? 'Refer'
              : 'Follow',
          action2: 'Crowdfund'),
      HeroItem(
          id: '4',
          type: 'partner',
          title: 'Partner of the Week',
          icon: 'assets/images/app_logo_2.png',
          subtitle: partner['companyName'] ?? '',
          image: partner['companyPhoto'],
          description: partner['companyDescription'] ?? '',
          action: 'Claim Deal',
          action2: 'Become a Partner'),
      HeroItem(
        id: '5',
        type: 'ambassador',
        title: 'Ambassador of the Week',
        icon: 'assets/images/app_logo_2.png',
        subtitle: ambassador?.name ?? ambassador!.username,
        image: ambassador?.photoUrl ?? '',
        description: ambassador?.bio ?? '',
        action: 'Follow',
        action2: 'Become Ambassador',
      ),
      HeroItem(
        id: '6',
        type: 'matches',
        title: 'Find your business matches',
        icon: 'assets/images/app_logo_2.png',
        subtitle:
            'See your top matches and connect with people and opportunities that can help your business grow.',
        image: '',
        action: 'View Matches',
      ),
    ];
  }

  void _startAutoRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 12), (Timer timer) {
      final Duration timeSinceLast =
          DateTime.now().difference(_lastInteraction);
      if (timeSinceLast.inSeconds >= 12) {
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
    String message =
        'Have a look at ${user?.username}\'s profile on Business Bosses\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16';
    logEvent(user?.uid, 'user');
    socialShare(message);
  }

  void enterbackeroftheweek() {
    Get.to(() => DonationsPage(
          ishome: false,
        ));
  }

  void entermentoroftheweek() {
    Get.to(() => const AllLearningPostsScreen(isCoursesTile: false));
  }

  void enterpartneroftheweek() {
    Get.to(() => BecomeaPartnerScreen());
  }

  void enterambassadoroftheweek() {
    Get.to(Invitepage());
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
              child: Icon(
                config.icon,
                size: 128,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // if (item.icon.isNotEmpty)
                        Image.asset(
                          item.icon,
                          width: 22,
                          height: 22,
                        ),
                        SizedBox(width: item.icon.isNotEmpty ? 4 : 0),
                        Text(
                          config.title,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ),
                // FIXED: Only show user info if not matches card
                if (item.type != 'matches')
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
                        case 'ambassador':
                          targetUser = ambassador;
                          break;
                        case 'partner':
                          partner = homeController.partnerOfTheWeek;
                          break;
                      }

                      if (targetUser != null) {
                        Get.toNamed(Routes.publicProfile,
                            arguments: targetUser);
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
                          if (item.image.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: item.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            _buildDefaultAvatar(config, item.subtitle),
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
                                if (item.type == 'ambassador' &&
                                    item.metrics != null)
                                  Text(
                                    '${item.metrics!['invites']} Invites • ${item.metrics!['conversions']} Conversions',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
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
                // FIXED: For matches card, show description text
                if (item.type == 'matches')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          switch (item.action) {
                            case 'Follow':
                              if (item.type == 'ambassador') {
                                if (ambassador != null) {
                                  final bool isConnected = _profileController
                                              .myProfile.connecteds !=
                                          null &&
                                      _profileController.myProfile.connecteds!
                                          .contains(ambassador!.uid);
                                  if (!isConnected) {
                                    await connect(ambassador!.uid);
                                    _profileController
                                        .updateConnections(ambassador!.uid);
                                  }
                                }
                              } else {
                                connectToUser();
                              }
                              break;
                            case 'Refer':
                              referuser();
                              break;
                            case 'View Matches':
                              Get.to(() => ExpandedMatchesScreen());
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
                                              : item.action == 'View Matches'
                                                  ? LucideIcons.users
                                                  : LucideIcons.userPlus,
                                  size: 16,
                                  color: primaryColorLT),
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
                                item.id == '1'
                                    ? enterChallenge()
                                    : item.id == '2'
                                        ? entermentoroftheweek()
                                        : item.id == '3'
                                            ? enterbackeroftheweek()
                                            : enterpartneroftheweek();
                                break;
                              case 'Crowdfund':
                                enterbackeroftheweek();
                                break;
                              case 'Become a Partner':
                                enterpartneroftheweek();
                                break;
                              case 'Become Ambassador':
                                enterambassadoroftheweek();
                                break;
                              case 'Share Learning':
                                entermentoroftheweek();
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
                                color: primaryColorLT,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: proprimaryColor)),
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
                                      : LucideIcons.plus,
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
                ),
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
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: _onUserInteraction,
            onPanDown: (_) => _onUserInteraction(),
            // FIXED: Changed IntrinsicHeight to SizedBox with fixed height
            child: SizedBox(
              height: 185, // Adjust this height as needed
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

                  // FIXED: Handle matches card click navigation
                  if (item.type == 'matches') {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ExpandedMatchesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _buildWinnerCard(item),
                      ),
                    );
                  }

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
                            Get.to(() => const AllLearningPostsScreen(
                                isCoursesTile: false));
                            break;
                          case 'backer':
                            Get.to(() => DonationsPage(
                                  ishome: false,
                                ));
                            break;
                          case 'partner':
                            Get.to(() => BossUpPartner());
                            break;
                          case 'ambassador':
                            Get.to(Invitepage());
                            break;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _buildWinnerCard(item),
                      ),
                    );
                  }

                  // Original card style for other types (if any)
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
                            if (item.image.isNotEmpty)
                              CachedNetworkImage(
                                key: ValueKey<String>(item.title),
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
                                    Get.to(() => const BossUpPartner());
                                    break;
                                  case 'View Challenges':
                                    Get.toNamed(Routes.allCommunitiesScreen);
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                                  () => const BossUpPartner());
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
                                                Get.to(() =>
                                                    BecomeaPartnerScreen());
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
  String formattedDate = DateFormat('d MMM').format(startAt);
  return 'Starts $formattedDate';
}
