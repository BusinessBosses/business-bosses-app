import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

import '../../../common/models/api_response_model.dart';
import '../models/events_model.dart';

class LiveController extends GetxController {
  RxList<EventModel> events = RxList<EventModel>(<EventModel>[]);

  void initEvents() async {
    final ApiResponseModel response = await ApiService.get(path: 'event/all');

    if (response.success) {
      var rows = response.data['rows'];
      for (var row in rows) {
        events.add(EventModel.fromMap(row));
      }
      print(events);
    }
  }

  @override
  void onInit() {
    initEvents();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
