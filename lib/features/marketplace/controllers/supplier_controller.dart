import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class SupplierController extends GetxController {
  RxList<SuppliersModel> suppliers = RxList<SuppliersModel>(<SuppliersModel>[]);
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);

  void initSuppliers() async {
    loading(true);
    error(false);
    update();
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

  @override
  void onInit() {
    initSuppliers();
    super.onInit();
  }
}
