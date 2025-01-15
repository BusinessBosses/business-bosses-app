import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  RxList<Order> orders = RxList<Order>(<Order>[]);
  RxBool loading = RxBool(true);
  RxBool orderLoading = RxBool(true);
  Order? orderView;
  final List<Order> allorders = <Order>[];
  final Map<OrderStatus, List<Order>> ordersStatus =
      <OrderStatus, List<Order>>{};

  Future<void> initOrders(String shopId) async {
    loading(true);
    update();
    orders.clear();
    allorders.clear();
    ApiResponseModel response =
        await ApiService.get(path: 'orders/shop-orders/$shopId');
    if (response.success) {
      // Map and sort orders by createdAt
      orders.addAll((response.data['rows'] as List<dynamic>)
          .map((dynamic order) => Order.fromJson(order))
          .toList()
        ..sort((Order a, Order b) =>
            a.createdAt.compareTo(b.createdAt))); // Newest at the top
    }

    // Initialize ordersStatus map
    for (OrderStatus status in OrderStatus.values) {
      ordersStatus[status] = <Order>[];
    }

    // Group orders by status and populate allorders
    for (OrderStatus status in OrderStatus.values) {
      List<Order> statusOrders =
          orders.where((Order order) => order.status == status).toList();
      ordersStatus[status] = statusOrders;
      allorders.addAll(statusOrders); // Add tasks to alltasks
    }
    loading(false);
    update();
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
      orders.add(
          newClient); // Add to ordersStatus based on the new order's status
      ordersStatus[newClient.status]?.add(newClient);
      allorders.add(newClient); // Add to all orders
      update();
      shopController.loadStatistics();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addOrder(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'orders', body: data);
    if (response.success) {
      // Convert the response data to a Client object and add it to the list
      return true;
    } else {
      print('Error: ${response.message}');
      return false;
    }
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
          orders.add(updatedOrder);
          allorders.add(updatedOrder);
          ordersStatus[updatedOrder.status]?.add(updatedOrder);

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
