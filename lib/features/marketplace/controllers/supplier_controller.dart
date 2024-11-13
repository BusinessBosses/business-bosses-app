import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class SupplierController extends GetxController {
  RxList<SuppliersModel> suppliers = RxList<SuppliersModel>(<SuppliersModel>[]);
  RxList<SuppliersModel> mySuppliers =
      RxList<SuppliersModel>(<SuppliersModel>[]);
  RxList<SuppliersModel> searchedSuppliers =
      RxList<SuppliersModel>(<SuppliersModel>[]);
  final ProfileController profileController = Get.find();
  RxBool error = RxBool(false);
  RxBool loading = RxBool(true);
  RxBool loadingSearch = RxBool(false);
  RxBool isSupplierSearch = RxBool(false);

  void clearSupplierSearch() {
    isSupplierSearch(false);
    searchedSuppliers.clear(); // Clear the search list
    update();
  }

  Future<void> initSuppliers() async {
    loading(true);
    error(false);

    final ApiResponseModel response =
        await ApiService.get(path: 'suppliers/all');
    if (response.success) {
      final List<dynamic> psts = response.data['rows'];
      suppliers.clear();
      for (int i = 0; i < psts.length; i++) {
        suppliers.add(SuppliersModel.fromMap(psts[i]));
      }
    } else {
      error(true);
    }
    loading(false);
    update();
  }

  Future<void> initMySuppliers() async {
    loading(true);
    error(false);

    final ApiResponseModel response = await ApiService.get(
        path: 'suppliers/user-suppliers/${profileController.myProfile.uid}');
    if (response.success) {
      final List<dynamic> psts = response.data['rows'];
      mySuppliers.clear();
      for (int i = 0; i < psts.length; i++) {
        mySuppliers.add(SuppliersModel.fromMap(psts[i]));
      }
    } else {
      error(true);
    }
    loading(false);
    update();
  }

  Future<void> searchSuppliers(String query) async {
    loadingSearch(true);
    update();

    searchedSuppliers.clear();
    String lowerCaseQuery = query.toLowerCase();
    for (SuppliersModel user in suppliers) {
      String lowerCaseName = user.name.toLowerCase();
      if (lowerCaseName.contains(lowerCaseQuery) ||
          user.user!.name!.toLowerCase().contains(lowerCaseQuery) ||
          user.user!.username.toLowerCase().contains(lowerCaseQuery)) {
        searchedSuppliers.add(user);
      }
    }
    loadingSearch(false);
    isSupplierSearch(true);
    update();
  }

  Future<ApiResponseModel> addSupplier(Map<String, dynamic> data) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'suppliers', body: data);
    return response;
  }
}
