import 'dart:async';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/createorder.dart';
import 'package:business_bosses_v2/bbpro/widgets/customtabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/topsection.dart';
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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: ClientType.values.length, vsync: this);

    // Initialize tasks
    orderController
        .initOrders(orderController.profileController.myProfile.uid)
        .then((_) {
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
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Orders',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 15),
              child: CircleAvatar(
                backgroundColor: prosemibackColor,
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(10),
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
          children: <Widget>[
            TopsectionWidget(
              buttonText: 'Create New Order',
              onHowItWorksPressed: () {
                // Handle "How it works" pressed
                print('How it works pressed');
              },
              onAddProjectPressed: () {
                // Handle "Add Project" pressed
                if (clientsController.clients.isEmpty) {
                  showSnackBar(
                    context,
                    message: 'You have to add a client to create order!',
                  );
                  return;
                }
                Get.to(() => const CreateOrder());
              },
            ),
            CustomTabBarWidget<OrderStatus>(
              tabController: _tabController,
              scrollToSection: (int index) {
                _scrollToSection(index);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: backgroundColor,
              listofitems: OrderStatus.values.toList(),
              itemToString: (OrderStatus status) =>
                  '${status.displayTitle.toString().split('.').last} (${status == OrderStatus.allorders ? orderController.orders.length : (orderController.ordersStatus[status] == null ? '0' : orderController.ordersStatus[status]!.length.toString())})',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: loading
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
                                (OrderStatus status) => SliverToBoxAdapter(
                                  child: RowStatusCard(
                                    orders: orderController.orders
                                        .where((Order order) =>
                                            order.status.displayTitle ==
                                            status.displayTitle)
                                        .toList(),
                                    orderStatus: status,
                                    screenSize: screenSize,
                                    orderAccepted:
                                        (Order order, OrderStatus newStatus) {
                                      setState(() {
                                        // Update client status here
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

class RowStatusCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.8,
      width: screenSize.width * 0.9,
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
                    orderStatus.index == 0
                        ? Container()
                        : CircleAvatar(
                            backgroundColor:
                                orderStatus.displayTitle == 'Pending'
                                    ? Colors.amber
                                    : orderStatus.displayTitle == 'Paid'
                                        ? Colors.green
                                        : Colors.red,
                            radius: 5,
                          ),
                    if (orderStatus.index != 0)
                      const SizedBox(
                        width: 10,
                      ),
                    Text(
                      orderStatus.displayTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
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
          orderStatus.index == 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: allorders.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OrderWidget(
                          order: allorders[index],
                          bgcolor: Colors.black,
                        ),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: DragTarget<Order>(
                    builder: (BuildContext context, List<Order?> candidateData,
                        List<dynamic> rejectedData) {
                      return ListStatusColumnWidget(
                        orders: orders,
                        orderStatus: orderStatus,
                        screenSize: screenSize,
                        onDrag: onDrag,
                        cancelDrag: cancelDrag,
                      );
                    },
                    onWillAccept: (Order? details) => true,
                    onAcceptWithDetails: (DragTargetDetails<Order> details) {
                      orderAccepted(details.data, orderStatus);
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
          bgcolor: Colors.black,
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
            feedback: SizedBox(
              width: screenSize.width * 0.8,
              child: orderWidget,
            ),
            child: orderWidget,
          ),
        );
      },
      itemCount: orders.length,
    );
  }
}
