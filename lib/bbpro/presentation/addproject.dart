import 'package:business_bosses_v2/bbpro/common/widgets/addprojectbottomsheet.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/taskitem.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import '../common/widgets/iconbutton.dart';

class Addproject extends StatefulWidget {
  const Addproject({super.key});

  @override
  State<Addproject> createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          title: Text(
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              CustomEditText(
                caption: 'Project Name',
                hintText: 'Enter Project name here',
                controller: nameController,
              ),
              SizedBox(height: 15),
              CustomEditText(
                caption: 'Project Description',
                hintText: 'Enter Project goals',
                controller: nameController,
                maxLength: 300,
              ),
              SizedBox(height: 15),
              CustomEditText(
                caption: 'Project Budget',
                hintText: '\$0.00',
                controller: nameController,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 15),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Taskitem();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ProIconButton(
                text: 'Add Task',
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return AddProjectBottomSheet();
                    },
                  );
                },
                icon: Icon(
                  Icons.add,
                  size: 20,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ));
  }
}
