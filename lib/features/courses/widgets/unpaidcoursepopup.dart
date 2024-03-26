import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class UnpaidCoursePopUp extends StatefulWidget {
    final CourseModel course;

  
  const UnpaidCoursePopUp({Key? key, required this.course}) : super(key: key);

  @override
  State<UnpaidCoursePopUp> createState() => _UnpaidCoursePopUpState();
}

class _UnpaidCoursePopUpState extends State<UnpaidCoursePopUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Dialog(
            backgroundColor: backgroundColor,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal:15,vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.course.title!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.course.description!,
                    style: bodyText2,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      NetworkImageWithPlaceHolder(
                            imageUrl:  widget.course.user!.photoUrl!,
                            radius: 200,
                            width: 25,
                            height: 25,
                            placeHolder: Icons.person,
                            iconSize: 20.0,
                            fit: BoxFit.cover,
                          ),
                      const SizedBox(
                        width: 5,
                      ),
                       Expanded(
                        child: Text(
                          widget.course.user!.name!,
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow
                              .visible, 
                          softWrap:
                              true, 
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockHorizontal * 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Access Denied',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            textAlign: TextAlign.center,
            'Sorry this is a paid course and you currently do not have permissions to view the content.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Buy Course for '),
                  SvgPicture.asset('assets/svgs/coin.svg'),
                  Text('${widget.course.price}')
                ],
              ),
            ))
      ],
    );
  }
}
