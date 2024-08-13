import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/controllers/project_conroller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  List<Map<String, dynamic>> tasks = [];

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

    showModalBottomSheet(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomEditText(
                caption: 'Task Name',
                hintText: 'Enter Task name',
                controller: taskNameController,
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _showAddTaskSheet(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_circle_outline_outlined),
                    SizedBox(width: 5),
                    Text('Add Task'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
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
              ProCustomButton(
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
