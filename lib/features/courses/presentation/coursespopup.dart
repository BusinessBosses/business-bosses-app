import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class CoursesPopup extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const CoursesPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Lottie.asset(
                  'assets/anim/courses.json',
                  height: 80,
                  fit: BoxFit.fill
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Courses',
              textAlign: TextAlign.start,
              style: bodyText1.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
             const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'The course learning feature is a valuable resource for individuals looking to enhance their business knowledge. Whether you\'re a budding entrepreneur seeking business tips, a business owner looking to expand your skills, or simply eager to learn something new, our courses cater to diverse learning needs.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'How it works',
              textAlign: TextAlign.start,
              style: bodyText1.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
           
           
            const SizedBox(
              height: 10,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Create free or paid courses that is relevant to your have expertise in',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Browse list of free or paid courses designed by industry experts and educators to find courses that interests you.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Click on the course card to access detailed information about the course, instructor, and reviews.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Click on the course card to access detailed information about the course, instructor, and reviews.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Complete the enrolment process for paid courses and gain access to the course content.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Work through the course material at your own pace and complete all required modules.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: SizeConfig.safeBlockHorizontal * 3,
            ),
          ],
        ),
      ),
    );
  }
}
