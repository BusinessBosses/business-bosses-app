import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/edittext.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Create New Order',
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
        body: Stack(children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Client\'s Name',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Choose Order',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Order Channel',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Payment Method',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Client Type',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  const CustomDropdownWidget(
                      caption: 'Delivery Method',
                      items: <String>['Online'],
                      iconName: 'assets/svgs/dropdown.svg'),
                  const SizedBox(height: 15),
                  CustomEditText(
                    caption: 'Notes',
                    hintText: 'Add order notes here',
                    controller: nameController,
                    maxLength: 300,
                  ),
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProCustomButton(text: 'Save', onPressed: () {}),
            ),
          )
        ]));
  }
}
