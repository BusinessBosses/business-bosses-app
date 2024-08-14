import 'package:business_bosses_v2/bbpro/common/widgets/topsection.dart';
import 'package:business_bosses_v2/bbpro/presentation/createorder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Orders & Invoices',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
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
          children: [
            TopsectionWidget(
              buttonText: "Create New Order",
              onHowItWorksPressed: () {
                // Handle "How it works" pressed
                print("How it works pressed");
              },
              onAddProjectPressed: () {
                // Handle "Add Project" pressed
                Get.to(CreateOrder());
              },
            ),
          ],
        ));
  }
}
