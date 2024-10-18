import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_project.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/projectpopup.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TaskWidget extends StatefulWidget {
  final Project project;
  final Color bgcolor;
  final bool? isExpanded;

  const TaskWidget({
    required this.project,
    required this.bgcolor,
    super.key,
    this.isExpanded,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final ProjectController projectController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
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
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: widget.bgcolor),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/projects.svg',
                            height: 10,
                            color: textColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.project.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            ' - ${widget.project.status.displayTitle}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ]),
                  ),
                  OptionsButton(
                    onView: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => ProjectPopUp(
                        project: widget.project,
                      ),
                    ),
                    onEdit: () {
                      Get.to(() => Addproject(
                            project: widget.project,
                          ));
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                            'Delete Project',
                            style: bodyText1,
                          ),
                          content: const Text(
                              'Are you sure you want to delete this project?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final bool delete = await projectController
                                    .deleteProject(widget.project.id);
                                if (delete) {
                                  showSnackbar(
                                      message: 'Project deleted successfully!');
                                } else {
                                  showSnackbar(
                                      message: 'Error deleting project!',
                                      error: true);
                                }
                                setState(() {});
                                Get.back();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    isExpanded: widget.isExpanded != false ? true : false,
                    padding: const EdgeInsets.all(0),
                    borderColor: Colors.white,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                          'Expenses: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          widget.project.amount.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Duration: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          widget.project.duration.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              text: TextSpan(
                                children: <InlineSpan>[
                                  const TextSpan(
                                    text: 'Description: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // This keeps the "Description:" normal
                                        fontSize: 10,
                                        color: textColor),
                                  ),
                                  TextSpan(
                                    text: widget.project.description,
                                    style: const TextStyle(
                                        fontSize: 10, color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: prosemibackColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Change Task Status',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: proprimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svgs/dropdown.svg',
                                    color: proprimaryColor,
                                  )
                                ]),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (widget.isExpanded != false)
        Positioned(
          right: 20,
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ProjectPopUp(
                      project: widget.project,
                    ),
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
          ),
        )
    ]);
  }
}
