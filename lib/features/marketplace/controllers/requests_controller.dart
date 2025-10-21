import 'package:get/get.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import '../models/buyer_request_model.dart';

class BuyerRequestController extends GetxController {
  final RxList<BuyerRequestModel> buyerRequests = <BuyerRequestModel>[].obs;
  final RxBool loading = false.obs;
  final RxBool error = false.obs;
  final RxBool loadingMore = false.obs;

  final ProfileController _profileController = Get.find();

  /// Initialize and fetch all buyer requests
  Future<void> initBuyerRequests() async {
    buyerRequests.clear();
    loading(true);
    error(false);
    update();

    final ApiResponseModel response =
        await ApiService.get(path: 'buyer-request');

    if (response.success) {
      processRequestsToState(response.data);
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  /// Process fetched buyer requests into state
  void processRequestsToState(List<dynamic> rows) {
    for (dynamic item in rows) {
      buyerRequests.add(BuyerRequestModel.fromJson(item));
    }
  }

  /// Add a new buyer request
  Future<void> addBuyerRequest(Map<String, dynamic> body) async {
    loading(true);
    update();

    final ApiResponseModel response = await ApiService.post(
      path: 'buyer-requests',
      body: <String, dynamic>{
        ...body,
        'user_id': _profileController.myProfile.uid,
      },
    );

    if (response.success && response.data != null) {
      buyerRequests.insert(0, BuyerRequestModel.fromJson(response.data));
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  /// Update an existing buyer request
  Future<void> updateBuyerRequest(int id, Map<String, dynamic> body) async {
    final ApiResponseModel response = await ApiService.put(
      path: 'buyer-requests/$id',
      body: body,
    );

    if (response.success) {
      int index = buyerRequests.indexWhere((BuyerRequestModel r) => r.id == id);
      if (index != -1) {
        buyerRequests[index] = BuyerRequestModel.fromJson(response.data);
      }
    } else {
      error(true);
    }

    update();
  }

  /// Delete a buyer request
  Future<void> deleteBuyerRequest(int id) async {
    final ApiResponseModel response =
        await ApiService.delete(path: 'buyer-requests/$id');

    if (response.success) {
      buyerRequests.removeWhere((BuyerRequestModel r) => r.id == id);
    } else {
      error(true);
    }

    update();
  }

  /// Filter requests by category or search query
  void filterBuyerRequests(String query) {
    query = query.toLowerCase();
    final List<BuyerRequestModel> filtered = buyerRequests
        .where((BuyerRequestModel r) =>
            r.title.toLowerCase().contains(query) ||
            r.description.toLowerCase().contains(query))
        .toList();

    buyerRequests.assignAll(filtered);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initBuyerRequests();
  }
}
