import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:get/get.dart';

class CommunitiesController extends GetxController {
  List<Industry> industries = [];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  List<Industry> getCategoryIndustries(String categoryId) {
    return industries
        .where((element) => element.categoryId == categoryId)
        .toList();
  }

  Future<void> fetchIndustries() async {
    loading(true);
    error(false);
    update();

    final response = await HomeRepository.fetchIndustries();
    if (response.success) {
      industries = Industry.toIndustries(snapshot: response.data['rows']);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchIndustries();
    super.onInit();
  }
}
