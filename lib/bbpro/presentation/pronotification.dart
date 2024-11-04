import 'package:business_bosses_v2/bbpro/presentation/expanded_order_load.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/notifications/controller/notification_controller.dart';
import 'package:business_bosses_v2/features/notifications/models/my_notification.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProNotifications extends StatefulWidget {
  const ProNotifications({super.key});

  @override
  State<ProNotifications> createState() => _ProNotificationsState();
}

class _ProNotificationsState extends State<ProNotifications> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: () {
        //       Get.to(() => const ProNotificationSettings());
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        //       child: CircleAvatar(
        //         backgroundColor: prosemibackColor,
        //         radius: 30, // This sets the circle's radius
        //         child: Padding(
        //           padding: const EdgeInsets.all(
        //               10), // Adjust padding to fit the icon nicely
        //           child: SvgPicture.asset(
        //             'assets/svgs/settings.svg',
        //             height: 20,
        //           ),
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: Obx(
        () => notificationController.loading.value
            ? const SafetyModel(
                isLoading: true,
              )
            : notificationController.ordersNotification.isEmpty
                ? const SafetyModel(
                    title: 'No Notifications Received Yet!',
                    isLoading: false,
                  )
                : Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              notificationController.ordersNotification.length,
                          itemBuilder: (BuildContext context, int index) {
                            final MyNotification notification =
                                notificationController
                                    .ordersNotification[index];
                            return GestureDetector(
                              onTap: () {
                                if (notification.notificationType == 'order') {
                                  Get.to(() => ExpandedOrdersView(
                                      order: notification.dataId!));
                                }
                              },
                              child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: prosemibackColor,
                                          radius:
                                              15, // This sets the circle's radius
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                8), // Adjust padding to fit the icon nicely
                                            child: SvgPicture.asset(
                                              'assets/svgs/notificationicon.svg',
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                notification.title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                notification.message,
                                                overflow: TextOverflow
                                                    .ellipsis, // Adds "..." at the end if text is too long
                                                softWrap:
                                                    true, // Wraps the text if needed
                                                maxLines:
                                                    10, // Limits the number of lines (change the number based on your design)
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    75,
                                                height: 0.5,
                                                color: Colors.black12,
                                              )
                                            ],
                                          ),
                                        )
                                      ])),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
