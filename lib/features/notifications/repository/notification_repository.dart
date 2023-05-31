import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';

class NotificationRepository {
  static Future<ApiResponseModel> fetchNotifications(int page) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'notification?page=$page&size=30');
    return response;
  }
}
