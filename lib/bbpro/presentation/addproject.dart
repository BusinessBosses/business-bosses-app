import 'package:business_bosses_v2/bbpro/common/widgets/addprojectbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskitem.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_conroller.dart';
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
  final _formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.find();
  FocusNode _taskNameFocusNode = FocusNode();
  List<Map<String, dynamic>> tasks = [];

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
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
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      focusNode: _taskNameFocusNode, // Attach the FocusNode
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: 'Write task here...',
                        filled: false,
                        fillColor: Colors.grey.shade100,
                      ),
                      maxLength: 50,
                      controller: taskNameController,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomEditText(
                    caption: 'Expense',
                    hintText: '\$0.00',
                    controller: expenseController,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            startDate = await _selectDate(context, startDate);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(startDate!)
                                  : 'Start Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            endDate = await _selectDate(context, endDate);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(endDate!)
                                  : 'End Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final Map<String, dynamic> task = <String, dynamic>{
                        'name': taskNameController.text.trim(),
                        'amount': expenseController.text.trim(),
                        'startAt': startDate,
                        'endAt': endDate,
                      };

                      setState(() {
                        tasks.add(task);
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    startDate = DateTime.now();
    endDate = DateTime.now();
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
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ...tasks.map((Map<String, dynamic> task) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(task['taskName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Expense: \$${task['expense']}'),
                                  Text(
                                      'Start Date: ${DateFormat('yyyy-MM-dd').format(task['startDate'])}'),
                                  Text(
                                      'End Date: ${DateFormat('yyyy-MM-dd').format(task['endDate'])}'),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   itemCount: 2,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Taskitem();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ProIconButton(
                  backgroundColor: Colors.white,
                  textColor: proprimaryColor,
                  text: 'Add Task',
                  onPressed: () {
                    // _showAddTaskSheet(context);
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                              'startAt': startDate,
                              'endAt': endDate,
                            };

                            setState(() {
                              tasks.add(task);
                            });

                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(
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
            child: Container(
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
                    } else {
                      showSnackbar(message: 'Error While Adding Project');
                    }
                  }),
            ),
          )
        ]));
  }
}
