import 'package:business_bosses_v2/bbpro/common/widgets/addprojectbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskitem.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskwidget.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/widgets/iconbutton.dart';

class Addproject extends StatefulWidget {
  const Addproject({super.key});

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
  List<Map<String, dynamic>> tasks = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is built
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
    final TextEditingController taskNameController = TextEditingController();
    final TextEditingController expenseController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    startDate = DateTime.now();
    endDate = DateTime.now();
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Project',
          style: TextStyle(
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
                  caption: 'Project Budget',
                  hintText: '\$0.00',
                  controller: budgetController,
                  inputType: TextInputType.number,
                ),
                if (tasks.length > 0) const SizedBox(height: 15),
                if (tasks.length > 0)
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ...tasks.map((Map<String, dynamic> task) {
                            return Taskitem(
                              taskname: task['name'],
                              taskexpense: task['amount'],
                              startdate: task['startAt'],
                              enddate: task['endAt'],
                              editOnTap: () {},
                              deleteOnTap: () {},
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
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProCustomButton(
                text: 'Save',
                onPressed: () async {
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
          )
        ],
      ),
    );
  }
}
