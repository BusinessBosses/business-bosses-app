import 'dart:async';
import 'package:business_bosses_v2/bbpro/common/widgets/customtabbar.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskwidget.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/addproject.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../common/widgets/topsection.dart';

class Projects extends StatefulWidget {
  const Projects({
    super.key,
  });

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>
    with SingleTickerProviderStateMixin {
  final ProjectController projectController =
      Get.put(ProjectController()); // Get the instance
  final Map<TaskStatus, List<Task>> _tasks = <TaskStatus, List<Task>>{};
  final ScrollController _mainListScrollController = ScrollController();
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: TaskStatus.values.length , vsync: this);
    for (TaskStatus status in TaskStatus.values) {
      _tasks[status] = <Task>[];
    }
    // Initialize tasks
    projectController
        .initTasks(projectController.profileController.myProfile.uid)
        .then((_) {
      setState(() {
        _tasks.addAll(<TaskStatus, List<Task>>{
          for (TaskStatus status in TaskStatus.values)
            status: projectController.tasks
                .where((Task task) => task.status == status)
                .toList()
        });
      });
    });
  }

  void _scrollToSection(int index) {
    final double offset = index * MediaQuery.of(context).size.width * 0.9;
    _mainListScrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    print(TaskStatus.values.toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 15),
            child: CircleAvatar(
              backgroundColor: prosemibackColor,
              radius: 30, // This sets the circle's radius
              child: Padding(
                padding: const EdgeInsets.all(
                    10), // Adjust padding to fit the icon nicely
                child: SvgPicture.asset(
                  'assets/svgs/notificationicon.svg',
                  height: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          TopsectionWidget(
            buttonText: 'Add Project',
            onHowItWorksPressed: () {
              // Handle "How it works" pressed
            },
            onAddProjectPressed: () {
              // Handle "Add Project" pressed
              Get.to(() => const Addproject());
            },
          ),
          Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: _scrollToSection,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  labelPadding: const EdgeInsets.only(right: 8.0),
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  tabs: TaskStatus.values.map((status) {
                    int index = TaskStatus.values.indexOf(status);
                    return Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: index == 3 ? 40.0 : 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabController.index == index
                                ? proprimaryColor
                                : backgroundColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Text(status.toString() + ' (10000000)'),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
                right: 10,
                top: 0,
                bottom: 10,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: SvgPicture.asset(
                          'assets/svgs/filterprosections.svg')),
                ))
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Obx(
                () {
                  if (projectController.tasks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _mainListScrollController,
                    slivers: <Widget>[
                      ...TaskStatus.values.map(
                        (TaskStatus status) => SliverToBoxAdapter(
                          child: RowStatusCard(
                            tasks: _tasks[status] ?? <Task>[],
                            taskStatus: status,
                            screenSize: screenSize,
                            taskAccepted:
                                (Task task, TaskStatus newStatus) async {
                              projectController.updateTask(
                                  task.id, <String, dynamic>{
                                'status': newStatus.toString()
                              });
                              setState(() {
                                _tasks[task.status]?.remove(task);
                                _tasks[newStatus]?.add(
                                  Task(
                                    id: task.id,
                                    userId: task.userId,
                                    projectId: task.projectId,
                                    name: task.name,
                                    amount: task.amount,
                                    startAt: task.startAt,
                                    endAt: task.endAt,
                                    status: newStatus,
                                    createdAt: task.createdAt,
                                    clientId: task.clientId,
                                    project: task.project,
                                  ),
                                );
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
                  );
                },
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

class RowStatusCard extends StatelessWidget {
  final void Function(Task task, TaskStatus newStatus) taskAccepted;
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final TaskStatus taskStatus;
  final List<Task> tasks;
  final Size screenSize;

  const RowStatusCard({
    required this.tasks,
    required this.taskStatus,
    required this.screenSize,
    required this.taskAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.8,
      width: screenSize.width * 0.9,
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
                    taskStatus.index == 0
                        ? Container()
                        : CircleAvatar(
                            backgroundColor: taskStatus.displayTitle == 'To Do'
                                ? Colors.black
                                : taskStatus.displayTitle == 'Pending'
                                    ? Colors.amber
                                    : Colors.green,
                            radius: 5,
                          ),
                    if (taskStatus.index != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      taskStatus.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/svgs/search.svg',
                      height: 20,
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
          taskStatus.index == 0
              ? Text('All items')
              : Expanded(
                  child: DragTarget<Task>(
                    builder: (BuildContext context, List<Task?> candidateData,
                        List<dynamic> rejectedData) {
                      return ListStatusColumnWidget(
                        tasks: tasks,
                        taskStatus: taskStatus,
                        screenSize: screenSize,
                        onDrag: onDrag,
                        cancelDrag: cancelDrag,
                      );
                    },
                    onWillAccept: (Task? details) => true,
                    onAcceptWithDetails: (DragTargetDetails<Task> details) {
                      taskAccepted(details.data, taskStatus);
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
  final TaskStatus taskStatus;
  final List<Task> tasks;
  final Size screenSize;

  const ListStatusColumnWidget({
    required this.tasks,
    required this.taskStatus,
    required this.screenSize,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
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
          task: tasks[index],
          bgcolor: tasks[index].status.backgroundColor,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Draggable<Task>(
            data: tasks[index],
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
            feedback: SizedBox(
              width: screenSize.width * 0.8,
              child: taskWidget,
            ),
            child: taskWidget,
          ),
        );
      },
      itemCount: tasks.length,
    );
  }
}
