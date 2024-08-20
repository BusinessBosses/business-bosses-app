import 'package:business_bosses_v2/bbpro/presentation/pronotificationsettings.dart';
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
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Get.to(ProNotificationSettings());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10),
                child: CircleAvatar(
                  backgroundColor: prosemibackColor,
                  radius: 30, // This sets the circle's radius
                  child: Padding(
                    padding: const EdgeInsets.all(
                        10), // Adjust padding to fit the icon nicely
                    child: SvgPicture.asset(
                      'assets/svgs/settings.svg',
                      height: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: prosemibackColor,
                            radius: 15, // This sets the circle's radius
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Notification Title',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text('Notification Description'),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 75,
                                height: 0.5,
                                color: Colors.black12,
                              )
                            ],
                          )
                        ]));
              },
            ),
          ],
        ));
  }
}
