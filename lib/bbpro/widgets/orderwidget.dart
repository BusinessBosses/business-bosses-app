import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/presentation/expanded_orders.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  final Color bgcolor;
  final bool? isExpanded;
  final bool? myShop;
  final Shop? shop;
  final bool showChange;

  const OrderWidget({
    required this.order,
    required this.bgcolor,
    this.myShop = true,
    super.key,
    this.isExpanded,
    this.shop,
    this.showChange = true,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.order.deliveryDate);
        if (widget.isExpanded != true) {
          Get.to(() => ExpandedOrders(
                order: widget.order,
                shop: widget.shop,
              ));
        }
      },
      child: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: backgroundcolorinterface),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                                Text(
                                  '${calculateTotalItems().toInt()} ${calculateTotalItems().toInt() > 1 ? 'items' : 'item'} - ${widget.shop == null ? shopController.shop!.currency : widget.shop!.currency} ${calculateTotalPrice().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ]),
                        ),
                        if (widget.myShop!)
                          OptionsButton(
                            padding: const EdgeInsets.all(0),
                            borderColor: Colors.white,
                            onEdit: onEdit,
                            onDelete: () async {
                              final bool delete = await orderController
                                  .deleteOrder(widget.order.id);
                              if (delete) {
                                showSnackbar(
                                    message: 'Order deleted successfully!');
                              } else {
                                showSnackbar(
                                  message: 'Error deleting order!',
                                  error: true,
                                );
                              }

                              setState(() {});
                              orderController
                                  .initOrders(profileController.myProfile.uid);
                            },
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (widget.order.client != null)
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Customer: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.order.client!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          if (widget.order.user != null &&
                              widget.order.client == null)
                            Row(
                              children: <Widget>[
                                const Text(
                                  'User: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.order.user!.name ??
                                      widget.order.user!.username,
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
                                'Order Delivery Date: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(widget.order.deliveryDate ??
                                        widget.order.createdAt)
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     const Text(
                          //       'Order Delivery Time: ',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 13,
                          //       ),
                          //     ),
                          //     Text(
                          //       DateFormat('dd MMM yyyy')
                          //           .format(widget.order.deliveryDate ??
                          //               widget.order.createdAt)
                          //           .toString(),
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 13,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          if (widget.isExpanded == true)
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Order Channel: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.order.deliveryMethod,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          if (widget.isExpanded == true)
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Payment Method: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.order.paymentMethod,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          if (widget.isExpanded == true)
                            Row(
                              children: <Widget>[
                                const Text(
                                  'Notes: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.order.notes ?? 'N/A',
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
                    if (profileController.myProfile.uid == shopUid())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  List<OrderStatus> availableStatuses =
                                      <OrderStatus>[];
                                  switch (widget.order.status) {
                                    case OrderStatus.pending:
                                      availableStatuses = <OrderStatus>[
                                        OrderStatus.paid,
                                        OrderStatus.cancelled
                                      ];
                                      break;
                                    case OrderStatus.paid:
                                      availableStatuses = <OrderStatus>[
                                        OrderStatus.pending,
                                        OrderStatus.cancelled
                                      ];
                                      break;
                                    case OrderStatus.cancelled:
                                      availableStatuses = <OrderStatus>[
                                        OrderStatus.pending,
                                        OrderStatus.paid
                                      ];
                                      break;
                                    case OrderStatus.allorders:
                                      // TODO: Handle this case.
                                      break;
                                  }
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 50),
                                      child: Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // Ensures the column takes only the necessary space
                                        children: <Widget>[
                                          const Text(
                                            'Change Order Status to',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ...availableStatuses
                                              .map((OrderStatus status) {
                                            return ListTile(
                                              title: Container(
                                                decoration: BoxDecoration(
                                                    color: prosemibackColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                child: Text(
                                                  status.displayTitle,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              onTap: () async {
                                                Get.back();
                                                setState(() {
                                                  orderController.ordersStatus[
                                                          widget.order.status]
                                                      ?.remove(widget.order);
                                                  orderController
                                                      .ordersStatus[status]
                                                      ?.add(
                                                    Order(
                                                        id: widget.order.id,
                                                        user: widget.order.user,
                                                        items:
                                                            widget.order.items,
                                                        userId:
                                                            widget.order.userId,
                                                        shopId:
                                                            widget.order.shopId,
                                                        clientId: widget
                                                            .order.clientId,
                                                        status: status,
                                                        createdAt: widget
                                                            .order.createdAt,
                                                        deliveryDate: widget
                                                            .order.deliveryDate,
                                                        deliveryMethod: widget
                                                            .order
                                                            .deliveryMethod,
                                                        paymentMethod: widget
                                                            .order
                                                            .paymentMethod,
                                                        notes:
                                                            widget.order.notes,
                                                        invoiceOption: widget
                                                            .order
                                                            .invoiceOption,
                                                        client:
                                                            widget.order.client,
                                                        products: widget
                                                            .order.products,
                                                        services: widget
                                                            .order.services,
                                                        orderDetails: widget
                                                            .order.orderDetails,
                                                        shop:
                                                            widget.order.shop),
                                                  );
                                                });

                                                // Update the status in the database
                                                await orderController
                                                    .updateOrder(
                                                  widget.order.id,
                                                  <String, dynamic>{
                                                    'status': status.toString(),
                                                  },
                                                );

                                                await orderController
                                                    .initOrders(
                                                        widget.shop == null
                                                            ? shopController
                                                                .shop!.id
                                                            : widget.shop!.id);
                                              },
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: widget.order.status.backgroundColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Status - ${widget.order.status.displayTitle}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: widget
                                                .order.status.backgroundColor
                                                .withOpacity(1.0),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/dropdown.svg',
                                        color: widget
                                            .order.status.backgroundColor
                                            .withOpacity(1.0),
                                      )
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    // if (widget.isExpanded != true)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: <Widget>[
                    //       GestureDetector(
                    //         onTap: () {
                    //           Get.to(() => ExpandedOrders(
                    //                 order: widget.order,
                    //               ));
                    //           // showDialog(
                    //           //   context: context,
                    //           //   builder: (BuildContext context) => OrderPopUp(
                    //           //     order: widget.order,
                    //           //   ),
                    //           // );
                    //         },
                    //         child: CircleAvatar(
                    //           backgroundColor: probackgroundColor,
                    //           radius: 15,
                    //           child: SvgPicture.asset(
                    //             'assets/svgs/expandform.svg',
                    //             color: proprimaryColor,
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  num calculateTotalPrice() {
    return (widget.order.products!
            .fold(0, (num sum, Product product) => sum + product.price)) +
        widget.order.services!
            .fold(0, (num sum, Service product) => sum + product.price);
  }

  num calculateTotalItems() {
    return (widget.order.products!.length) + widget.order.services!.length;
  }

  void onEdit() {
    Get.to(
      () => CreateOrder(
        order: widget.order,
      ),
    );
  }

  String shopUid() {
    return widget.shop == null
        ? shopController.shop!.user!.uid
        : widget.shop!.userId;
  }

//Ernest can you check this why is not working fine
  // void onDelete() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text(
  //         'Delete Project',
  //         style: bodyText1,
  //       ),
  //       content: const Text('Are you sure you want to delete this order?'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             final bool delete =
  //                 await orderController.deleteOrder(widget.order.id);
  //             if (delete) {
  //               showSnackbar(message: 'Order deleted successfully!');
  //             } else {
  //               showSnackbar(
  //                 message: 'Error deleting order!',
  //                 error: true,
  //               );
  //             }
  //             setState(() {});
  //             Navigator.pop(context);
  //             orderController.initOrders(profileController.myProfile.uid);
  //           },
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//lets use this for now but the issues with this also is that the shows the snackbar twice which is not greet at all
  void onDelete() async {
    final bool delete = await orderController.deleteOrder(widget.order.id);
    if (delete) {
      showSnackbar(message: 'Order deleted successfully!');
    } else {
      showSnackbar(
        message: 'Error deleting order!',
        error: true,
      );
    }
  }
}
