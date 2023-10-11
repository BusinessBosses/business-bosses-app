import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

import '../../../common/models/api_response_model.dart';
import '../models/events_model.dart';

class LiveController extends GetxController {
  RxList<EventModel> events = RxList<EventModel>(<EventModel>[]);
  RxList<EventModel> upcoming = RxList<EventModel>(<EventModel>[]);
  RxList<EventModel> ongoing = RxList<EventModel>(<EventModel>[]);
  RxBool loading = RxBool(false);

  void initEvents() async {
    loading(true);
    update();
    final ApiResponseModel response = await ApiService.get(path: 'event/all');

    if (response.success) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      List<dynamic> rows = response.data['rows'];
      for (dynamic row in rows) {
        events.add(EventModel.fromMap(row));
      }
      for (EventModel event in events) {
        DateTime startAt = event.startAt!;
        DateTime endAt = event.endAt!;

        if (startAt.isAtSameMomentAs(today)) {
          // Event starts today, it's an upcoming event
          upcoming.add(event);
        } else if (startAt.isBefore(now) && endAt.isAfter(now)) {
          // Event is currently ongoing
          ongoing.add(event);
        }
      }
    }
    loading(false);
    update();
  }

  void createEvent(Map<String, dynamic> data) async {
    final ApiResponseModel response =
        await ApiService.post(path: 'event', body: data);
    if (response.success) {
      Map<String, dynamic> dataNew = {
        ...data,
        'id': response.data['id'],
      };
      events.add(EventModel.fromMap(dataNew));
    } else {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred white adding event, please try again!',
          error: true);
    }
    update();
  }

  void deleteEvent(int id) async {
    events.removeWhere((EventModel event) => event.id == id);
    await ApiService.delete(path: 'event/${id}');
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
