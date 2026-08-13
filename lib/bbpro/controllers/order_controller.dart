import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrderController extends GetxController {
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  RxList<Order> orders = RxList<Order>(<Order>[]);
  RxBool loading = RxBool(true);
  RxBool loadingMore = RxBool(false);
  RxBool orderLoading = RxBool(true);
  Order? orderView;
  final List<Order> allorders = <Order>[];
  int currentPage = 1;
  bool hasMore = true;
  final Map<OrderStatus, List<Order>> ordersStatus =
      <OrderStatus, List<Order>>{};
  final GetStorage sandBox = GetStorage();

  Future<void> initOrders(String shopId) async {
    currentPage = 1;
    hasMore = true;
    final dynamic cachedOrders = sandBox.read('shop_orders_$shopId');
    if (cachedOrders != null) {
      _processOrdersData(cachedOrders, isRefresh: true);
      loading.value = false;
      update();
    } else {
      loading(true);
    }

    ApiResponseModel response =
        await ApiService.get(path: 'orders/shop-orders/$shopId?page=1&limit=15');
    if (response.success) {
      await sandBox.write('shop_orders_$shopId', response.data);
      _processOrdersData(response.data, isRefresh: true);
    }
    loading(false);
    update();
  }

  Future<void> loadMoreOrders(String shopId) async {
    if (loadingMore.value || !hasMore) return;
    loadingMore(true);
    update();

    int nextPage = currentPage + 1;
    ApiResponseModel response = await ApiService.get(
        path: 'orders/shop-orders/$shopId?page=$nextPage&limit=15');

    if (response.success) {
      List<dynamic> rows = response.data['rows'];
      if (rows.isEmpty) {
        hasMore = false;
      } else {
        currentPage = nextPage;
        _processOrdersData(response.data, isRefresh: false);
      }
    }
    loadingMore(false);
    update();
  }

  void _processOrdersData(dynamic data, {bool isRefresh = false}) {
    if (isRefresh) {
      orders.clear();
      allorders.clear();
      for (OrderStatus status in OrderStatus.values) {
        ordersStatus[status] = <Order>[];
      }
    }

    List<Order> newOrders = (data['rows'] as List<dynamic>)
        .map((dynamic order) => Order.fromJson(order))
        .toList();

    orders.addAll(newOrders);

    // Group orders by status and populate allorders
    for (Order order in newOrders) {
      ordersStatus[order.status]?.add(order);
      allorders.add(order);
    }
  }

  Future<void> loadOrder(String orderId) async {
    orderView = null;
    orderLoading(true);
    update();
    ApiResponseModel response = await ApiService.get(path: 'orders/$orderId');
    if (response.success) {
      orderView = Order.fromJson(response.data);
    }
    orderLoading(false);
    update();
  }

  Future<bool> addOrders(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'orders', body: data);
    if (response.success) {
      // Convert the response data to a Client object and add it to the list
      Order newClient = Order.fromJson(<String, dynamic>{
        'id': response.data['id'],
        ...response.data,
      });
      orders.insert(0,
          newClient); // Add to ordersStatus based on the new order's status
      ordersStatus[newClient.status]?.insert(0, newClient);
      allorders.insert(0, newClient); // Add to all orders
      update();
      shopController.loadStatistics();
      return true;
    } else {
      return false;
    }
  }

  /// Creates an order and returns its id (null on failure).
  Future<String?> addOrder(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'orders', body: data);
    if (response.success) {
      return response.data['id']?.toString();
    }
    return null;
  }

  /// Settles an existing order with coins (escrow-held until delivery).
  /// The backend derives the coin amount server-side; only the orderId is sent.
  Future<ApiResponseModel> payOrderWithCoins(String orderId) async {
    return await ApiService.post(
        path: 'marketplace/purchase',
        body: <String, dynamic>{'orderId': orderId});
  }

  Future<bool> deleteOrder(String id) async {
    ApiResponseModel response = await ApiService.delete(path: 'orders/$id');
    if (response.success) {
      Order? deletedOrder =
          orders.firstWhereOrNull((Order order) => order.id == id);
      orders.removeWhere((Order order) =>
          order.id ==
          id); // Remove from ordersStatus based on the order's status
      ordersStatus[deletedOrder?.status]?.remove(deletedOrder);
      allorders.remove(deletedOrder); // Remove from all orders
      update();
      shopController.loadStatistics();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOrder(String id, Map<String, dynamic> data) async {
    try {
      // 'all orders' is a filter tab, not a status. It reached the API through
      // a `.toString()` on the selected filter and stuck two orders in a state
      // that matches no tab at all, so refuse it at the one choke point every
      // status change goes through.
      if (data['status'] == OrderStatus.allorders.toString()) {
        debugPrint('Refusing to save "all orders" as an order status');
        return false;
      }

      ApiResponseModel response =
          await ApiService.put(path: 'orders/$id', body: data);

      if (response.success) {
        // Locate the existing order by ID
        Order? existingOrder =
            orders.firstWhereOrNull((Order order) => order.id == id);

        if (existingOrder != null) {
          // Remove the order from all lists
          orders.remove(existingOrder);
          allorders.remove(existingOrder);
          ordersStatus[existingOrder.status]?.remove(existingOrder);

          // Create updated order object from response data
          Order updatedOrder = Order.fromJson(response.data);

          // Add the updated order to all lists
          orders.insert(0, updatedOrder);
          allorders.insert(0, updatedOrder);
          ordersStatus[updatedOrder.status]?.insert(0, updatedOrder);

          update(); // Notify listeners
          shopController.loadStatistics();
          return true;
        }
      }
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }
}
