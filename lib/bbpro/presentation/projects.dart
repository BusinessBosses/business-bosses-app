import 'dart:async';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/customtabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskwidget.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/addproject.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/topsection.dart';

class Projects extends StatefulWidget {
  const Projects({
    super.key,
  });

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>
    with SingleTickerProviderStateMixin {
  final ProjectController projectController = Get.put(ProjectController());
  final Map<ProjectStatus, List<Project>> _projects =
      <ProjectStatus, List<Project>>{};
  final ScrollController _mainListScrollController = ScrollController();
  Timer? _timer;
  bool loading = true;
  bool? _lastMoveRight;
  late TabController _tabController;
  final List<Project> _allProjects = <Project>[];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: ProjectStatus.values.length, vsync: this);

    // Initialize empty lists for each status
    for (ProjectStatus status in ProjectStatus.values) {
      _projects[status] = <Project>[];
    }

    // Initialize projects and load tasks
    projectController
        .initProjects(projectController.profileController.myProfile.uid)
        .then((_) {
      if (!mounted) return; // Ensure the widget is still in the tree

      setState(() {
        for (ProjectStatus status in ProjectStatus.values) {
          List<Project> statusTasks = projectController.projects
              .where((Project project) => project.status == status)
              .toList();
          _projects[status] = statusTasks;
          _allProjects.addAll(statusTasks);
        }
        loading = false;
        projectController.loading.value = false;
      });
    }).catchError((error) {
      // Handle error
      if (mounted) {
        setState(() {
          loading = false;
          projectController.loading.value = false;
        });
      }
      // Log the error or show a dialog/snackbar to the user
      print('Error loading projects: $error');
    });
  }

  void _scrollToSection(int index) {
    final double offset = index * MediaQuery.of(context).size.width * 0.9;
    _mainListScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Projects',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const <Widget>[NotificationButton()],
      ),
      body: Column(
        children: <Widget>[
          TopsectionWidget(
            buttonText: 'Add Project',
            onHowItWorksPressed: () {
              // Handle "How it works" pressed
            },
            onAddProjectPressed: () {
              Get.to(() => const Addproject());
            },
          ),
          CustomTabBarWidget<ProjectStatus>(
            tabController: _tabController,
            scrollToSection: (int index) {
              _scrollToSection(index);
            },
            proprimaryColor: proprimaryColor,
            backgroundColor: backgroundColor,
            listofitems: ProjectStatus.values.toList(),
            itemToString: (ProjectStatus status) =>
                '${status.displayTitle.toString().split('.').last} (${status == ProjectStatus.allprojects ? _allProjects.length : _projects[status]!.length.toString()})',
            filterOptions: const <String>[
              'Newest first',
              'Most Completed',
              'Highest Budget',
              'None'
            ],
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : projectController.projects.isEmpty
                    ? const Center(
                        child: SafetyModel(
                        isLoading: false,
                        title: 'No Projects Found!',
                      ))
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CustomScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _mainListScrollController,
                          slivers: <Widget>[
                            ...ProjectStatus.values.map(
                              (ProjectStatus status) => SliverToBoxAdapter(
                                child: RowStatusCard(
                                  allProjects: _allProjects,
                                  projects: _projects[status] ?? <Project>[],
                                  projectStatus: status,
                                  screenSize: screenSize,
                                  taskAccepted: (Project project,
                                      ProjectStatus newStatus) async {
                                    setState(() {
                                      _projects[project.status]
                                          ?.remove(project);
                                      _projects[newStatus]?.add(
                                        Project(
                                          id: project.id,
                                          userId: project.userId,
                                          name: project.name,
                                          amount: project.amount,
                                          status: newStatus,
                                          createdAt: project.createdAt,
                                          description: project.description,
                                          duration: project.duration,
                                          tasks: project.tasks,
                                        ),
                                      );
                                      projectController.updateProject(
                                          project.id, <String, dynamic>{
                                        'status': newStatus.toString()
                                      });
                                    });
                                  },
                                  onDrag: (bool isRight) {
                                    if (_lastMoveRight == isRight) {
                                      return;
                                    }
                                    _lastMoveRight = isRight;
                                    _moveMainList(isRight);
                                  },
                                  cancelDrag: () {
                                    _lastMoveRight = null;
                                    _timer?.cancel();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _moveMainList(bool isRight) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      if (_mainListScrollController.offset <= 20 && !isRight ||
          _mainListScrollController.offset >
              _mainListScrollController.position.maxScrollExtent) {
        _timer?.cancel();
        return;
      }
      _mainListScrollController.animateTo(
        _mainListScrollController.offset + (isRight ? 50 : -50),
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
      _moveMainList(isRight);
    });
  }
}

class RowStatusCard extends StatefulWidget {
  final void Function(Project task, ProjectStatus newStatus) taskAccepted;
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final ProjectStatus projectStatus;
  final List<Project> projects;
  final Size screenSize;
  final List<Project> allProjects;

  const RowStatusCard({
    required this.projects,
    required this.projectStatus,
    required this.screenSize,
    required this.taskAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
    required this.allProjects,
  });

  @override
  State<RowStatusCard> createState() => _RowStatusCardState();
}

class _RowStatusCardState extends State<RowStatusCard> {
  bool _showSearchBar = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenSize.height * 0.8,
      width: widget.screenSize.width * 0.9,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    widget.projectStatus.index == 0
                        ? Container()
                        : CircleAvatar(
                            backgroundColor: widget
                                        .projectStatus.displayTitle ==
                                    'To Do'
                                ? Colors.black
                                : widget.projectStatus.displayTitle == 'Pending'
                                    ? Colors.amber
                                    : Colors.green,
                            radius: 5,
                          ),
                    if (widget.projectStatus.index != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      widget.projectStatus.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                if (widget.projectStatus.index != 0)
                  const SizedBox(
                    height: 31,
                  ),
                if (widget.projectStatus.index == 0)
                  _showSearchBar
                      ? Expanded(
                          child: SizedBox(
                            height: 31,
                            child: ProSearchbar(
                              contentPadding: 10,
                              backgroundColor: backgroundColor,
                              hasSearchIcon: false,
                              hintText: 'Search',
                              onChange: (String query) {
                                if (query.isEmpty) {}
                              },
                              onSubmit: (String query) {},
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSearchBar =
                                  true; // Show search bar when button is clicked
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/svgs/search.svg',
                              height: 15,
                            ),
                          ),
                        ),
                if (widget.projectStatus.index == 0)
                  if (_showSearchBar)
                    const SizedBox(
                      width: 5,
                    ),
                if (widget.projectStatus.index == 0)
                  if (_showSearchBar)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showSearchBar = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: Colors.black12,
            ),
          ),
          widget.projectStatus.index == 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: widget.allProjects.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskWidget(
                          project: widget.allProjects[index],
                          bgcolor:
                              widget.allProjects[index].status.backgroundColor,
                        ),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: DragTarget<Project>(
                    builder: (BuildContext context,
                        List<Project?> candidateData,
                        List<dynamic> rejectedData) {
                      return ListStatusColumnWidget(
                        projects: widget.projects,
                        projectStatus: widget.projectStatus,
                        screenSize: widget.screenSize,
                        onDrag: widget.onDrag,
                        cancelDrag: widget.cancelDrag,
                      );
                    },
                    onWillAccept: (Project? details) => true,
                    onAcceptWithDetails: (DragTargetDetails<Project> details) {
                      widget.taskAccepted(details.data, widget.projectStatus);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class ListStatusColumnWidget extends StatelessWidget {
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final ProjectStatus projectStatus;
  final List<Project> projects;
  final Size screenSize;

  const ListStatusColumnWidget({
    required this.projects,
    required this.projectStatus,
    required this.screenSize,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: backgroundColor),
                borderRadius: BorderRadius.circular(radius)),
            child: const Center(
              child: Text(
                'Drag a project here',
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final TaskWidget taskWidget = TaskWidget(
          project: projects[index],
          bgcolor: projects[index].status.backgroundColor,
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LongPressDraggable<Project>(
            data: projects[index],
            dragAnchorStrategy: (Draggable<Object> draggable,
                BuildContext context, Offset position) {
              return pointerDragAnchorStrategy(draggable, context, position);
            },
            onDragUpdate: (DragUpdateDetails details) {
              if (details.globalPosition.dx > screenSize.width * 0.8) {
                onDrag(true);
              } else if (details.globalPosition.dx < screenSize.width * 0.2) {
                onDrag(false);
              } else {
                cancelDrag();
              }
            },
            onDragEnd: (_) => cancelDrag(),
            onDragCompleted: () => cancelDrag(),
            onDraggableCanceled: (Velocity velocity, Offset offset) =>
                cancelDrag(),
            childWhenDragging: Opacity(
              opacity: 0.2,
              child: taskWidget,
            ),
            feedback: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.8,
                ),
                child: taskWidget,
              ),
            ),
            child: taskWidget,
          ),
        );
      },
      itemCount: projects.length,
    );
  }
}
