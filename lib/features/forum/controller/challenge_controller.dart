import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class ChallengeController extends GetxController {
  List<Industry> categories = <Industry>[];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  @override
  void onInit() {
    // 🔥 Try to load from cache first
    final dynamic cachedData =
        Get.find<HomeController>().sandBox.read('industries_cache');
    if (cachedData != null) {
      _processCategories(cachedData);
    }

    initCategories();
    super.onInit();
  }

  void _processCategories(List<dynamic> responseData) {
    categories = responseData
        .map((dynamic categoryMap) => Industry.fromMap(categoryMap))
        .where((Industry category) =>
            category.categoryId == '-Mos1VMlx3oxZFRaw_BH' &&
                (category.endedAt == null ||
                    category.endedAt!.isAfter(DateTime.now()) ||
                    category.endedAt!.isAtSameMomentAs(DateTime.now())) ||
            category.industryId == '-MsUOGcOT9oRXGakCcJv')
        .toList();

    categories.sort((Industry a, Industry b) {
      if (a.industryId == '-MsUOGcOT9oRXGakCcJv') {
        return -1;
      } else if (b.industryId == '-MsUOGcOT9oRXGakCcJv') {
        return 1;
      } else {
        return a.industry!.compareTo(b.industry!);
      }
    });
    update();
  }

  void initCategories() async {
    try {
      loading(true); // Set loading to true before fetching data
      update();
      ApiResponseModel response =
          await ApiService.get(path: 'industry/user-count');
      List<dynamic> responseData = response.data['rows'];
      _processCategories(responseData);
      // 🔥 Update cache
      Get.find<HomeController>()
          .sandBox
          .write('industries_cache', responseData);
      error(false);
    } catch (e) {
      error(true); // Set error to true if there's an error
      update();
    } finally {
      loading(false); // Set loading back to false after fetching data
      update();
    }
  }
}
