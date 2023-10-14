// ignore_for_file: public_member_api_docs

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
      events.sort(
          (EventModel a, EventModel b) => a.startAt!.compareTo(b.startAt!));

      for (EventModel event in events) {
        DateTime startAt = event.startAt!;
        DateTime endAt = event.endAt!;

        if (startAt.isAtSameMomentAs(today) || startAt.isAfter(now)) {
          // Event starts today, it's an upcoming event
          upcoming.add(event);
        } else if (startAt.isBefore(now) && endAt.isAfter(now)) {
          // Event has already started, it's not upcoming
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
      Map<String, dynamic> dataNew = <String, dynamic>{
        ...data,
        'id': response.data['id'],
      };

      EventModel newEvent = EventModel.fromMap(dataNew);

      // Find the index where the new event should be inserted based on startAt
      int index = events.indexWhere(
          (EventModel event) => event.startAt!.isAfter(newEvent.startAt!));

      if (index == -1) {
        // If the index is -1, it means the new event should be placed at the end
        events.add(newEvent);
      } else {
        // Insert the new event at the correct position
        events.insert(index, newEvent);
      }

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      if (newEvent.startAt!.isAtSameMomentAs(today) ||
          newEvent.startAt!.isAfter(now)) {
        // Event starts today, it's an upcoming event
        upcoming.add(newEvent);
      } else if (newEvent.startAt!.isBefore(now) &&
          newEvent.endAt!.isAfter(now)) {
        // Event has already started, it's not upcoming
        ongoing.add(newEvent);
      }
    } else {
      showSnackbar(
        title: 'OOPS!',
        message: 'An error occurred while adding an event, please try again!',
        error: true,
      );
    }
    update();
  }

  void deleteEvent(int id) async {
    events.removeWhere((EventModel event) => event.id == id);
    int existingEventIndex =
        upcoming.indexWhere((EventModel event) => event.id == id);

    if (existingEventIndex != -1) {
      // If the event exists in 'upcoming', remove it
      upcoming.removeAt(existingEventIndex);
    }

    existingEventIndex =
        ongoing.indexWhere((EventModel event) => event.id == id);

    if (existingEventIndex != -1) {
      // If the event exists in 'upcoming', remove it
      ongoing.removeAt(existingEventIndex);
    }
    await ApiService.delete(path: 'event/$id');
  }

  @override
  void onInit() {
    initEvents();
    super.onInit();
  }
}
