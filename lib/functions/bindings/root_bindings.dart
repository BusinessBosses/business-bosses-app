import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:get/get.dart';

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(() => PostsController());
    // TODO: implement dependencies
  }
}
