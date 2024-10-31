// ignore_for_file: unnecessary_null_comparison

import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_project.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/projectpopup.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
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
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Expenses: ${shopController.shop!.currency} ',
                          style: const TextStyle(
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
                          widget.project.endAt != null ||
                                  widget.project.startAt != null
                              ? '${widget.project.endAt.difference(widget.project.startAt).inDays} days'
                              : 'N/A',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Description: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor),
                        ),
                        Text(
                          widget.project.description,
                          style:
                              const TextStyle(fontSize: 13, color: textColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                List<ProjectStatus> availableStatuses =
                                    <ProjectStatus>[];
                                switch (widget.project.status) {
                                  case ProjectStatus.todo:
                                    availableStatuses = <ProjectStatus>[
                                      ProjectStatus.pending,
                                      ProjectStatus.completed
                                    ];
                                    break;
                                  case ProjectStatus.pending:
                                    availableStatuses = <ProjectStatus>[
                                      ProjectStatus.todo,
                                      ProjectStatus.completed
                                    ];
                                    break;
                                  case ProjectStatus.completed:
                                    availableStatuses = <ProjectStatus>[
                                      ProjectStatus.todo,
                                      ProjectStatus.pending
                                    ];
                                    break;
                                  case ProjectStatus.allprojects:
                                    // TODO: Handle this case.
                                    break;
                                }
                                return SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 50),
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, // Ensures the column takes only the necessary space
                                      children: <Widget>[
                                        const Text(
                                          'Change Task Status to',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ...availableStatuses
                                            .map((ProjectStatus status) {
                                          return ListTile(
                                            title: Container(
                                              decoration: BoxDecoration(
                                                  color: prosemibackColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 20),
                                              child: Text(
                                                status.displayTitle,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            onTap: () async {
                                              Get.back();
                                              setState(() {
                                                projectController
                                                    .statusProjects[
                                                        widget.project.status]
                                                    ?.remove(widget.project);
                                                projectController
                                                    .statusProjects[status]
                                                    ?.add(
                                                  Project(
                                                    id: widget.project.id,
                                                    userId:
                                                        widget.project.userId,
                                                    name: widget.project.name,
                                                    amount:
                                                        widget.project.amount,
                                                    status: status,
                                                    createdAt: widget
                                                        .project.createdAt,
                                                    startAt:
                                                        widget.project.startAt,
                                                    endAt: widget.project.endAt,
                                                    description: widget
                                                        .project.description,
                                                    duration:
                                                        widget.project.duration,
                                                  ),
                                                );
                                              });

                                              // Update the status in the database
                                              await projectController
                                                  .updateProject(
                                                widget.project.id,
                                                <String, dynamic>{
                                                  'status': status.toString(),
                                                },
                                              );

                                              await projectController
                                                  .initProjects(
                                                      profileController
                                                          .myProfile.uid);
                                            },
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
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
                                          fontSize: 13,
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
      // if (widget.isExpanded != false)
      //   Positioned(
      //     right: 20,
      //     bottom: 10,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: <Widget>[
      //         GestureDetector(
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (BuildContext context) => ProjectPopUp(
      //                 project: widget.project,
      //               ),
      //             );
      //           },
      //           child: CircleAvatar(
      //             backgroundColor: probackgroundColor,
      //             radius: 15,
      //             child: SvgPicture.asset(
      //               'assets/svgs/expandform.svg',
      //               color: proprimaryColor,
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   )
    ]);
  }
}
