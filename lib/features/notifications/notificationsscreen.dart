import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/notifications/controller/notification_controller.dart';
import 'package:business_bosses_v2/features/notifications/widgets/nonotificationfoundwidget.dart';
import 'package:business_bosses_v2/features/notifications/widgets/notification_item.dart';
import 'package:business_bosses_v2/features/notifications/widgets/quotewidget.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/time_format.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications-screen';

  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int notificationTS = DateTime.now().millisecondsSinceEpoch;
  late ScrollController _scrollController;
  final bool isLoad = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() async {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (NotificationController controller) {
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
              title: const Text(
                'Notifications',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: controller.loading.value
                ? SafetyModel(
                    isLoading: true,
                    icon: SvgPicture.asset(
                      'assets/svgs/notification.svg',
                      color: iconColor,
                      height: 80.0,
                      width: 80.0,
                    ),
                  )
                : controller.error.value
                    ? SafetyModel(
                        isLoading: true,
                        icon: SvgPicture.asset(
                          'assets/svgs/notification.svg',
                          color: iconColor,
                          height: 80.0,
                          width: 80.0,
                        ),
                        title: 'OOPS! Something went Wrong',
                        subTitle: 'Could not get notifications',
                        clickableText: 'Reload',
                        onTap: controller.loadNotifications,
                      )
                    : NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverStickyHeader(
                              sticky: false,
                              header: Container(
                                color: backgroundcolorinterface,
                                padding: const EdgeInsets.all(8.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: // your child widget(s) go here
                                    QuoteWidget(controller.quote),
                              ),
                            ),
                          ];
                        },
                        body: controller.notifications.isEmpty
                            ? noNotificationsFoundWidget('notifications')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: Text(
                                      'Activity',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      // padding: EdgeInsets.all(8.0),
                                      itemCount:
                                          controller.notifications.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        String formattedDate =
                                            TimeFormat.toDayFormat(controller
                                                .notifications[i].timestamp);

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (i == 0 ||
                                                formattedDate !=
                                                    TimeFormat.toDayFormat(
                                                      controller
                                                          .notifications[i - 1]
                                                          .timestamp,
                                                    ))
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  formattedDate,
                                                  style: bodyText1,
                                                ),
                                              ),
                                            NotificationItem(
                                              controller.notifications[i],
                                              onTap: () {},
                                            )
                                          ],
                                        );
                                      },
                                      separatorBuilder: (_, __) =>
                                          const Divider(
                                              height: 0.0,
                                              indent: 12.0,
                                              endIndent: 12.0),
                                    ),
                                  ),
                                  if (isLoad)
                                    const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                ],
                              ),
                      ));
      },
    );
  }
}
