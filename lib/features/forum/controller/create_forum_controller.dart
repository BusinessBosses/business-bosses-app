import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateForumController extends GetxController {
  RxBool loading = false.obs;
  late ImagePicker _picker;
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);
  final ForumController _forumController = Get.put(ForumController());
  bool validateCreatePostData(Map<String, dynamic> data) {
    if (data['title'].toString().isEmpty ||
        data['description'].toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

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

  /// CREATE POST CONTROLLER (REGISTER NEW POST TO REMOTE DATA SOURCE)
  Future<void> createForum(Map<String, dynamic> body) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();
      if (imageFileList.isEmpty) {
        final ApiResponseModel response =
            await ForumRepository.createForum(body);

        if (response.success) {
          _forumController.addNewForum(response.data);

          Get.back();
        }
      } else {
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final ApiResponseModel response = await ForumRepository.createForum(
              <String, dynamic>{...body, 'images': await uploadFile()});

          if (response.success) {
            imageFileList.clear();
            _forumController.addNewForum(response.data);

            Get.back();
          }
        }
      }
      loading(false);
      update();
    } else {
      showSnackbar(
          message: 'Post can\'t be empty', title: 'OOPS!', error: true);
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
