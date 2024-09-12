import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/home/widgets/course_item.dart';

class CourseList extends StatelessWidget {
  final String industry;

  CourseList({Key? key, required this.industry}) : super(key: key);

  final CourseController courseController = Get.find<CourseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (courseController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (courseController.error.value) {
        return const Center(child: Text('Error loading courses'));
      }

      final List<CourseModel> courses = courseController.courses;

      if (courses.isEmpty) {
        print('Courses list is empty. Industry: $industry');
        print('CourseController state: ${courseController.toString()}');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('No courses available'),
              ElevatedButton(
                onPressed: () {
                  courseController.initCourses();
                },
                child: const Text('Retry loading courses'),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          print('Building course item: ${courses[index].toString()}');
          return CourseItem(course: courses[index]);
        },
      );
    });
  }
}
