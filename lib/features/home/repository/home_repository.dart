import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class HomeRepository {
  /// GET INIT DATA
  static Future<ApiResponseModel> fetchData() async {
    final ApiResponseModel response = await ApiService.get(path: 'init/');
    return response;
  }

  static Future<ApiResponseModel> fetchIndustries() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'industry/get');
    return response;
  }
}
