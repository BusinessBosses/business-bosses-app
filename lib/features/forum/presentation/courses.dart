import 'package:business_bosses_v2/navigation/routes.dart';
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
  @override
  Widget build(BuildContext context) {
    return 
    NestedScrollView(
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
                     
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => <Future>{
                                
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        'Info',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/info.svg',
                                        height: 20,
                                      ),
                                    ],
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
                      ],
                    ),
                  )
                ],
              ),
            )
          ];
        },
        body:Container()
      );
  }
}
