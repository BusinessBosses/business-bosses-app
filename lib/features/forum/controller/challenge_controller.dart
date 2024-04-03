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
      loading(true); // Set loading to true before fetching data
      update();
      ApiResponseModel response = await ApiService.get(path: 'industry/get');
      List<dynamic> responseData = response.data['rows'];

      categories = responseData
          .map((categoryMap) => Industry.fromMap(categoryMap))
          .where((category) =>
              category.categoryId == '-Mos1VMlx3oxZFRaw_BH' &&
              (category.endedAt == null ||
                  category.endedAt!.isAfter(DateTime.now()) ||
                  category.endedAt!.isAtSameMomentAs(DateTime.now())))
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
      error(false);
      update();
    } catch (e) {
      error(true); // Set error to true if there's an error
      update();
    } finally {
      loading(false); // Set loading back to false after fetching data
      update();
    }
  }
}
