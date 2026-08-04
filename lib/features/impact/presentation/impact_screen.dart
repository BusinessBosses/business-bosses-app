import 'dart:developer';
import 'dart:ui';

import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/common/models/my_connect.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_child_button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/presentation/about_reach_score_screen.dart';
import 'package:business_bosses_v2/features/impact/widgets/impact_header_card.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:business_bosses_v2/features/impact/presentation/leaderboard_screen.dart';
import 'package:business_bosses_v2/features/impact/widgets/ranking_card.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ReachScreen extends StatefulWidget {
  final UserModel user;
  const ReachScreen({super.key, required this.user});

  @override
  State<ReachScreen> createState() => _ReachScreenState();
}

class _ReachScreenState extends State<ReachScreen> {
  late final ReachController controller;
  final ProfileController profileController = Get.find();
  late TooltipBehavior _tooltipBehavior;
  bool loading = false;
  bool error = false;
  final bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _tooltipBehavior = TooltipBehavior(enable: true);
    }
    super.didChangeDependencies();
  }

  List<MyConnect> _connections(
    List<MyConnect> connects, {
    // String statue,
    num? timestamp,
  }) {
    return connects.where((MyConnect element) {
      bool isWithInTime = timestamp == null
          ? true
          : DateTime.now().millisecondsSinceEpoch - element.timestamp! <=
              timestamp;
      return isWithInTime;
    }).toList();
  }

  List<MyConnect> disconnected(
    List<MyConnect> disconnections, {
    // String statue,
    num? timestamp,
  }) {
    return disconnections.where((MyConnect element) {
      bool isWithInTime = timestamp == null
          ? true
          : DateTime.now().millisecondsSinceEpoch - element.timestamp! <=
              timestamp;
      return isWithInTime;
    }).toList();
  }

  int getConnectionValue(double val, num time) {
    return ((_connections(controller.connections, timestamp: time).length) /
            val)
        .round();
  }

  int getConnectedValue(int val, num time) {
    return ((_connections(controller.connecteds,
                    timestamp: TimeFormat.ONE_MONTH)
                .length) /
            val)
        .round();
  }

  int getDisconnectedValue(int val, num time) {
    return ((disconnected(controller.disconnections, timestamp: time).length) /
            val)
        .round();
  }

  @override
  void initState() {
    super.initState();
    // Use existing controller if registered, otherwise create one
    if (Get.isRegistered<ReachController>(tag: widget.user.uid)) {
      controller = Get.find<ReachController>(tag: widget.user.uid);
    } else {
      controller = Get.put(ReachController(), tag: widget.user.uid);
    }

    controller.loadData(widget.user.uid, profileController.myProfile.uid);

    // Only load connections for current user's profile
    if (widget.user.uid == profileController.myProfile.uid) {
      controller.loadConnectionAnalysis(widget.user.uid);
    }
  }

  @override
  void dispose() {
    // Do not delete the controller to prevent issues elsewhere in the app
    super.dispose();
  }

  /// First word of their display name, falling back to the username.
  String _firstName(UserModel user) {
    final String name = (user.name ?? '').trim();
    if (name.isNotEmpty) return name.split(RegExp(r'\s+')).first;
    final String username = user.username.trim();
    return username.isNotEmpty ? username.split(RegExp(r'\s+')).first : 'User';
  }

  @override
  Widget build(BuildContext context) {
    log(widget.user.uid);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Text(
          widget.user.uid == profileController.myProfile.uid
              ? 'My Reach Performance'
              // Someone else's page is titled with their first name.
              : '${_firstName(widget.user)} Reach Score',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          if (widget.user == profileController.myProfile)
            Row(
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(right: 15.0),
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.to(ReachNotificationsScreen());
                //     },
                //     child: CircleAvatar(
                //       radius: 20,
                //       backgroundColor: backgroundColor,
                //       child: Icon(
                //         LucideIcons.bell,
                //         size: 20,
                //         color: textColor,
                //       ), // Invisible icon to maintain size'),
                //     ),
                //   ),
                // ),
                // Explains how the score is earned, rather than the old invite
                // shortcut which had nothing to do with this screen.
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () => Get.to(() => const AboutReachScoreScreen()),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: backgroundColor,
                      child: Icon(
                        LucideIcons.info,
                        size: 20,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const SafetyModel();
        }
        final Map<String, dynamic>? data = controller.data;

        if (data == null) {
          return const SafetyModel();
        }

        final int rank = data['globalRank'] ?? 0;

        final bool isMe = widget.user.uid == profileController.myProfile.uid;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Global Rank Section - shown for all users
              /// Global Rank Section - shown for all users
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Stack(
                  children: <Widget>[
                    // 👇 Original ranking card
                    ReachRankingCard(
                      data: controller.data,
                      rank: rank,
                      industry: widget.user.hasShop
                          ? (data['shop'] as Map<String, dynamic>)['category']
                          : data['user']?['industry'] ?? 'General',
                      location: widget.user.hasShop
                          ? (data['shop'] as Map<String, dynamic>)['location']
                          : data['user']?['location'] ?? 'Global',
                      showShareButton: isMe,
                      isMe: isMe,
                      onViewLeaderboard: () {
                        Get.to(() => const LeaderboardScreen());
                      },
                    ),

                    // 👇 Overlay when user has NO shop
                    if (isMe && !profileController.myProfile.hasShop)
                      Positioned.fill(
                        child: _BizCenterLockedOverlay(
                          isMe: isMe,
                          hasShop: profileController.myProfile.hasShop,
                          onTap: () {
                            // Navigate to BizCenter setup
                            Get.to(() => Setupshop());
                          },
                        ),
                      ),

                    if (!isMe && !widget.user.hasShop)
                      Positioned.fill(
                        child: _BizCenterLockedOverlay(
                          isMe: isMe,
                          hasShop: widget.user.hasShop,
                          onTap: () {
                            // Navigate to BizCenter setup
                            Get.to(() => Setupshop());
                          },
                        ),
                      ),
                  ],
                ),
              ),

              /// Reach Breakdown - shown for all users (Recommended Actions only for self)
              ReachHeaderCard(data: controller.data, isMe: isMe),

              const SizedBox(height: 15),

              /// Network Analytics - only for current user
              if (isMe)
                ExpansionTile(
                  trailing: SvgPicture.asset(
                    'assets/svgs/dropdownexpansion.svg',
                  ),
                  title: RichText(
                    text: const TextSpan(
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Network Analytics',
                            style: TextStyle(color: textColor)),
                      ],
                    ),
                  ),
                  children: <Widget>[
                    GetBuilder<ReachController>(
                      tag: widget.user.uid,
                      builder: (ReachController controller) {
                        if (controller.analysisLoading.value &&
                            controller.connections.isEmpty) {
                          return const SafetyModel();
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 12.0),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Weekly',
                                        style: bodyText1,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CustomChildButton(
                                            value: _connections(
                                                    controller.connections,
                                                    timestamp:
                                                        TimeFormat.ONE_WEEK)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Following',
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomChildButton(
                                            value: _connections(
                                                    controller.connecteds,
                                                    timestamp:
                                                        TimeFormat.ONE_WEEK)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Followers',
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomChildButton(
                                            value: disconnected(
                                                    controller.disconnections,
                                                    timestamp:
                                                        TimeFormat.ONE_WEEK)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Unfollowed',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12.0),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Monthly',
                                        style: bodyText1,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CustomChildButton(
                                            value: _connections(
                                                    controller.connections,
                                                    timestamp:
                                                        TimeFormat.ONE_MONTH)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Following',
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomChildButton(
                                            value: _connections(
                                                    controller.connecteds,
                                                    timestamp:
                                                        TimeFormat.ONE_MONTH)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Followers',
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomChildButton(
                                            value: disconnected(
                                                    controller.disconnections,
                                                    timestamp:
                                                        TimeFormat.ONE_MONTH)
                                                .length,
                                            onPressed: () {},
                                            caption: 'Unfollowed',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SfCartesianChart(
                                        primaryXAxis: CategoryAxis(),
                                        // Chart title
                                        title: ChartTitle(
                                          text: 'Monthly Profile Analysis',
                                        ),
                                        // Enable legend
                                        legend: const Legend(
                                            isVisible: true,
                                            position: LegendPosition.bottom),
                                        // Enable tooltip
                                        tooltipBehavior: _tooltipBehavior,
                                        series: <LineSeries<SalesData, String>>[
                                          LineSeries<SalesData, String>(
                                              name: 'Following',
                                              dataSource: <SalesData>[
                                                SalesData(
                                                    name: 'Mon', value: 0),
                                                SalesData(
                                                    name: 'Tue',
                                                    value: getConnectionValue(8,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Wed',
                                                    value: getConnectionValue(7,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Thu',
                                                    value: getConnectionValue(4,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Fri',
                                                    value: getConnectionValue(2,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sat',
                                                    value: getConnectionValue(
                                                        1.4,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sun',
                                                    value: getConnectionValue(1,
                                                        TimeFormat.ONE_MONTH)),
                                              ],
                                              xValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.name,
                                              yValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.value,
                                              // Enable data label
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                      isVisible: true)),
                                          LineSeries<SalesData, String>(
                                              name: 'Followers',
                                              dataSource: <SalesData>[
                                                SalesData(
                                                    name: 'Mon', value: 0),
                                                SalesData(
                                                    name: 'Tue',
                                                    value: getConnectedValue(8,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Wed',
                                                    value: getConnectedValue(5,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Thu',
                                                    value: getConnectedValue(4,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Fri',
                                                    value: getConnectedValue(3,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sat',
                                                    value: getConnectedValue(2,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sun',
                                                    value: getConnectedValue(1,
                                                        TimeFormat.ONE_MONTH)),
                                              ],
                                              xValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.name,
                                              yValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.value,
                                              // Enable data label
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                      isVisible: true)),
                                          LineSeries<SalesData, String>(
                                              name: 'Unfollowed',
                                              dataSource: <SalesData>[
                                                SalesData(
                                                    name: 'Mon', value: 0),
                                                SalesData(
                                                    name: 'Tue',
                                                    value: getDisconnectedValue(
                                                        10,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Wed',
                                                    value: getDisconnectedValue(
                                                        8,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Thu',
                                                    value: getDisconnectedValue(
                                                        5,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Fri',
                                                    value: getDisconnectedValue(
                                                        3,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sat',
                                                    value: getDisconnectedValue(
                                                        2,
                                                        TimeFormat.ONE_MONTH)),
                                                SalesData(
                                                    name: 'Sun',
                                                    value: getDisconnectedValue(
                                                        1,
                                                        TimeFormat.ONE_MONTH)),
                                              ],
                                              xValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.name,
                                              yValueMapper:
                                                  (SalesData sales, _) =>
                                                      sales.value,
                                              // Enable data label
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                      isVisible: true)),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class SalesData {
  final String name;
  final num value;
  SalesData({required this.name, required this.value});
}

class _BizCenterLockedOverlay extends StatelessWidget {
  final VoidCallback onTap;
  final bool isMe;
  final bool hasShop;

  const _BizCenterLockedOverlay({
    required this.onTap,
    required this.isMe,
    required this.hasShop,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: <Widget>[
          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withValues(alpha: 0.40),
            ),
          ),

          // Content
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: isMe ? onTap : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: (!isMe && hasShop)
                              ? Colors.transparent
                              : primaryColorLT,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            if (isMe && !hasShop)
                              Icon(LucideIcons.lock,
                                  color: Colors.white, size: 24),
                            SizedBox(height: 10),
                            Text(
                              textAlign: TextAlign.center,
                              (!isMe && !hasShop)
                                  ? 'This profile is not yet ranked'
                                  : 'Set up BizCenter',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            if (isMe && !hasShop)
                              Text(
                                'to check your ranking',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const LeaderboardScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColorLT,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/leaderboard.png',
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'View Top Ranking',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: textColor),
                            ),
                            Icon(
                              LucideIcons.chevronRight,
                              size: 18,
                              color: textColor,
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
        ],
      ),
    );
  }
}
