import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatefulWidget {
  const CourseItem({super.key});


  @override
   _CourseItemState createState() => _CourseItemState();
  
}

class _CourseItemState extends State<CourseItem> {
  @override
  Widget build(BuildContext context) {
   return Container(
    decoration: const BoxDecoration(
      color: Colors.white
    ),
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Course Title'),
                  Text('Course Description'),
                  Row(
                    children: [
                      Text('by'),
                      Text('Person Name'),
                    ],
                  ),
                
                ],
              ),
            )
          ],
        ),
        Container(
          color: backgroundcolorinterface,
          height: 7,
        )
        
      ],
    ),
   );
  }
}