import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  final Color bgcolor;
  final bool? isExpanded;

  const OrderWidget({
    required this.order,
    required this.bgcolor,
    super.key,
    this.isExpanded,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final OrderController orderController = Get.find();
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff4680A6).withAlpha(50), // Border color
            width: 0.5, // Border width
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: widget.bgcolor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/ordersinvoices.svg',
                          height: 13,
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'name and price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ]),
                ),
                OptionsButton(
                  padding: const EdgeInsets.all(0),
                  borderColor: Colors.white,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Client: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.order.user!.name ?? widget.order.user!.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Delivery: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.order.deliveryMethod == 'in_person'
                            ? 'In Person'
                            : 'Online',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Order Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.order.createdAt.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.isExpanded != false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Container(),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: probackgroundColor,
                      radius: 15,
                      child: SvgPicture.asset(
                        'assets/svgs/expandform.svg',
                        color: proprimaryColor,
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  void onEdit() {
    Get.to(() => CreateOrder(
          order: widget.order,
        ));
  }

  void onDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Project',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this order?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await orderController.deleteOrder(widget.order.id);
              if (delete) {
                showSnackbar(message: 'Order deleted successfully!');
              } else {
                showSnackbar(
                  message: 'Error deleting order!',
                  error: true,
                );
              }
              setState(() {});
              Navigator.pop(context);
              orderController.initOrders(profileController.myProfile.uid);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
