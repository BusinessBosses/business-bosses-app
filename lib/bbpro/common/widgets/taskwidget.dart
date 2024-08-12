import 'package:business_bosses_v2/bbpro/common/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/projects.dart';
import 'package:business_bosses_v2/common/widgets/popup/learningpopup.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/projectpopup.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Color bgcolor;
  final bool? isExpanded;

  const TaskWidget({
    required this.task,
    required this.bgcolor,
    super.key,
    this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff4680A6).withAlpha(50), // Border color
            width: 0.5, // Border width
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3), color: bgcolor),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const OptionsButton(
                  padding: EdgeInsets.all(0),
                  borderColor: Colors.white,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                task.description ?? "description",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (isExpanded != false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const ProjectPopUp(),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: probackgroundColor,
                      radius: 15,
                      child: SvgPicture.asset(
                        'assets/svgs/expandform.svg',
                        color: proprimaryColor,
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
