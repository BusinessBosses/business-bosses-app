import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/quote.dart';
import 'package:business_bosses_v2/features/notifications/models/my_notification.dart';
import 'package:business_bosses_v2/features/notifications/repository/notification_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool error = RxBool(false);
  final ProfileController _profileController = Get.find();
  RxBool loading = RxBool(false);
  final RxList<MyNotification> notifications = <MyNotification>[].obs;
  final RxList<MyNotification> ordersNotification = <MyNotification>[].obs;
  final RxInt _page = RxInt(0);
  Quote quote = Quote(
    id: 1,
    by: 'Brain Tracy',
    message:
        'Always give without remembering and always receive without forgetting.',
  );

  /// Guard so the two concurrent callers (onInit + the screen's initState)
  /// don't race on shared state and so we never get stuck mid-flight.
  bool _isLoading = false;

  /// LOAD NOTIFICATIONS FROM REMOTE SOURCE
  Future<void> loadNotifications() async {
    if (_isLoading) return;
    _isLoading = true;
    loading(true);
    error(false);
    update();
    try {
      _page(0);
      final ApiResponseModel response =
          await NotificationRepository.fetchNotifications(_page.value);
      if (response.success) {
        if (response.data['quote'] != null) {
          quote = Quote.fromMap(response.data['quote']);
        }
        // Rebuild the lists from scratch so a reload doesn't duplicate items.
        notifications.clear();
        ordersNotification.clear();
        final List<dynamic> rows =
            (response.data['notifications']?['rows'] as List<dynamic>?) ??
                <dynamic>[];
        for (final dynamic row in rows) {
          final MyNotification newNotification = MyNotification.fromMap(row);
          if (newNotification.notificationType == 'order' ||
              (newNotification.notificationType == 'marketplace' &&
                  newNotification.dataId != null)) {
            ordersNotification.add(newNotification);
          }
          notifications.add(newNotification);
        }
        _profileController.updateProfile(<String, dynamic>{
          ..._profileController.myProfile.toMap(),
          'unReadCount': 0
        });
      } else {
        error(true);
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      error(true);
    } finally {
      // Always release the spinner, even if parsing threw.
      loading(false);
      _isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    loadNotifications();
    super.onInit();
  }
}
