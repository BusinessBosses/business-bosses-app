import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/posts/repository/post_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../presentation/boost_post_screen.dart';

/// CREATEPOSTCONTROLLER
class CreatePostController extends GetxController {
  final PostsController _postsController = Get.find();

  /// ALL USERS FOR MENTIONS
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);

  /// SELECTED IMAGES
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);

  /// PROMOTE STATE
  RxBool shouldPromote = false.obs;

  bool _promote = false;

  /// LOADING STATE
  RxBool loading = false.obs;
  late ImagePicker _picker;

  ///   VALIDATE CREATE POST DATA
  bool validateCreatePostData(Map<String, dynamic> data) {
    if (data['title'].toString().isEmpty && imageFileList.isEmpty) {
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
  Future<void> createPost(Map<String, dynamic> body) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();
      if (imageFileList.isEmpty) {
        final ApiResponseModel response = await PostRepository.createPost(body);

        if (response.success) {
          _postsController.addNewPost(response.data);
          if (shouldPromote.value == true) {
            Get.to(() => BoostPost(
                  postId: response.data['postId'],
                  postTitle: response.data['title'],
                ));
          } else {
            Get.back();
          }
        }
      } else {
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final ApiResponseModel response = await PostRepository.createPost(
              <String, dynamic>{...body, 'images': await uploadFile()});

          if (response.success) {
            imageFileList.clear();
            _postsController.addNewPost(response.data);
            if (shouldPromote.value == true) {
              Get.to(() => BoostPost(
                    postId: response.data['postId'],
                    postTitle: response.data['title'],
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
          message: 'Post can\'t be empty', title: 'OOPS!', error: true);
      return;
    }
  }

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
      // handle error
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

  @override
  void onClose() {
    // TODO: implement onClose
    users.clear();
    imageFileList.clear();
    shouldPromote(false);
    super.onClose();
  }
}
