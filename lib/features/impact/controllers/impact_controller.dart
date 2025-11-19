import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ReachController extends GetxController {
  dynamic data;
  dynamic myReach;
  RxBool loading = RxBool(false);

  Future<void> loadData(String userId, String currentUserId) async {
    loading.value = true;
    final ApiResponseModel response =
        await ApiService.get(path: 'impact/user/$userId');
    data = response.data;
    if (userId == currentUserId) {
      myReach = data;
    }
    loading.value = false;
  }
}
