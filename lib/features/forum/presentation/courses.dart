import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/widgets/course_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController scrollController = ScrollController();
  final ProfileController profileController = Get.find();
  late Industry industry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
          return <Widget>[
            SliverStickyHeader(
              sticky: false,
              header: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(children: [
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => <Future>{},
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(20),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 18.0,
                                          top: 6,
                                          bottom: 6),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 35.0,
                                            width: 35.0,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child:
                                                    NetworkImageWithPlaceHolder(
                                                  imageUrl: profileController
                                                          .myProfile.photoUrl ??
                                                      '',
                                                  radius: radius,
                                                  placeHolder: Icons.person,
                                                  iconSize: 22.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // ash background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // rounded corners
                                            ),
                                            child: GestureDetector(
                                              child: Wrap(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            top: 5,
                                                            right: 8,
                                                            bottom: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(Routes
                                                            .promotionscreen);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            'assets/svgs/coin.svg',
                                                            height: 22,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            profileController
                                                                .myProfile
                                                                .coinscount
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      133,
                                                                      133,
                                                                      133,
                                                                      1),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150, 45)),
                                      onPressed: () {
                                        Get.toNamed(Routes.createcourse);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                            'Start a Course',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                              'assets/svgs/startatopic.svg')
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          Positioned(
                            left: 138,
                            top: 10,
                            child: Container(
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add_circle,
                                size: 25,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(children: [
                    Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CachedNetworkImage(
                          imageUrl: industry.photo ??
                              'https://businessbosses.com.ng/learningImages/events.jpg',
                          memCacheHeight: 256,
                          memCacheWidth: 256,
                          placeholder: (BuildContext context, String photo) =>
                              const CircularProgressIndicator(),
                          errorWidget:
                              // ignore: always_specify_types
                              (BuildContext context,
                                      // ignore: always_specify_types
                                      String photo,
                                      Object error) =>
                                  const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Container(
                        height: 160,
                        color: Colors.black.withAlpha(200),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 25, bottom: 15, right: 30),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 86,
                                  width: 142,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: CachedNetworkImage(
                                        imageUrl: industry.photo ??
                                            'https://businessbosses.com.ng/learningImages/events.jpg',
                                        memCacheHeight: 256,
                                        memCacheWidth: 256,
                                        placeholder: (BuildContext context,
                                                String photo) =>
                                            const CircularProgressIndicator(),
                                        errorWidget:
                                            // ignore: always_specify_types
                                            (BuildContext context,
                                                    // ignore: always_specify_types
                                                    String photo,
                                                    Object error) =>
                                                const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Text(
                                  industry.description ??
                                      'Industry Description',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                  softWrap: true,
                                  maxLines: 5,
                                )),
                              ]),
                        )),
                    Positioned(
                        right: 15,
                        top: 10,
                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/svgs/preferences.svg',
                              height: 10,
                            ),
                          ),
                        ))
                  ])
                ],
              ),
            )
          ];
        },
        body: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int i) {
            return const CourseItem();
          }
           ,
        ));
  }
}
