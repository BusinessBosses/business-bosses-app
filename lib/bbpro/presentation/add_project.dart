import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/project_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController currencyController = TextEditingController();
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.find();
  final FocusNode _taskNameFocusNode = FocusNode();
  final List<Map<String, dynamic>> tasks = <Map<String, dynamic>>[];
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  ShopController shopController = Get.find();
  bool isSubmit = false;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is built
    if (widget.project != null) {
      nameController.text = widget.project!.name;
      descriptionController.text = widget.project!.description;
      budgetController.text = widget.project!.amount.toString();
      endDate = widget.project!.endAt;
      startDate = widget.project!.startAt;
      // if (widget.project!.tasks != null) {
      //   // ignore: always_specify_types
      //   tasks.addAll(widget.project!.tasks!.map((Task task) => {
      //         'name': task.name,
      //         'amount': task.amount,
      //         'startAt': task.startAt.toString(),
      //         'endAt': task.endAt.toString(),
      //       }));
      // }
    }

    currencyController.text = shopController.shop?.location != null
        ? '${currencyValues[shopController.shop!.location.toString()]}'
        : 'USD';

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

  // void _showAddTaskSheet(BuildContext context) {
  //   DateTime? startDate;
  //   DateTime? endDate;
  //   startDate = DateTime.now();
  //   endDate = DateTime.now();
  //   taskNameController.clear();
  //   expenseController.clear();
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return AddProjectBottomSheet(
  //         currencyController: currencyController,
  //         taskNameController: taskNameController,
  //         expenseController: expenseController,
  //         startDate: startDate!,
  //         endDate: endDate!,
  //         onPressed: () {
  //           if (startDate!.isAfter(endDate!)) {
  //             showSnackbar(
  //                 message: 'Start date cannot be after end date!', error: true);
  //             return;
  //           }
  //           final Map<String, dynamic> task = <String, dynamic>{
  //             'name': taskNameController.text.trim(),
  //             'amount': currencyController.text + expenseController.text.trim(),
  //             'startAt': startDate.toString(),
  //             'endAt': endDate.toString(),
  //           };

  //           setState(() {
  //             tasks.add(task);
  //           });

  //           Get.back();
  //         },
  //         onStartDateChanged: (DateTime newDate) {
  //           setState(() {
  //             startDate = newDate;
  //           });
  //         },
  //         onEndDateChanged: (DateTime newDate) {
  //           setState(() {
  //             endDate = newDate;
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  // _editTaskSheet(BuildContext context, int index) {
  //   Map<String, dynamic> taskToEdit = tasks[index];

  //   taskNameController.text = taskToEdit['name'];
  //   expenseController.text = taskToEdit['amount'];
  //   DateTime startDate = DateTime.parse(taskToEdit['startAt']);
  //   DateTime endDate = DateTime.parse(taskToEdit['endAt']);

  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return AddProjectBottomSheet(
  //         currencyController: currencyController,
  //         taskNameController: taskNameController,
  //         expenseController: expenseController,
  //         startDate: startDate,
  //         endDate: endDate,
  //         onPressed: () {
  //           if (startDate.isAfter(endDate)) {
  //             showSnackbar(
  //                 message: 'Start date cannot be after end date!', error: true);
  //             return;
  //           }
  //           final Map<String, dynamic> updatedTask = <String, dynamic>{
  //             'name': taskNameController.text.trim(),
  //             'amount': currencyController.text + expenseController.text.trim(),
  //             'startAt': startDate.toString(),
  //             'endAt': endDate.toString(),
  //           };

  //           // Update the task in the list
  //           setState(() {
  //             tasks[index] = updatedTask;
  //           });

  //           Get.back();
  //         },
  //         onStartDateChanged: (DateTime newDate) {
  //           setState(() {
  //             startDate = newDate;
  //           });
  //         },
  //         onEndDateChanged: (DateTime newDate) {
  //           setState(() {
  //             endDate = newDate;
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.project == null ? 'Add Task' : 'Edit Task',
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
                  caption: 'Task Name',
                  hintText: 'Enter Task name here',
                  controller: nameController,
                ),
                const SizedBox(height: 15),
                CustomEditText(
                  caption: 'Task Description',
                  hintText: 'Enter Task goals',
                  controller: descriptionController,
                  maxLength: 300,
                ),
                const SizedBox(height: 15),
                if (widget.project != null)
                  CustomEditText(
                    iscurrencyfield: true,
                    caption: 'Task Expenses',
                    hintText: '0.00',
                    controller: budgetController,
                    inputType: TextInputType.number,
                  ),
                if (widget.project == null)
                  CustomEditText(
                    currencycontroller: currencyController,
                    iscurrencyfield: true,
                    caption: 'Task Expenses',
                    hintText: '0.00',
                    controller: budgetController,
                    inputType: TextInputType.number,
                  ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            // if (picked != null && picked != startDate) {
                            //   setState(() {
                            //     startDate = picked;
                            //   });
                            //   onStartDateChanged(picked);
                            // }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Start Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Start Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            // if (picked != null && picked != endDate) {
                            //   setState(() {
                            //     endDate = picked;
                            //   });
                            //   onEndDateChanged(picked); // Call the callback
                            // }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'End Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'End Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ProCustomButton(
                    loading: isSubmit,
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
                      // if (tasks.isEmpty) {
                      //   showSnackbar(
                      //       message: 'Adding tasks is mandatory!', error: true);
                      //   return;
                      // }
                      setState(() {
                        isSubmit = true;
                      });
                      final Map<String, dynamic> data = <String, dynamic>{
                        'userId': profileController.myProfile.uid,
                        'name': nameController.text,
                        'amount': budgetController.text,
                        'description': descriptionController.text,
                        'duration': '60days',
                        'startAt': DateFormat('yyyy-MM-dd').format(startDate!),
                        'endAt': DateFormat('yyyy-MM-dd').format(endDate!),
                      };

                      final bool response;
                      if (widget.project != null) {
                        response = await projectController.updateProject(
                            widget.project!.id, data);
                      } else {
                        response = await projectController.addProject(data);
                      }
                      if (response) {
                        showSnackbar(
                          message: widget.project != null
                              ? 'Task Updated Successfully!'
                              : 'Task Added Successfully!',
                        );
                        await projectController
                            .initProjects(profileController.myProfile.uid);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {
                        showSnackbar(
                            message: widget.project != null
                                ? 'Error While Editing Task!'
                                : 'Error While Adding Task',
                            error: true);

                        setState(() {
                          isSubmit = false;
                        });
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
