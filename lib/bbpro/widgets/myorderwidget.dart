import 'package:business_bosses_v2/action/action.dart';
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
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyOrderWidget extends StatefulWidget {
  final Order order;
  final Color bgcolor;
  final bool? isExpanded;
  final bool? myShop;
  final Shop? shop;
  final bool? ismyorderspage;
  final bool showChange;
  final String? sellernotes;
  final int? quantity;

  const MyOrderWidget({
    required this.order,
    required this.bgcolor,
    this.myShop = true,
    super.key,
    this.isExpanded,
    this.shop,
    this.showChange = true,
    this.ismyorderspage,
    this.sellernotes,
    this.quantity,
  });

  @override
  State<MyOrderWidget> createState() => _MyOrderWidgetState();
}

String _formatTime(DateTime time) {
  return DateFormat('hh:mm a').format(time);
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  bool blocked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isExpanded != true) {
          Get.to(() => ExpandedOrders(
                ismyorder: true,
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
                                  colorFilter: const ColorFilter.mode(
                                      textColor, BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (widget.quantity != null)
                                  Text(
                                    '${widget.quantity!.toInt()} ${widget.quantity!.toInt() > 1 ? 'items' : 'item'} - ${widget.shop == null ? shopController.shop!.currency : widget.shop!.currency} ${(calculateTotalPrice() * widget.quantity!).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                if (widget.quantity == null)
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
                          widget.ismyorderspage != null
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              onTap: () {
                                                navigateTo(context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const TextWidget(
                                                      text:
                                                          'Do you want to block user?',
                                                      centralize: true,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      size: 20,
                                                    ),
                                                    content: TextWidget(
                                                      text: blocked == true
                                                          ? 'You will see posts and comments related to user on your feed'
                                                          : 'You will no longer see undefined posts and comments on your feed',
                                                      centralize: true,
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: .6),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            navigateTo(context),
                                                        child: const TextWidget(
                                                          text: 'Cancel',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          size: 18,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          navigateTo(context);
                                                          // print(_post.user.uid);

                                                          // widget
                                                          //     .onBlock(_post.user.uid);
                                                          showSnackBar(context,
                                                              message: blocked ==
                                                                      true
                                                                  ? 'User has been blocked'
                                                                  : 'User has been unblocked');
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 7,
                                                            horizontal: 14,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                primaryColorLT,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: TextWidget(
                                                            text:
                                                                blocked == true
                                                                    ? 'Unblock'
                                                                    : 'Block',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: widget.order.shop.user!
                                                      .isSubscribed
                                                  ? Row(
                                                      children: <Widget>[
                                                        TextWidget(
                                                          text: blocked == true
                                                              ? 'Unblock @${widget.order.shop.user!.name ?? widget.order.shop.user!.username}'
                                                              : 'Block @${widget.order.shop.user!.name ?? widget.order.shop.user!.username}',
                                                          color: Colors.blue,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        SvgPicture.asset(
                                                          'assets/svgs/premiumbadge.svg',
                                                          height: 9,
                                                          colorFilter:
                                                              const ColorFilter
                                                                  .mode(
                                                                  primaryColorLT,
                                                                  BlendMode
                                                                      .srcIn),
                                                        )
                                                      ],
                                                    )
                                                  : TextWidget(
                                                      text: blocked == true
                                                          ? 'Unblock @${widget.order.shop.user!.name ?? widget.order.shop.user!.username}'
                                                          : 'Block @${widget.order.shop.user!.name ?? widget.order.shop.user!.username}',
                                                      color: Colors.blue,
                                                    ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                navigateTo(context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const TextWidget(
                                                      text:
                                                          'Do you want to report user?',
                                                      centralize: true,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      size: 20,
                                                    ),
                                                    content: TextWidget(
                                                      text:
                                                          'The user will be reported to admin to evaluate if it violates any community policy',
                                                      centralize: true,
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: .6),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            navigateTo(context),
                                                        child: const TextWidget(
                                                          text: 'Cancel',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          size: 18,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          navigateTo(context);
                                                          await _reportUser(
                                                              context,
                                                              'accountReport',
                                                              widget.order.shop
                                                                  .user!.uid,
                                                              widget
                                                                  .order
                                                                  .shop
                                                                  .user!
                                                                  .username);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 7,
                                                            horizontal: 14,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                primaryColorLT,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child:
                                                              const TextWidget(
                                                            text: 'Report',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: const TextWidget(
                                                text: 'Report this user',
                                                color: Colors.red,
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                _sharePost();
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: const TextWidget(
                                                text: 'Share this post',
                                                color: Colors.blue,
                                              ),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                if (Get.previousRoute ==
                                                    Routes.publicProfile) {
                                                  Get.back();
                                                } else {
                                                  Get.to(
                                                    () => PublicProfileScreen(
                                                      currentIndex: 1,
                                                    ),
                                                    arguments:
                                                        widget.order.shop.user,
                                                  );
                                                }
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: const TextWidget(
                                                text: 'View Biz-Center',
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: backgroundColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.more_vert,
                                      ),
                                    ),
                                  ),
                                )
                              : OptionsButton(
                                  padding: const EdgeInsets.all(0),
                                  borderColor: Colors.white,
                                  onEdit: onEdit,
                                  onDelete: () async {
                                    final bool delete = await orderController
                                        .deleteOrder(widget.order.id);
                                    if (delete) {
                                      showSnackbar(
                                          message:
                                              'Order deleted successfully!');
                                    } else {
                                      showSnackbar(
                                        message: 'Error deleting order!',
                                        error: true,
                                      );
                                    }

                                    setState(() {});
                                    orderController.initOrders(
                                        profileController.myProfile.uid);
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // if (widget.isExpanded != true)
                              //   Row(
                              //     children: <Widget>[
                              //       const Text(
                              //         'Ordered from',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.normal,
                              //           fontSize: 13,
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         width: 5,
                              //       ),
                              //       Text(
                              //         widget.shop!.name,
                              //         style: const TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 13,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              if (widget.isExpanded != true)
                                Row(
                                  children: <Widget>[
                                    const Text(
                                      'Seller:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.shop!.user!.name ??
                                          widget.shop!.user!.username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.isExpanded == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: backgroundColor, width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        'Seller',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child:
                                                    NetworkImageWithPlaceHolder(
                                                        placeHolder:
                                                            Icons.person,
                                                        imageUrl: widget.shop!
                                                            .user!.photoUrl)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.shop!.user!.name ??
                                                    widget.shop!.user!.username,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () =>
                                                            const ChatRoomScreen(
                                                          frommarketplace:
                                                              false,
                                                        ),
                                                        arguments:
                                                            widget.shop!.user,
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            'assets/svgs/shopchat.svg',
                                                            height: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text('Message')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.publicProfile,
                                                          arguments: widget
                                                              .shop!.user);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SvgPicture.asset(
                                                            'assets/svgs/expandform.svg',
                                                            height: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                              'View Profile')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.isExpanded == true)
                                const SizedBox(
                                  height: 5,
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
                                'Delivery Date: ',
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
                          Row(
                            children: <Widget>[
                              const Text(
                                'Delivery Time: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                (widget.order.startTime != null &&
                                        widget.order.endTime != null)
                                    ? 'From ${_formatTime(widget.order.startTime!)} to ${_formatTime(widget.order.endTime!)} '
                                    : 'N/A',
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
                                  'Seller Notes: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  widget.sellernotes ?? 'N/A',
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
                                      //
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
                                                        user: widget
                                                            .order.shop.user,
                                                        items:
                                                            widget.order.items,
                                                        userId: widget
                                                            .order.shop.userId,
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
                                          }),
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
                                                .withValues(alpha: 1.0),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/dropdown.svg',
                                        colorFilter: ColorFilter.mode(
                                            widget.order.status.backgroundColor
                                                .withValues(alpha: 1.0),
                                            BlendMode.srcIn),
                                      )
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reportUser(BuildContext context, String reportType,
      String userId, String username) async {}

  void _sharePost() {
    String message =
        'Have a look at ${shopController.userShop!.user?.username}\'s biz-center on Business Bosses\n'
        'https://biz-center.io/${shopController.userShop?.name.toLowerCase().replaceAll(' ', '-')}';
    socialShare(message);
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
