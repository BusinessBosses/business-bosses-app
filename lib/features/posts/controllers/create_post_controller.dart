import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// CREATEPOSTCONTROLLER
class CreatePostController extends GetxController {
  /// ALL USERS FOR MENTIONS
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);

  /// SELECTED IMAGES
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);

  /// PROMOTE STATE
  RxBool shouldPromote = false.obs;
  late ImagePicker _picker;

  /// CHANGE PROMOTE STATE VALUE
  void togglePromote() {
    shouldPromote(!shouldPromote.value);
    update();
  }

  /// REMOVE IMAGE FROM SELECTED
  void removeImage(int index) {
    RxList<XFile> myAE = imageFileList;
    myAE.removeAt(index);
    imageFileList = myAE;
    update();
  }

  /// PICK IMAGE FROM DEVICE GALLERY
  Future<void> onPickImage() async {
    try {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      imageFileList =
          RxList<XFile>(<XFile>[...pickedFileList, ...imageFileList]);
      update();
    } catch (e) {
      //
    }
  }

  /// FILTER USERS FOR MENTIONS
  List<UserModel> filterUsers(String text) {
    List<UserModel> filterUser = <UserModel>[];
    for (UserModel u in users) {
      String username = '@${u.username.toLowerCase()}';
      if (username.trim().contains(text.trim().toLowerCase())) {
        filterUser.add(u);
      }
    }

    return filterUser;
  }

  /// INITIALIZE CONTROLLER

  @override
  void onInit() {
    _picker = ImagePicker();

    super.onInit();
  }
}
