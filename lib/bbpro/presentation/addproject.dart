import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

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
          automaticallyImplyLeading: false, // Used for removing back buttoon.
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
            ],
          ),
        ));
  }
}
