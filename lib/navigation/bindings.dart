import 'package:get/get.dart';
import '../features/home/controller/home_controller.dart';
import '../features/profile/controller/profile_controller.dart';
import '../features/chat/controllers/chat_controller.dart';
import '../features/notifications/controller/notification_controller.dart';
import '../features/home/controller/commumities_controller.dart';
import '../features/forum/controller/challenge_controller.dart';
import '../features/chat/controllers/ai_chat_controller.dart';
import '../features/marketplace/controllers/market_controller.dart';
import '../bbpro/controllers/shop_controller.dart';
import '../features/impact/controllers/impact_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(), permanent: true);
    Get.put(ChatController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReachController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CommunitiesController());
    Get.lazyPut(() => ChallengeController());
    Get.lazyPut(() => AiChatController());
    Get.put(MarketController());
    Get.put(ShopController(), permanent: true);
  }
}
