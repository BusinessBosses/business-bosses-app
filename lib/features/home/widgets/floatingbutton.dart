import 'dart:io';

import 'package:business_bosses_v2/features/home/sellProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

class Floatingbutton extends StatelessWidget {
  const Floatingbutton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        // Set a specific height
                        child: ListView.separated(
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                index == 0
                                    ? Get.toNamed(Routes.createPost)
                                    : index == 1
                                        ? sellProduct(context)
                                        : Get.toNamed(Routes.createevent);
                              },
                              minVerticalPadding: 0,
                              contentPadding: const EdgeInsets.only(left: 10),
                              leading: SvgPicture.asset(
                                index == 0
                                    ? 'assets/svgs/text.svg'
                                    : index == 1
                                        ? 'assets/svgs/sellicon.svg'
                                        : 'assets/svgs/liveevent.svg',
                                height: index == 0
                                    ? 25
                                    : index == 1
                                        ? 30
                                        : 22,
                                color: textColor.withOpacity(1),
                              ),
                              title: Text(
                                index == 0
                                    ? 'Create a Post'
                                    : index == 1
                                        ? 'Sell your product & service'
                                        : 'Create a Live Event',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
  padding:  EdgeInsets.only(bottom: Platform.isAndroid ? 90.0 : 50, right: 20),
  child: Align(
    alignment: Alignment.bottomRight,
    child: Container(
      decoration: BoxDecoration(
        color: primaryColorLT,
        borderRadius: BorderRadius.circular(50),
      ),
      width: 50,
      height: 50,
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

    );
  }
}


