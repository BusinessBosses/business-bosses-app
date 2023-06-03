import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/models/api_response_model.dart';
import '../../forum/repository/forum_repository.dart';
import '../presentation/boost_market_screen.dart';

class CreateMarketController extends GetxController {
  RxBool loading = false.obs;
  late ImagePicker _picker;
  final MarketController _marketController = Get.put(MarketController());
  final ProfileController _profileController = Get.put(ProfileController());
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);

  /// UPLOAD FILE TO REMOTE SERVER
  Future<dynamic> uploadFile() async {
    /// UPLOADED FILE URLS
    List<String> fileUrls = <String>[];

    /// FILED SELECTED FILES
    List<File> resourceFile = <File>[];

    for (int i = 0; i < imageFileList.length; i++) {
      File file = File(imageFileList[i].path);
      resourceFile.add(file);
    }

    for (int i = 0; i < imageFileList.length; i++) {
      final int bytes = resourceFile[i].readAsBytesSync().lengthInBytes;
      final double kb = bytes / 1024;
      final double mb = kb / 1024;

      if (mb >= 5) {
        showSnackbar(message: 'Image size should be maximum 10 MB.');
        loading(false);
        return null;
      } else {
        final dynamic res = await ApiService.uploadFile(resourceFile[i]);

        if (res == null) {
          return null;
        } else {
          fileUrls.add(res['fileUrl']);
        }
      }
    }

    return fileUrls;
  }

  bool validateCreatePostData(Map<String, dynamic> data) {
    if (data['price'].toString().isEmpty ||
        data['description'].toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// CREATE POST CONTROLLER (REGISTER NEW POST TO REMOTE DATA SOURCE)
  Future<void> createForum(Map<String, dynamic> body, bool isPromote) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();
      if (imageFileList.isEmpty) {
        final ApiResponseModel response =
            await ForumRepository.createMarket(body);

        if (response.success) {
          _marketController.addNewPost(response.data, _profileController);

          if (isPromote) {
            Get.to(() => BoostMarket(
                  postId: response.data['marketId'],
                ));
          } else {
            Get.back();
          }
        }
      } else {
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final ApiResponseModel response = await ForumRepository.createMarket(
              <String, dynamic>{...body, 'images': await uploadFile()});

          if (response.success) {
            imageFileList.clear();
            _marketController.addNewPost(response.data, _profileController);

            if (isPromote) {
              Get.to(() => BoostMarket(
                    postId: response.data['marketId'],
                  ));
            } else {
              Get.back();
            }
          }
        }
      }
      loading(false);
      update();
    } else {
      showSnackbar(
          message: 'Price or Description can\'t be empty',
          title: 'OOPS!',
          error: true);
      return;
    }
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
      rethrow;
      // handle error
    }
  }

  /// INITIALIZE CONTROLLER
  @override
  void onInit() {
    _picker = ImagePicker();

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    imageFileList.clear();
    super.onClose();
  }
}
