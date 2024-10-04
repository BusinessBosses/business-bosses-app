import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/models/task_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/addprojectbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/taskitem.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/iconbutton.dart';

class Addproject extends StatefulWidget {
  final Project? project;
  const Addproject({super.key, this.project});

  @override
  State<Addproject> createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.find();
  final FocusNode _taskNameFocusNode = FocusNode();
  final List<Map<String, dynamic>> tasks = <Map<String, dynamic>>[];
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Request focus when the widget is built
    if (widget.project != null) {
      nameController.text = widget.project!.name;
      descriptionController.text = widget.project!.description;
      budgetController.text = widget.project!.amount.toString();
      if (widget.project!.tasks != null) {
        // ignore: always_specify_types
        tasks.addAll(widget.project!.tasks!.map((Task task) => {
              'name': task.name,
              'amount': task.amount,
              'startAt': task.startAt.toString(),
              'endAt': task.endAt.toString(),
            }));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskNameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  void _showAddTaskSheet(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;
    startDate = DateTime.now();
    endDate = DateTime.now();
    taskNameController.clear();
    expenseController.clear();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddProjectBottomSheet(
          taskNameController: taskNameController,
          expenseController: expenseController,
          startDate: startDate!,
          endDate: endDate!,
          onPressed: () {
            if (startDate!.isAfter(endDate!)) {
              showSnackbar(
                  message: 'Start date cannot be after end date!', error: true);
              return;
            }
            final Map<String, dynamic> task = <String, dynamic>{
              'name': taskNameController.text.trim(),
              'amount': expenseController.text.trim(),
              'startAt': startDate.toString(),
              'endAt': endDate.toString(),
            };

            setState(() {
              tasks.add(task);
            });

            Get.back();
          },
          onStartDateChanged: (DateTime newDate) {
            setState(() {
              startDate = newDate;
            });
          },
          onEndDateChanged: (DateTime newDate) {
            setState(() {
              endDate = newDate;
            });
          },
        );
      },
    );
  }

  _editTaskSheet(BuildContext context, int index) {
    Map<String, dynamic> taskToEdit = tasks[index];

    taskNameController.text = taskToEdit['name'];
    expenseController.text = taskToEdit['amount'];
    DateTime startDate = DateTime.parse(taskToEdit['startAt']);
    DateTime endDate = DateTime.parse(taskToEdit['endAt']);

    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddProjectBottomSheet(
          taskNameController: taskNameController,
          expenseController: expenseController,
          startDate: startDate,
          endDate: endDate,
          onPressed: () {
            if (startDate.isAfter(endDate)) {
              showSnackbar(
                  message: 'Start date cannot be after end date!', error: true);
              return;
            }
            final Map<String, dynamic> updatedTask = <String, dynamic>{
              'name': taskNameController.text.trim(),
              'amount': expenseController.text.trim(),
              'startAt': startDate.toString(),
              'endAt': endDate.toString(),
            };

            // Update the task in the list
            setState(() {
              tasks[index] = updatedTask;
            });

            Get.back();
          },
          onStartDateChanged: (DateTime newDate) {
            setState(() {
              startDate = newDate;
            });
          },
          onEndDateChanged: (DateTime newDate) {
            setState(() {
              endDate = newDate;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.project == null ? 'Add Project' : 'Edit Project',
          style: const TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false, // Used for removing back button.
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                CustomEditText(
                  maxLength: 30,
                  caption: 'Project Name',
                  hintText: 'Enter Project name here',
                  controller: nameController,
                ),
                const SizedBox(height: 15),
                CustomEditText(
                  caption: 'Project Description',
                  hintText: 'Enter Project goals',
                  controller: descriptionController,
                  maxLength: 300,
                ),
                const SizedBox(height: 15),
                CustomEditText(
                  iscurrencyfield: true,
                  caption: 'Project Budget',
                  hintText: '0.00',
                  controller: budgetController,
                  inputType: TextInputType.number,
                ),
                if (tasks.isNotEmpty) const SizedBox(height: 15),
                if (tasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ...tasks
                              .asMap()
                              .entries
                              .map((MapEntry<int, Map<String, dynamic>> entry) {
                            final int index = entry.key;
                            final Map<String, dynamic> task = entry.value;
                            return Taskitem(
                              taskname: task['name'],
                              taskexpense: task['amount'],
                              startdate: task['startAt'],
                              enddate: task['endAt'],
                              editOnTap: () {
                                _editTaskSheet(context, index);
                              },
                              deleteOnTap: () {
                                setState(() {
                                  tasks.removeAt(index);
                                });
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                ProIconButton(
                  backgroundColor: Colors.white,
                  textColor: proprimaryColor,
                  text: 'Add Tasks to project',
                  onPressed: () {
                    _showAddTaskSheet(context);
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                    color: proprimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ProCustomButton(
                    text: 'Save',
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        showSnackbar(
                            message: 'Name is mandatory!', error: true);
                        return;
                      }
                      if (budgetController.text.isEmpty) {
                        showSnackbar(
                            message: 'Budget is mandatory!', error: true);
                        return;
                      }
                      if (descriptionController.text.isEmpty) {
                        showSnackbar(
                            message: 'Budget is mandatory!', error: true);
                        return;
                      }
                      if (tasks.isEmpty) {
                        showSnackbar(
                            message: 'Adding tasks is mandatory!', error: true);
                        return;
                      }
                      final Map<String, dynamic> data = <String, dynamic>{
                        'userId': profileController.myProfile.uid,
                        'name': nameController.text,
                        'amount': budgetController.text,
                        'description': descriptionController.text,
                        'duration': '60days',
                        'tasks': tasks,
                      };
                      final bool response =
                          await projectController.addProject(data);
                      if (response) {
                        showSnackbar(
                          message: 'Project Added Succesfully!',
                        );
                        Get.back();
                        projectController
                            .initTasks(profileController.myProfile.uid);
                      } else {
                        showSnackbar(
                            message: 'Error While Adding Project', error: true);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
