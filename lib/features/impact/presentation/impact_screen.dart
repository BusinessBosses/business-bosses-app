import 'dart:developer';

import 'package:business_bosses_v2/analytics/presentation/profile_analyse_screen.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/my_connect.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_child_button.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/widgets/impact_header_card.dart';
import 'package:business_bosses_v2/features/invitepage/invitepage.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:business_bosses_v2/features/impact/presentation/leaderboard_screen.dart';
import 'package:business_bosses_v2/features/impact/widgets/ranking_card.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../services/api_service.dart';

class ReachScreen extends StatefulWidget {
  final UserModel user;
  const ReachScreen({super.key, required this.user});

  @override
  State<ReachScreen> createState() => _ReachScreenState();
}

class _ReachScreenState extends State<ReachScreen> {
  final ReachController controller = Get.put(ReachController());
  final ProfileController profileController = Get.find();
  late TooltipBehavior _tooltipBehavior;
  bool loading = false;
  bool error = false;
  final List<MyConnect> _myConnections = <MyConnect>[];
  final List<MyConnect> _myConnecteds = <MyConnect>[];
  final List<MyConnect> _disconnections = <MyConnect>[];
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
    return ((_connections(_myConnections, timestamp: time).length) / val)
        .round();
  }

  int getConnectedValue(int val, num time) {
    return ((_connections(_myConnecteds, timestamp: TimeFormat.ONE_MONTH)
                .length) /
            val)
        .round();
  }

  int getDisconnectedValue(int val, num time) {
    return ((disconnected(_disconnections, timestamp: time).length) / val)
        .round();
  }

  @override
  void initState() {
    super.initState();
    controller.loadData(widget.user.uid, profileController.myProfile.uid);
    loadRawConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Reach',
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(Invitepage());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: backgroundColor,
                      child: Icon(
                        LucideIcons.plus,
                        size: 20,
                        color: textColor,
                      ), // Invisible icon to maintain size'),
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
        log(controller.data!.toString());
        final dynamic rank = controller.data!['globalRank'] ?? 12;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Ambassador Challenge Sectionuser
              if (widget.user == profileController.myProfile)
                if (widget.user == profileController.myProfile) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: ReachRankingCard(
                      rank: rank,
                      industry: widget.user.industry ?? 'General',
                      location: widget.user.location ?? 'Global',
                      onViewLeaderboard: () {
                        Get.to(() => const LeaderboardScreen());
                      },
                    ),
                  ),
                  ReachHeaderCard(data: controller.data),
                ],

              const SizedBox(height: 15),

              if (widget.user == profileController.myProfile)
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
                    if (widget.user == profileController.myProfile)
                      loading
                          ? SafetyModel(
                              isLoading: loading,
                            )
                          : error
                              ? SafetyModel(
                                  clickableText: 'Reload',
                                  isLoading: false,
                                  onTap: () async {
                                    loadRawConnections();
                                  },
                                  title: 'There was an error loading data',
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                          _myConnections,
                                                          timestamp: TimeFormat
                                                              .ONE_WEEK)
                                                      .length,
                                                  onPressed: () {},
                                                  caption: 'Following',
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomChildButton(
                                                  value: _connections(
                                                          _myConnecteds,
                                                          timestamp: TimeFormat
                                                              .ONE_WEEK)
                                                      .length,
                                                  onPressed: () {},
                                                  caption: 'Followers',
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomChildButton(
                                                  value: disconnected(
                                                          _disconnections,
                                                          timestamp: TimeFormat
                                                              .ONE_WEEK)
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
                                                          _myConnections,
                                                          timestamp: TimeFormat
                                                              .ONE_MONTH)
                                                      .length,

                                                  // value:
                                                  // _connections(_specificUser,
                                                  //         statue: Constants.CONNECTION,
                                                  //         timestamp: TimeFormat.ONE_MONTH)
                                                  //     .length,
                                                  onPressed: () {},
                                                  caption: 'Following',
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomChildButton(
                                                  value: _connections(
                                                          _myConnecteds,
                                                          timestamp: TimeFormat
                                                              .ONE_MONTH)
                                                      .length,
                                                  onPressed: () {},
                                                  caption: 'Followers',
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomChildButton(
                                                  value: disconnected(
                                                          _disconnections,
                                                          timestamp: TimeFormat
                                                              .ONE_MONTH)
                                                      .length,
                                                  onPressed: () {},
                                                  caption: 'Unfollowed',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SfCartesianChart(
                                              primaryXAxis: CategoryAxis(),
                                              // Chart title
                                              title: ChartTitle(
                                                text:
                                                    'Monthly Profile Analysis',
                                              ),
                                              // Enable legend
                                              legend: const Legend(
                                                  isVisible: true,
                                                  position:
                                                      LegendPosition.bottom),
                                              // Enable tooltip
                                              tooltipBehavior: _tooltipBehavior,
                                              series: <LineSeries<SalesData,
                                                  String>>[
                                                LineSeries<SalesData, String>(
                                                    name: 'Following',
                                                    dataSource: <SalesData>[
                                                      SalesData(
                                                          name: 'Mon',
                                                          value: 0),
                                                      SalesData(
                                                          name: 'Tue',
                                                          value: getConnectionValue(
                                                              8,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Wed',
                                                          value: getConnectionValue(
                                                              7,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Thu',
                                                          value: getConnectionValue(
                                                              4,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Fri',
                                                          value: getConnectionValue(
                                                              2,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sat',
                                                          value: getConnectionValue(
                                                              1.4,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sun',
                                                          value: getConnectionValue(
                                                              1,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
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
                                                          name: 'Mon',
                                                          value: 0),
                                                      SalesData(
                                                          name: 'Tue',
                                                          value: getConnectedValue(
                                                              8,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Wed',
                                                          value: getConnectedValue(
                                                              5,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Thu',
                                                          value: getConnectedValue(
                                                              4,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Fri',
                                                          value: getConnectedValue(
                                                              3,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sat',
                                                          value: getConnectedValue(
                                                              2,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sun',
                                                          value: getConnectedValue(
                                                              1,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
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
                                                          name: 'Mon',
                                                          value: 0),
                                                      SalesData(
                                                          name: 'Tue',
                                                          value: getDisconnectedValue(
                                                              10,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Wed',
                                                          value: getDisconnectedValue(
                                                              8,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Thu',
                                                          value: getDisconnectedValue(
                                                              5,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Fri',
                                                          value: getDisconnectedValue(
                                                              3,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sat',
                                                          value: getDisconnectedValue(
                                                              2,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
                                                      SalesData(
                                                          name: 'Sun',
                                                          value: getDisconnectedValue(
                                                              1,
                                                              TimeFormat
                                                                  .ONE_MONTH)),
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
                                    )
                                  ],
                                )),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }

  // void _shareWithFriends() {
  //   // ignore: unnecessary_null_comparison
  //   if (_referralId == null) return;
  //   String message = 'Check out Business Bosses.\n'
  //       'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
  //       'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
  //       'Invite id: $_referralId';
  //   socialShare(message);
  // }

  Future<void> loadRawConnections() async {
    setState(() {
      loading = true;
      error = false;
    });

    final ApiResponseModel response =
        await ApiService.get(path: 'connection/analysis');
    if (response.success) {
      for (int i = 0; i < response.data['connections'].length; i++) {
        final MyConnect modelizedData =
            MyConnect.fromMap(response.data['connections'][i]);
        _myConnections.add(modelizedData);
      }

      for (int i = 0; i < response.data['connecteds'].length; i++) {
        final MyConnect modelizedData =
            MyConnect.fromMap(response.data['connecteds'][i]);
        _myConnecteds.add(modelizedData);
      }

      for (int i = 0; i < response.data['disconnections'].length; i++) {
        final MyConnect modelizedData =
            MyConnect.fromMap(response.data['disconnections'][i]);
        _disconnections.add(modelizedData);
      }
    } else {
      error = true;
    }

    setState(() {
      loading = false;
    });
  }
}
