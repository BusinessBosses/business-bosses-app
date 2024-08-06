import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/multipleedit.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class Addclient extends StatefulWidget {
  const Addclient({super.key});

  @override
  State<Addclient> createState() => _AddclientState();
}

class _AddclientState extends State<Addclient> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          title: Text(
            'Add Client',
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
        body: Stack(children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  CustomEditText(
                    caption: 'Client\'s Name',
                    hintText: 'Enter name here',
                    controller: nameController,
                  ),
                  SizedBox(height: 15),
                  MultipleEditTextWidget(
                    caption: 'Client\'s Email',
                    hintText: 'example@business.com',
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  MultipleEditTextWidget(
                    caption: 'Client\'s Phone number',
                    hintText: '+234 000 000 000',
                    controller: nameController,
                  ),
                  SizedBox(height: 15),
                  CustomDropdownWidget(
                      caption: 'Client Type',
                      items: ['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ProCustomButton(text: 'Save', onPressed: () {}),
            ),
          )
        ]));
  }
}
