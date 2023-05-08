import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../common/models/quote.dart';
import '../../common/widgets/safety_model.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications-screen';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int notificationsTypeIndex = 0;
  bool isLoad = false;
  int notificationTS = DateTime.now().millisecondsSinceEpoch;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() async {});
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
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
      ),
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverStickyHeader(
                sticky: false,
                header: Container(
                    color: backgroundcolorinterface,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: // your child widget(s) go here
                        Container()),
              ),
            ];
          },
          body: noNotificationsFoundWidget('notifications')),
    );
  }
}

Center noNotificationsFoundWidget(String title) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SafetyModel(
            isLoading: false,
            icon: SvgPicture.asset(
              'assets/svgs/notification.svg',
              color: iconColor,
              height: 80.0,
              width: 80.0,
            ),
            title: 'You have no notification',
            subTitle: 'You\'ll receive all new $title here',
          ),
          const SizedBox(height: 150.0)
        ],
      ),
    ),
  );
}
