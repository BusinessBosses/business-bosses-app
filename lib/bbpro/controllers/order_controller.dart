import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Order> orders = RxList<Order>(<Order>[]);
  RxBool loading = RxBool(true);
  final List<Order> allorders = <Order>[];
  final Map<OrderStatus, List<Order>> ordersStatus =
      <OrderStatus, List<Order>>{};

  Future<void> initOrders(String userId) async {
    orders.clear();
    allorders.clear();
    ApiResponseModel response = await ApiService.get(path: 'orders/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        orders.add(Order.fromJson(response.data['rows'][i]));
      }
    }
    for (OrderStatus status in OrderStatus.values) {
      ordersStatus[status] = <Order>[];
    }
    for (OrderStatus status in OrderStatus.values) {
      List<Order> statusOrders =
          orders.where((Order order) => order.status == status).toList();
      ordersStatus[status] = statusOrders;
      allorders.addAll(statusOrders); // Add tasks to alltasks
    }
    loading(false);
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
      return true;
    } else {
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
      return true;
    } else {
      return false;
    }
  }
}
