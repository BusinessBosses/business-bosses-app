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
  late TabController _ordersTabController;
  final ScrollController _salesScrollController = ScrollController();
  final ScrollController _ordersScrollController = ScrollController();
  final ClientsController clientsController = Get.put(ClientsController());
  final OrderController orderController = Get.put(OrderController());
  final MarketController _marketController = Get.put(MarketController());
  final ShopController shopController = Get.find();
  final MatchController _matchController = Get.put(MatchController());
  final ProfileController _profileController = Get.find();

  bool loading = true;
  bool loadingMyOrders = true;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _salesTabController = TabController(length: 4, vsync: this);
    _ordersTabController = TabController(length: 4, vsync: this);

    orderController.initOrders(shopController.shop!.id).then((_) {
      setState(() {
        loading = false;
        orderController.loading.value = false;
      });
    });

    _marketController.initOrder().then((_) {
      setState(() {
        loadingMyOrders = false;
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _salesTabController.dispose();
    _ordersTabController.dispose();
    _salesScrollController.dispose();
    _ordersScrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index, ScrollController scrollController) {
    final double offset = index * MediaQuery.of(context).size.width * 0.9;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  Widget _buildMyOrdersView() {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Obx(() => CustomTabBarWidget<OrderStatus>(
              tabController: _ordersTabController,
              scrollToSection: (int index) {
                _scrollToSection(index, _ordersScrollController);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: <Color>[
                backgroundColor,
                Colors.amber.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.1),
                Colors.green.withValues(alpha: 0.1)
              ],
              listofitems: OrderStatus.values.toList(),
              itemToString: (OrderStatus status) {
                String title = status.displayTitle;
                return '$title (${status == OrderStatus.allorders ? _marketController.orders.length : _marketController.orders.where((Order order) => order.status == status).length})';
              },
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: loadingMyOrders
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Obx(() => _marketController.orders.isEmpty
                    ? const Center(
                        child: SafetyModel(
                          isLoading: false,
                          title: 'No Orders Found!',
                        ),
                      )
                    : CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _ordersScrollController,
                        slivers: <Widget>[
                          ...OrderStatus.values.map(
                            (OrderStatus status) => SliverToBoxAdapter(
                              child: Obx(() => RowStatusCard(
                                    orders: _marketController.orders
                                        .where((Order order) =>
                                            order.status == status ||
                                            status == OrderStatus.allorders)
                                        .toList(),
                                    orderStatus: status,
                                    screenSize: screenSize,
                                    isSales: false,
                                    onLoadMore: () {
                                      _marketController.loadMoreMyOrders();
                                    },
                                    orderAccepted:
                                        (Order order, OrderStatus newStatus) {
                                      orderController.updateOrder(
                                          order.id, <String, dynamic>{
                                        'status': newStatus.toString(),
                                      }).then((bool success) {
                                        if (success) {
                                          _marketController.initOrder();
                                        }
                                      });
                                    },
                                    onDrag: (bool isRight) {
                                      if (_lastMoveRight == isRight) {
                                        return;
                                      }
                                      _lastMoveRight = isRight;
                                      _moveMainList(
                                          isRight, _ordersScrollController);
                                    },
                                    cancelDrag: () {
                                      _lastMoveRight = null;
                                      _timer?.cancel();
                                    },
                                    allorders: _marketController.orders,
                                  )),
                            ),
                          )
                        ],
                      )),
          ),
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
        actions: <Widget>[
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
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: <Widget>[
            Obx(() => Tab(text: 'My Sales (${orderController.orders.length})')),
            Obx(() =>
                Tab(text: 'My Orders (${_marketController.orders.length})')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: <Widget>[
          _buildMySalesView(),
          _buildMyOrdersView(),
        ],
      ),
    );
  }

  Widget _buildMySalesView() {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Obx(() => CustomTabBarWidget<OrderStatus>(
              tabController: _salesTabController,
              scrollToSection: (int index) {
                _scrollToSection(index, _salesScrollController);
              },
              proprimaryColor: proprimaryColor,
              backgroundColor: <Color>[
                backgroundColor,
                Colors.amber.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.1),
                Colors.green.withValues(alpha: 0.1)
              ],
              listofitems: OrderStatus.values.toList(),
              itemToString: (OrderStatus status) {
                String title = status.displayTitle;
                if (status == OrderStatus.allorders) {
                  title = 'All Sales';
                }
                return '$title (${status == OrderStatus.allorders ? orderController.orders.length : (orderController.ordersStatus[status] == null ? '0' : orderController.ordersStatus[status]!.length.toString())})';
              },
            )),
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
                                controller: _salesScrollController,
                                slivers: <Widget>[
                                  ...OrderStatus.values.map(
                                    (OrderStatus status) => SliverToBoxAdapter(
                                      child: Obx(() => RowStatusCard(
                                            orders: orderController.orders
                                                .where((Order order) =>
                                                    order.status == status ||
                                                    status ==
                                                        OrderStatus.allorders)
                                                .toList(),
                                            orderStatus: status,
                                            screenSize: screenSize,
                                            isSales: true,
                                            onLoadMore: () {
                                              orderController.loadMoreOrders(
                                                  shopController.shop!.id);
                                            },
                                            orderAccepted: (Order order,
                                                OrderStatus newStatus) {
                                              orderController.updateOrder(
                                                  order.id, <String, dynamic>{
                                                'status': newStatus.toString(),
                                              }).then((bool success) {
                                                if (success) {
                                                  orderController.initOrders(
                                                      shopController.shop!.id);
                                                }
                                              });
                                            },
                                            onDrag: (bool isRight) {
                                              if (_lastMoveRight == isRight) {
                                                return;
                                              }
                                              _lastMoveRight = isRight;
                                              _moveMainList(isRight,
                                                  _salesScrollController);
                                            },
                                            cancelDrag: () {
                                              _lastMoveRight = null;
                                              _timer?.cancel();
                                            },
                                            allorders: orderController.orders,
                                          )),
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

  void _moveMainList(bool isRight, ScrollController scrollController) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      if (scrollController.offset <= 20 && !isRight ||
          scrollController.offset > scrollController.position.maxScrollExtent) {
        _timer?.cancel();
        return;
      }
      scrollController.animateTo(
        scrollController.offset + (isRight ? 50 : -50),
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeIn,
      );
      _moveMainList(isRight, scrollController);
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
  final bool isSales;
  final VoidCallback? onLoadMore;

  const RowStatusCard({
    required this.orders,
    required this.orderStatus,
    required this.screenSize,
    required this.orderAccepted,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
    required this.allorders,
    this.isSales = true,
    this.onLoadMore,
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
    if (searchQuery.isNotEmpty) {
      filteredOrders = widget.allorders.where((Order order) {
        return order.client != null
            ? order.client!.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase())
            : order.user != null
                ? order.user!.username
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())
                : false;
      }).toList();
    } else {
      filteredOrders = widget.allorders;
    }
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
                      widget.orderStatus == OrderStatus.allorders
                          ? (widget.isSales ? 'All Sales' : 'All Orders')
                          : widget.orderStatus.displayTitle,
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
                              hintText: widget.isSales
                                  ? 'Search Sales'
                                  : 'Search Orders',
                              onChange: (String query) {
                                setState(() {
                                  searchQuery =
                                      query; // Update the search query
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
                            child: widget.isSales
                                ? OrderWidget(
                                    quantity: filteredOrders[index].quantity,
                                    order: filteredOrders[index],
                                    bgcolor: filteredOrders[index]
                                        .status
                                        .backgroundColor,
                                  )
                                : MyOrderWidget(
                                    quantity: filteredOrders[index].quantity,
                                    order: filteredOrders[index],
                                    bgcolor: filteredOrders[index]
                                        .status
                                        .backgroundColor,
                                    myShop: false,
                                    shop: filteredOrders[index].shop,
                                    showChange: false,
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
                        isSales: widget.isSales,
                        onLoadMore: widget.onLoadMore,
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
  final bool isSales;
  final VoidCallback? onLoadMore;

  const ListStatusColumnWidget({
    required this.orders,
    required this.orderStatus,
    required this.screenSize,
    required this.onDrag,
    required this.cancelDrag,
    super.key,
    this.isSales = true,
    this.onLoadMore,
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
            child: Center(
              child: Text(
                isSales ? 'Drag a sale here' : 'Drag an order here',
                style: const TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          if (onLoadMore != null) {
            onLoadMore!();
          }
        }
        return false;
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final Widget itemWidget = isSales
              ? OrderWidget(
                  order: orders[index],
                  bgcolor: orders[index].status.backgroundColor,
                )
              : MyOrderWidget(
                  order: orders[index],
                  bgcolor: orders[index].status.backgroundColor,
                  myShop: false,
                  shop: orders[index].shop,
                  showChange: false,
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
                child: itemWidget,
              ),
              feedback: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenSize.width * 0.8,
                  ),
                  child: itemWidget,
                ),
              ),
              child: itemWidget,
            ),
          );
        },
        itemCount: orders.length,
      ),
    );
  }
}
