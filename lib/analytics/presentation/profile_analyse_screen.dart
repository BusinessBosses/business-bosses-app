import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../action/action.dart';
import '../../common/models/my_connect.dart';
import '../../common/models/my_user.dart';
import '../../common/params.dart';
import '../../common/widgets/buttons/custom_child_button.dart';
import '../../utils/theme/theme.dart';
import '../../utils/time_format.dart';

class ProfileAnalyseScreen extends StatefulWidget {
  static const String routeName = '/profile-analyse-screen';

  const ProfileAnalyseScreen({Key? key}) : super(key: key);

  @override
  State<ProfileAnalyseScreen> createState() => _ProfileAnalyseScreenState();
}

class _ProfileAnalyseScreenState extends State<ProfileAnalyseScreen> {
  bool _isInit = false;
  late TooltipBehavior _tooltipBehavior;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _tooltipBehavior = TooltipBehavior(enable: true);
      final Params data = ModalRoute.of(context)!.settings.arguments as Params;
      if (data.arg1 == null) navigateTo(context);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController userCtrl = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Analyse Profile',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 20,
            child: ColoredBox(color: backgroundcolorinterface),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Network',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Weekly',
                    style: bodyText1,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomChildButton(
                        value: _connections(userCtrl.myProfile.connections,
                                timestamp: TimeFormat.ONE_WEEK)
                            .length,
                        onPressed: () {},
                        caption: 'Connection',
                      ),
                    ),
                    Expanded(
                      child: CustomChildButton(
                        value: _connections(userCtrl.myProfile.connecteds,
                                timestamp: TimeFormat.ONE_WEEK)
                            .length,
                        onPressed: () {},
                        caption: 'Connected',
                      ),
                    ),
                    Expanded(
                      child: CustomChildButton(
                        value: Disconnected([], timestamp: TimeFormat.ONE_WEEK)
                            .length,
                        onPressed: () {},
                        caption: 'Disconnected',
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
                  children: [
                    Expanded(
                      child: CustomChildButton(
                        value: _connections(userCtrl.myProfile.connections,
                                timestamp: TimeFormat.ONE_MONTH)
                            .length,

                        // value:
                        // _connections(_specificUser,
                        //         statue: Constants.CONNECTION,
                        //         timestamp: TimeFormat.ONE_MONTH)
                        //     .length,
                        onPressed: () {},
                        caption: 'Connection',
                      ),
                    ),
                    Expanded(
                      child: CustomChildButton(
                        value: _connections(userCtrl.myProfile.connecteds,
                                timestamp: TimeFormat.ONE_MONTH)
                            .length,
                        onPressed: () {},
                        caption: 'Connected',
                      ),
                    ),
                    Expanded(
                      child: CustomChildButton(
                        value: Disconnected([], timestamp: TimeFormat.ONE_MONTH)
                            .length,
                        onPressed: () {},
                        caption: 'Disconnected',
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
                      text: 'Monthly Profile Analysis',
                    ),
                    // Enable legend
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    // Enable tooltip
                    tooltipBehavior: _tooltipBehavior,
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                          name: 'Connections',
                          dataSource: <SalesData>[
                            SalesData(name: 'Mon', value: 0),
                            SalesData(
                                name: 'Tue',
                                value: getConnectionValue(
                                    8, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Wed',
                                value: getConnectionValue(
                                    7, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Thu',
                                value: getConnectionValue(
                                    4, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Fri',
                                value: getConnectionValue(
                                    2, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sat',
                                value: getConnectionValue(
                                    1.4, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sun',
                                value: getConnectionValue(
                                    1, TimeFormat.ONE_MONTH)),
                          ],
                          xValueMapper: (SalesData sales, _) => sales.name,
                          yValueMapper: (SalesData sales, _) => sales.value,
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true)),
                      LineSeries<SalesData, String>(
                          name: 'Connected',
                          dataSource: <SalesData>[
                            SalesData(name: 'Mon', value: 0),
                            SalesData(
                                name: 'Tue',
                                value:
                                    getConnectedValue(8, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Wed',
                                value:
                                    getConnectedValue(5, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Thu',
                                value:
                                    getConnectedValue(4, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Fri',
                                value:
                                    getConnectedValue(3, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sat',
                                value:
                                    getConnectedValue(2, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sun',
                                value:
                                    getConnectedValue(1, TimeFormat.ONE_MONTH)),
                          ],
                          xValueMapper: (SalesData sales, _) => sales.name,
                          yValueMapper: (SalesData sales, _) => sales.value,
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true)),
                      LineSeries<SalesData, String>(
                          name: 'Disconnected',
                          dataSource: <SalesData>[
                            SalesData(name: 'Mon', value: 0),
                            SalesData(
                                name: 'Tue',
                                value: getDisconnectedValue(
                                    10, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Wed',
                                value: getDisconnectedValue(
                                    8, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Thu',
                                value: getDisconnectedValue(
                                    5, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Fri',
                                value: getDisconnectedValue(
                                    3, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sat',
                                value: getDisconnectedValue(
                                    2, TimeFormat.ONE_MONTH)),
                            SalesData(
                                name: 'Sun',
                                value: getDisconnectedValue(
                                    1, TimeFormat.ONE_MONTH)),
                          ],
                          xValueMapper: (SalesData sales, _) => sales.name,
                          yValueMapper: (SalesData sales, _) => sales.value,
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true)),
                    ]),
              ],
            ),
          )
        ],
      )),
    );
  }

  List<MyConnect> _connections(
    List<String>? connects, {
    num? timestamp,
  }) {
<<<<<<< HEAD
    List<MyConnect> myConnects = [];
    if (connects != null) {
      myConnects = connects.map((String str) {
        return MyConnect(
          id: str,
          connectedBy: null,
          connectedTo: null,
          timestamp: null,
          status: null,
        );
      }).toList();
    }

    return myConnects.where((MyConnect element) {
      bool isWithinTime = timestamp == null
=======
    return connects.where((MyConnect element) {
      bool isWithInTime = timestamp == null
>>>>>>> test
          ? true
          : DateTime.now().millisecondsSinceEpoch - (element.timestamp ?? 0) <=
              timestamp;
      return isWithinTime;
    }).toList();
  }

  List<Disconnection> Disconnected(
    List<Disconnection> disconnections, {
    // String statue,
    num? timestamp,
  }) {
    return disconnections.where((Disconnection element) {
      bool isWithInTime = timestamp == null
          ? true
          : DateTime.now().millisecondsSinceEpoch - element.timeStamp <=
              timestamp;
      return isWithInTime;
    }).toList();
  }

  int getConnectionValue(double val, num time) {
    final ProfileController userCtrl = Get.find();
    return ((_connections(userCtrl.myProfile.connections, timestamp: time)
                .length) /
            val)
        .round();
  }

  int getConnectedValue(int val, num time) {
    final ProfileController userCtrl = Get.find();
    return ((_connections(userCtrl.myProfile.connecteds,
                    timestamp: TimeFormat.ONE_MONTH)
                .length) /
            val)
        .round();
  }

  int getDisconnectedValue(int val, num time) {
    final ProfileController userCtrl = Get.find();
    return ((Disconnected([], timestamp: time).length) / val).round();
  }
}

class SalesData {
  String name;
  int value;

  SalesData({required this.name, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }

  factory SalesData.fromMap(Map map) {
    return SalesData(
      name: map['name'] as String,
      value: map['value'] as int,
    );
  }
}
