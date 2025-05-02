import 'dart:async';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_tabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _tabController;
  final ScrollController _mainListScrollController = ScrollController();
  final ClientsController clientsController = Get.put(ClientsController());
  final OrderController orderController = Get.put(OrderController());
  final ShopController shopController = Get.find();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize tasks
    orderController.initOrders(shopController.shop!.id).then((_) {
      setState(() {
        loading = false;
        orderController.loading.value = false;
      });
    });
  }

  void _scrollToSection(int index) {
    final double offset = index * MediaQuery.of(context).size.width * 0.9;
    _mainListScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Orders',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: ProIconButton(
                    radius: 50,
                    icon: const Icon(Icons.add, color: Colors.white,),
                    onPressed: () {
                      Get.to(() => const CreateOrder());
                    },
                    text: 'Create Order',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ChatScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: prosemibackColor,
                        child: SvgPicture.asset(
                          'assets/svgs/prochat.svg',
                          height: 15,
                        )),
                  ),
                ),
                NotificationButton(
                  hasUnreadNotification:
                      shopController.shop!.user!.unReadCount != null &&
                          shopController.shop!.user!.unReadCount! > 0,
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            CustomTabBarWidget<OrderStatus>(
              tabController: _tabController,
              scrollToSection: (int index) {
                _scrollToSection(index);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: <Color>[
                backgroundColor,
                Colors.amber.withOpacity(0.1),
                Colors.blue.withOpacity(0.1),
                Colors.green.withOpacity(0.1)
              ],
              listofitems: OrderStatus.values.toList(),
              itemToString: (OrderStatus status) =>
                  '${status.displayTitle.toString().split('.').last} (${status == OrderStatus.allorders ? orderController.orders.length : (orderController.ordersStatus[status] == null ? '0' : orderController.ordersStatus[status]!.length.toString())})',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Obx(
                        () => orderController.loading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : orderController.orders.isEmpty
                                ? const Center(
                                    child: SafetyModel(
                                      isLoading: false,
                                      title: 'No Orders Found!',
                                    ),
                                  )
                                : CustomScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _mainListScrollController,
                                    slivers: <Widget>[
                                      ...OrderStatus.values.map(
                                        (OrderStatus status) =>
                                            SliverToBoxAdapter(
                                          child: RowStatusCard(
                                            orders: orderController.orders
                                                .where((Order order) =>
                                                    order.status.displayTitle ==
                                                    status.displayTitle)
                                                .toList(),
                                            orderStatus: status,
                                            screenSize: screenSize,
                                            orderAccepted: (Order order,
                                                OrderStatus newStatus) {
                                              setState(() {
                                                orderController
                                                    .ordersStatus[order.status]
                                                    ?.remove(order);
                                                orderController
                                                    .ordersStatus[newStatus]
                                                    ?.add(
                                                  Order(
                                                    id: order.id,
                                                    user: order.user,
                                                    items: order.items,
                                                    userId: order.userId,
                                                    shopId: order.shopId,
                                                    clientId: order.clientId,
                                                    status: newStatus,
                                                    createdAt: order.createdAt,
                                                    deliveryDate:
                                                        order.deliveryDate,
                                                    deliveryMethod:
                                                        order.deliveryMethod,
                                                    paymentMethod:
                                                        order.paymentMethod,
                                                    notes: order.notes,
                                                    invoiceOption:
                                                        order.invoiceOption,
                                                    client: order.client,
                                                    products: order.products,
                                                    services: order.services,
                                                    orderDetails:
                                                        order.orderDetails,
                                                    shop: order.shop,
                                                  ),
                                                );
                                                orderController.updateOrder(
                                                    order.id, <String, dynamic>{
                                                  'status':
                                                      newStatus.toString(),
                                                });
                                              });
                                            },
                                            onDrag: (bool isRight) {
                                              if (_lastMoveRight == isRight) {
                                                return;
                                              }
                                              _lastMoveRight = isRight;
                                              _moveMainList(isRight);
                                            },
                                            cancelDrag: () {
                                              _lastMoveRight = null;
                                              _timer?.cancel();
                                            },
                                            allorders: orderController.orders,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                      ),
              ),
            ),
          ],
        ));
  }

  void _moveMainList(bool isRight) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      if (_mainListScrollController.offset <= 20 && !isRight ||
          _mainListScrollController.offset >
              _mainListScrollController.position.maxScrollExtent) {
        _timer?.cancel();
        return;
      }
      _mainListScrollController.animateTo(
        _mainListScrollController.offset + (isRight ? 50 : -50),
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
      _moveMainList(isRight);
    });
  }
}

class RowStatusCard extends StatefulWidget {
  final void Function(Order order, OrderStatus newStatus) orderAccepted;
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final OrderStatus orderStatus;
  final List<Order> orders;
  final Size screenSize;
  final List<Order> allorders;

  const RowStatusCard({
    required this.orders,
    required this.orderStatus,
    required this.screenSize,
    required this.orderAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
    required this.allorders,
  });

  @override
  State<RowStatusCard> createState() => _RowStatusCardState();
}

class _RowStatusCardState extends State<RowStatusCard> {
  bool _showSearchBar = false;
  List<Order> filteredOrders = <Order>[];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredOrders.clear();
    filteredOrders = widget.allorders;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenSize.height * 0.8,
      width: widget.screenSize.width * 0.9,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    widget.orderStatus.index == 0
                        ? Container()
                        : CircleAvatar(
                            backgroundColor:
                                widget.orderStatus.displayTitle == 'Pending'
                                    ? Colors.amber
                                    : widget.orderStatus.displayTitle == 'Paid'
                                        ? Colors.blue
                                        : Colors.green,
                            radius: 5,
                          ),
                    if (widget.orderStatus.index != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      widget.orderStatus.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                if (widget.orderStatus.index != 0)
                  const SizedBox(
                    height: 31,
                  ),
                if (widget.orderStatus.index == 0)
                  _showSearchBar
                      ? Expanded(
                          child: SizedBox(
                            height: 31,
                            child: ProSearchbar(
                              contentPadding: 10,
                              backgroundColor: backgroundColor,
                              hasSearchIcon: false,
                              hintText: 'Search',
                              onChange: (String query) {
                                setState(() {
                                  searchQuery =
                                      query; // Update the search query
                                  filteredOrders =
                                      widget.allorders.where((Order order) {
                                    return order.client != null
                                        ? order.client!.name
                                            .toLowerCase()
                                            .contains(query.toLowerCase())
                                        : false;
                                  }).toList();
                                });
                              },
                              onSubmit: (String query) {},
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSearchBar = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/svgs/search.svg',
                              height: 15,
                            ),
                          ),
                        ),
                if (widget.orderStatus.index == 0)
                  if (_showSearchBar)
                    const SizedBox(
                      width: 5,
                    ),
                if (widget.orderStatus.index == 0)
                  if (_showSearchBar)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showSearchBar = false;
                          searchQuery = '';
                          filteredOrders = widget.allorders;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: Colors.black12,
            ),
          ),
          widget.orderStatus.index == 0
              ? filteredOrders.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrders.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OrderWidget(
                              quantity: filteredOrders[index].quantity,
                              order: filteredOrders[index],
                              bgcolor:
                                  filteredOrders[index].status.backgroundColor,
                            ),
                          );
                        },
                      ),
                    )
                  : const Text('No Orders found')
              : Expanded(
                  child: DragTarget<Order>(
                    builder: (BuildContext context, List<Order?> candidateData,
                        List<dynamic> rejectedData) {
                      return ListStatusColumnWidget(
                        orders: widget.orders,
                        orderStatus: widget.orderStatus,
                        screenSize: widget.screenSize,
                        onDrag: widget.onDrag,
                        cancelDrag: widget.cancelDrag,
                      );
                    },
                    onWillAccept: (Order? details) => true,
                    onAcceptWithDetails: (DragTargetDetails<Order> details) {
                      widget.orderAccepted(details.data, widget.orderStatus);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class ListStatusColumnWidget extends StatelessWidget {
  final void Function(bool isRight) onDrag;
  final void Function() cancelDrag;
  final OrderStatus orderStatus;
  final List<Order> orders;
  final Size screenSize;

  const ListStatusColumnWidget({
    required this.orders,
    required this.orderStatus,
    required this.screenSize,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: backgroundColor),
                borderRadius: BorderRadius.circular(radius)),
            child: const Center(
              child: Text(
                'Drag an order here',
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final OrderWidget orderWidget = OrderWidget(
          order: orders[index],
          bgcolor: orders[index].status.backgroundColor,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LongPressDraggable<Order>(
            data: orders[index],
            dragAnchorStrategy: (Draggable<Object> draggable,
                BuildContext context, Offset position) {
              return pointerDragAnchorStrategy(draggable, context, position);
            },
            onDragUpdate: (DragUpdateDetails details) {
              if (details.globalPosition.dx > screenSize.width * 0.8) {
                onDrag(true);
              } else if (details.globalPosition.dx < screenSize.width * 0.2) {
                onDrag(false);
              } else {
                cancelDrag();
              }
            },
            onDragEnd: (_) => cancelDrag(),
            onDragCompleted: () => cancelDrag(),
            onDraggableCanceled: (Velocity velocity, Offset offset) =>
                cancelDrag(),
            childWhenDragging: Opacity(
              opacity: 0.2,
              child: orderWidget,
            ),
            feedback: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.8,
                ),
                child: orderWidget,
              ),
            ),
            child: orderWidget,
          ),
        );
      },
      itemCount: orders.length,
    );
  }
}
