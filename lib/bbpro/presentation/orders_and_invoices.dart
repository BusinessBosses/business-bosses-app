import 'dart:async';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/presentation/impact_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_tabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/myorderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool? _lastMoveRight;
  late TabController _mainTabController;
  late TabController _salesTabController;
  final ScrollController _mainListScrollController = ScrollController();
  final ClientsController clientsController = Get.put(ClientsController());
  final OrderController orderController = Get.put(OrderController());
  final MarketController _marketController = Get.put(MarketController());
  final ShopController shopController = Get.find();
  final MatchController _matchController = Get.put(MatchController());
  final ProfileController _profileController = Get.find();

  bool loading = true;
  bool loadingMyOrders = true;
  String myOrdersSearchQuery = '';
  List<Order> filteredMyOrders = <Order>[];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _salesTabController = TabController(length: 4, vsync: this);

    orderController.initOrders(shopController.shop!.id).then((_) {
      setState(() {
        loading = false;
        orderController.loading.value = false;
      });
    });

    _marketController.initOrder().then((_) {
      setState(() {
        loadingMyOrders = false;
        filteredMyOrders = _marketController.orders;
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _salesTabController.dispose();
    super.dispose();
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


  Widget _buildMyOrdersView() {
    return loadingMyOrders
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/search.svg',
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                                hintColor, BlendMode.srcIn),
                          ),
                          Expanded(
                            child: ProSearchbar(
                              contentPadding: 10,
                              hasSearchIcon: false,
                              hintText: 'Search Orders',
                              autofocus: false,
                              onChange: (String query) {
                                setState(() {
                                  myOrdersSearchQuery = query;
                                  filteredMyOrders = _marketController.orders
                                      .where((Order order) => order.user != null
                                          ? order.user!.username
                                              .toLowerCase()
                                              .contains(query.toLowerCase())
                                          : false)
                                      .toList();
                                });
                              },
                              onSubmit: (String query) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredMyOrders.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredMyOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Order order = filteredMyOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: MyOrderWidget(
                              quantity: order.quantity,
                              order: order,
                              bgcolor: order.status.backgroundColor,
                              shop: order.shop,
                              showChange: false,
                              myShop: false,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/ordersinvoices.svg',
                            height: 50,
                            colorFilter: const ColorFilter.mode(
                                Colors.black12, BlendMode.srcIn),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                              'Looks like you haven\'t placed an order yet'),
                          const SizedBox(height: 50),
                          ProshopdealsWidget(
                            caption: 'Recommended',
                            combinedList: _marketController.proItems
                                .where((Object item) {
                                  if (item is Product) {
                                    return item.images != null &&
                                        item.images!.isNotEmpty &&
                                        item.images!.first.isNotEmpty &&
                                        item.user!.isSubscribed;
                                  } else {
                                    return (item as Service).images != null &&
                                        item.images!.isNotEmpty &&
                                        item.images![0].isNotEmpty &&
                                        item.user!.isSubscribed;
                                  }
                                })
                                .take(10)
                                .toList(),
                          ),
                        ],
                      )),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        backgroundColor: probackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Orders & Invoices',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ProIconButton(
              radius: 50,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
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
              padding: const EdgeInsets.only(right: 10.0),
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
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _mainTabController,
          labelColor: Colors.blue,
          unselectedLabelColor: textColor,
          indicatorColor: Colors.blue,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(text: 'My Orders (${_marketController.orders.length})'),
            const Tab(text: 'My Sales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          _buildMyOrdersView(),
          _buildMySalesView(),
        ],
      ),
    );
  }

  Widget _buildMySalesView() {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 10),
        CustomTabBarWidget<OrderStatus>(
          tabController: _salesTabController,
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
                                    (OrderStatus status) => SliverToBoxAdapter(
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
                                              'status': newStatus.toString(),
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
    );
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
                    onWillAcceptWithDetails:
                        (DragTargetDetails<Order> details) => true,
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
