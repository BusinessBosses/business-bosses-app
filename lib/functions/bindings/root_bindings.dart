import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:get/get.dart';

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(() => HomeController());
  }
}
