import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/quote.dart';
import 'package:business_bosses_v2/features/notifications/models/my_notification.dart';
import 'package:business_bosses_v2/features/notifications/repository/notification_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool error = RxBool(false);
  final ProfileController _profileController = Get.find();
  RxBool loading = RxBool(false);
  final List<MyNotification> notifications = <MyNotification>[];
  final List<MyNotification> ordersNotification = <MyNotification>[];
  final RxInt _page = RxInt(0);
  Quote quote = Quote(
    id: 1,
    by: 'Brain Tracy',
    message:
        'Always give without remembering and always receive without forgetting.',
  );

  /// LOAD NOTIFICATIONS FROM REMOTE SOURCE
  Future<void> loadNotifications() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response =
        await NotificationRepository.fetchNotifications(_page.value);
    if (response.success) {
      if (response.data['quote'] != null) {
        quote = Quote.fromMap(response.data['quote']);
      }
      for (int i = 0; i < response.data['notifications']['rows'].length; i++) {
        MyNotification newNotification =
            MyNotification.fromMap(response.data['notifications']['rows'][i]);
        if (newNotification.notificationType == 'order') {
          ordersNotification.add(newNotification);
        } 
          notifications.add(newNotification);
        

        _page(_page.value + 1);
      }
      _profileController.updateProfile(<String, dynamic>{
        ..._profileController.myProfile.toMap(),
        'unReadCount': 0
      });
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    loadNotifications();
    super.onInit();
  }
}
