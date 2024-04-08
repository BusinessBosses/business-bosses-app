import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../common/widgets/user_avatar_with_badge.dart';
import '../../../../utils/theme/theme.dart';

import '../../../common/controllers/comment_controller.dart';
import '../../../services/api_service.dart';
import '../../posts/widgets/comment_item.dart';
import '../../posts/widgets/write_comment.dart';

class SupporterItem extends StatefulWidget {
  const SupporterItem({
    Key? key,
  }) : super(key: key);

  @override
  _SupporterItemState createState() => _SupporterItemState();
}

class _SupporterItemState extends State<SupporterItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Supporters (0)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: '_commentController.comments.isEmpty' != ''
                          ? SafetyModel(
                              isLoading: false,
                              icon: SvgPicture.asset(
                                'assets/svgs/supporter.svg',
                                height: 80.0,
                                color: hintColor,
                              ),
                              title: 'There is no supporter for now',
                              subTitle: 'Be the first one to support!',
                            )
                          : ListView.builder(
                              itemBuilder: (BuildContext context, int i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:15.0, ),
                                  child: Column(
                                    children: [
                                       SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [ SizedBox(
                                              height: 50.0,
                                              width: 50.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child: NetworkImageWithPlaceHolder(
                                                  imageUrl: '',
                                                  radius: radius,
                                                  placeHolder: Icons.person,
                                                  iconSize: 35.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                             Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text('Name', style: TextStyle(fontWeight: FontWeight.w700),),
                                                 Text('Time', style: TextStyle(color: subtextColor),),
                                               ],
                                             ),
                                            
                                        ]),
                                         Text('+200', style: TextStyle(fontWeight: FontWeight.w700),),
                                         
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        color: backgroundColor, height: 1,
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: 5,
                            ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
