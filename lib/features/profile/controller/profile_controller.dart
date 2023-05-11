import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:get/get.dart';

/// PROFILE CONTROLLER
class ProfileController extends GetxController {
  /// MODELIZED PROFILE DATA
  UserModel myProfile = UserModel();

  ///MODELIZE RAW DATA AND PUSH TO STATE
  void processDataToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(userData);
    myProfile = modelizedData;
    update();
  }
}
