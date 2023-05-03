import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var unread = 1;
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          bottomOpacity: 0,
          title: GestureDetector(
            // onTap: () => navigateTo(context,
            //     routeName: CompleteSearchingScreen.routeName,
            //     arguments: [
            //       MySearchTab(
            //         label: 'Users',
            //         widget: const FilterUsers(),
            //       ),
            //       // MySearchTab(
            //       //   label: 'Posts',
            //       //   widget: const FilterPosts(),
            //       // ),
            //     ]),
            child: SizedBox(
              height: 42,
              width: double.infinity,
              child: TextFormField(
                style: const TextStyle(fontSize: 20),
                decoration: inputDecoration.copyWith(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: backgroundcolorinterface,
                  filled: true,
                  enabled: false,
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SvgPicture.asset(
                      'assets/svgs/search.svg',
                      color: hintColor,
                    ),
                  ),
                  hintText: 'Search people',
                ),
              ),
            ),
          ),
          leading: InkWell(
            onTap: () {
              // navigateTo(context, routeName: ChatScreen.routeName);
            },
            child: SizedBox(
              width: 55,
              height: 20,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                spreadRadius: 0.05,
                                blurRadius: 10,
                                blurStyle: BlurStyle.normal),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/svgs/messagewithbackground.svg',
                          // height: 30.0,
                        ),
                      ),
                      if (unread > 0)
                        const Positioned(
                          top: 0,
                          right: -5,
                          child: CircleAvatar(
                            backgroundColor: primaryColorLT,
                            radius: 4,
                            // child: TextWidget(
                            //   text: unread > 9 ? "9+" : unread.toString(),
                            //   color: Colors.white,
                            //   size: 10,
                            // ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface, // ash background color
                        borderRadius:
                            BorderRadius.circular(20), // rounded corners
                      ),
                      child: GestureDetector(
                        // onTap: () => navigateTo(
                        //   context,
                        //   routeName: PromotionScreen.routeName,
                        // ),
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 5, right: 8, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/coin.svg',
                                    height: 22,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  // StreamBuilder(
                                  //   stream: FirebaseDatabase.instance
                                  //       .reference()
                                  //       .child("users/$myUid/coinscount")
                                  //       .onValue,
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasData &&
                                  //         snapshot.data != null) {
                                  //       var data =
                                  //           snapshot.data.snapshot.value;
                                  //       return Text(
                                  //         data.toString(),
                                  //         style: const TextStyle(
                                  //           color: Color.fromRGBO(
                                  //               133, 133, 133, 1),
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.w700,
                                  //         ),
                                  //       );
                                  //     } else if (snapshot.hasError) {
                                  //       return Text(
                                  //           'Error: ${snapshot.error}');
                                  //     } else {
                                  //       return Text(
                                  //         provider.coinsCount.toString(),
                                  //         style: const TextStyle(
                                  //           color: Color.fromRGBO(
                                  //               133, 133, 133, 1),
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.w700,
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: SizedBox(
                      width: 55,
                      height: 55,
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.08),
                                spreadRadius: 0.05,
                                blurRadius: 50,
                                blurStyle: BlurStyle.normal),
                          ],
                        ),
                        // ignore: missing_required_param
                        child: Stack(
                          children: [
                            IconButton(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              icon: SvgPicture.asset(
                                'assets/svgs/topnotification.svg',
                                height: 40,
                              ),
                              onPressed: () {
                                // navigateTo(context,
                                //     routeName: NotificationsScreen.routeName);
                                // MyFirebase firebase = MyFirebase();
                                // firebase.updateNode(
                                //     id: firebase.uid,
                                //     path: Constants.USERS,
                                //     map: MyUser.toReadNotificationMap());
                                // FlutterAppBadger.removeBadge();
                                // appUser.readAllMessage();
                              },
                            ),
                            const Positioned(
                              top: 15,
                              right: 20,
                              child: CircleAvatar(
                                backgroundColor: primaryColorLT,
                                radius: 4,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
          ]),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            //   SliverStickyHeader(
            //     sticky: false,
            //     header: Column(
            //       children: [
            //         Container(
            //           width: double.infinity,
            //           color: const Color.fromRGBO(234, 234, 234, 100),
            //           padding: const EdgeInsets.only(
            //             top: 0.0,
            //             bottom: 0.0,
            //           ),
            //           child: Container(),
            //         ),
            //       ],
            //     ),
            //   ),
            // ];
          ];
        },
        body: Container(),
      ),
    );
  }
}
