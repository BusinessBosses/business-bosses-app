import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class SupplierController extends GetxController {
  RxList<SuppliersModel> suppliers = RxList<SuppliersModel>(<SuppliersModel>[]);
  List<SuppliersModel> searchedSuppliers = <SuppliersModel>[];
  RxBool error = RxBool(false);
  RxBool loading = RxBool(true);
  RxBool loadingSearch = RxBool(false);
  RxBool isSupplierSearch = RxBool(false);

  void clearSupplierSearch() {
    isSupplierSearch(false);
    update();
  }

  Future<void> initSuppliers() async {
    loading(true);

    final ApiResponseModel response =
        await ApiService.get(path: 'suppliers/all');
    if (response.success) {
      final List<dynamic> psts = response.data['rows'];
      for (int i = 0; i < psts.length; i++) {
        suppliers.add(SuppliersModel.fromMap(psts[i]));
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

    for (var user in suppliers) {
      if (user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedSuppliers.add(user);
        print(user);
      }
    }
    loadingSearch(false);
    update();
  }

  Future<ApiResponseModel> addSupplier(Map<String, dynamic> data) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'suppliers', body: data);
    return response;
  }
}
