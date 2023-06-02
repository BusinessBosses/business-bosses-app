import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/search/repository/search_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class CompleteSearchController extends GetxController {
  List<UserModel> recommendedConnections = [];
  List<UserModel> searchedUsers = [];
  RxInt page = RxInt(0);
  RxBool loadingSearch = RxBool(false);
  RxBool loading = RxBool(true);
  RxBool error = RxBool(false);

  Future<void> search(String query) async {
    loadingSearch(true);
    update();

    final ApiResponseModel response = await SearchRepository.search(query);
    if (response.success) {
      for (int i = 0; i < response.data.length; i++) {
        final mapData = response.data[i];
        final UserModel modelizedData = UserModel.fromMap(mapData);

        searchedUsers.add(modelizedData);
      }
    }
    loadingSearch(false);
    update();
  }

  Future<void> getData() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response =
        await SearchRepository.getData(page.value);

    if (response.success) {
      page(page.value + 1);

      for (var i = 0; i < response.data['rows'].length; i++) {
        recommendedConnections.add(UserModel.fromMap(response.data['rows'][i]));
      }
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
