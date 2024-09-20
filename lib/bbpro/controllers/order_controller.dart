import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Order> orders = RxList<Order>(<Order>[]);

  Future<void> initOrders(String userId) async {
    orders.clear();
    ApiResponseModel response = await ApiService.get(path: 'orders/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        orders.add(Order.fromJson(response.data['rows'][i]));
      }
    }
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
      orders.add(newClient);
      return true;
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    initOrders(profileController.myProfile.uid);
    super.onInit();
  }
}
