import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class HomeRepository {
  /// GET INIT DATA
  static Future<ApiResponseModel> fetchData() async {
    final ApiResponseModel response = await ApiService.get(path: 'init/');
    return response;
  }

  static Future<ApiResponseModel> fetchRefreshData() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'init/refresh');
    return response;
  }

  static Future<ApiResponseModel> fetchIndustries() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'industry/get');
    return response;
  }

  static Future<ApiResponseModel> searchIndustries(String query) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'forum/search/$query?page=0&size=50');
    return response;
  }

  /// Fetch Marketplace Data
  static Future<ApiResponseModel> fetchMarket() async {
    final ApiResponseModel response = await ApiService.get(path: 'markets/all');
    return response;
  }

  /// Fetch MArketplace Members
  static Future<ApiResponseModel> fetchMarketMembers() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'members/marketplace');
    return response;
  }

  /// Fetch Comments
  static Future<ApiResponseModel> fetchComments(String postId) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'comments/post/$postId');
    return response;
  }

  /// Filter Marketplace Data
  static Future<ApiResponseModel> filterMarket(
      String? location, String? category) async {
    if (location == null) {
      final ApiResponseModel response =
          await ApiService.get(path: 'markets/search?category=$category');
      return response;
    } else if (category == null) {
      final ApiResponseModel response =
          await ApiService.get(path: 'markets/search?location=$location');
      return response;
    } else {
      final ApiResponseModel response = await ApiService.get(
          path: 'markets/search?category=$category&location=$location');
      return response;
    }
  }

  /// Fetch BossUp Partner
  static Future<ApiResponseModel> fetchPartner() async {
    final ApiResponseModel response = await ApiService.get(path: 'partner/all');
    return response;
  }

  /// Fetch Blocked User
  static Future<ApiResponseModel> fetchBlocked() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'blockedpost/user');
    return response;
  }
}
