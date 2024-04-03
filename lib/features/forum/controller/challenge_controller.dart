import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class ChallengeController extends GetxController {
  List<Industry> categories = <Industry>[];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  @override
  void onInit() {
    initCategories();
    super.onInit();
  }

  void initCategories() async {
    try {
      loading.value = true; // Set loading to true before fetching data
      update();
      ApiResponseModel response = await ApiService.get(path: 'industry/get');
      List<dynamic> responseData = response.data['rows'];

      categories = responseData
          .where((categoryMap) =>
              Industry.fromMap(categoryMap).categoryId ==
              '-Mos1VMlx3oxZFRaw_BH')
          .map((categoryMap) => Industry.fromMap(categoryMap))
          .toList();
      // Assuming data returned is a list of Map<String, dynamic>
      // Sort categories by placing 'Boss Up Challenge' at the top
      categories.sort((Industry a, Industry b) {
        if (a.industry == 'Boss Up Challenge ') {
          return -1; // 'Boss Up Challenge' comes first
        } else if (b.industry == 'Boss Up Challenge ') {
          return 1; // 'Boss Up Challenge' comes after other categories
        } else {
          // Sort other categories alphabetically
          return a.industry!.compareTo(b.industry!);
        }
      });
    } catch (e) {
      error.value = true; // Set error to true if there's an error
      update();
      print('Error fetching categories: $e');
    } finally {
      loading.value = false; // Set loading back to false after fetching data
      update();
    }
  }
}
