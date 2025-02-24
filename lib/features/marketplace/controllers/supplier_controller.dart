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
  RxString filterCategory = RxString('');

  void clearSupplierSearch() {
    isSupplierSearch(false);
    searchedSuppliers.clear(); // Clear the search list
    update();
  }

  Future<void> initSuppliers() async {
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
    String lowerCaseQuery = query.toLowerCase().trim();
    String normalizedCategory = filterCategory.value.toLowerCase().trim();

    // If search query is empty, clear the search results and exit early
    if (lowerCaseQuery.isEmpty) {
      loadingSearch(false);
      isSupplierSearch(false); // Indicate that search is not active
      update();
      return;
    }

    searchedSuppliers.addAll(
      suppliers.where((SuppliersModel supplier) {
        String lowerCaseName = supplier.name.toLowerCase();
        String lowerCaseDescription = supplier.description.toLowerCase();
        String? itemCategory = supplier.category?.toLowerCase().trim();
        String? userName = supplier.user?.name?.toLowerCase();
        String? userUsername = supplier.user?.username.toLowerCase();

        bool matchesCategory =
            normalizedCategory.isEmpty || itemCategory == normalizedCategory;
        bool matchesQuery = lowerCaseName.isEmpty ||
            lowerCaseName.contains(lowerCaseQuery) ||
            lowerCaseDescription.contains(lowerCaseQuery) ||
            (userName?.contains(lowerCaseQuery) ?? false) ||
            (userUsername?.contains(lowerCaseQuery) ?? false);

        return matchesCategory && matchesQuery;
      }),
    );

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
