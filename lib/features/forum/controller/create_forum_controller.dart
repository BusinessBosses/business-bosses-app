import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/forum/controller/bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateForumController extends GetxController {
  RxBool loading = false.obs;
  late ImagePicker _picker;
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);
  RxList<String> updatingImageFileList = RxList<String>(<String>[]);
  // RxList<String> imageUrlList = RxList<String>(<String>[]);
  final ForumController _forumController = Get.put(ForumController());

  void addUpdatingImageFileList(List<String> imagePath) {
    updatingImageFileList.addAll(imagePath);
    update();
  }

  ///ADD IMAGES FOR PREVIEW
  void initializeForumEditImage(List<String>? images) {
    if (images != null) {
      updatingImageFileList.addAll(images);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  bool validateCreatePostData(Map<String, dynamic> data) {
    // if (data['title'].toString().isEmpty ||
    //     data['description'].toString().isEmpty) {
    //   return false;
    // } else {
    //   return true;
    // }
    final String title = data['title'].toString();
    final String desc = data['description'].toString();
    final String ytUrl = data['ytUrl'].toString();
    if (title.isEmpty || desc.isEmpty) {
      return false;
    } else if (ytUrl != 'null' && ytUrl.isNotEmpty) {
      // Regular expression to match YouTube video URLs, including YouTube Shorts
      final RegExp regExp = RegExp(
          r'^(https?://)?(www\.)?(youtu\.be/|youtube\.com/shorts/)([\w-]+)(\?[^\s]*)?$');
      if (regExp.hasMatch(ytUrl)) {
        return true;
      } else {
        return false;
      }
    } else {
      return true; // Return false if ytUrl is null
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

  /// UPLOAD UPDATING IMAGES (NEW IMAGES ADDED WHEN EDITING)
  ///
  Future<dynamic> uploadUpdatingFile() async {
    /// RAW FILES
    final List<String> rawFiles = updatingImageFileList
        .where(
            (String element) => !element.contains('http') && element.isNotEmpty)
        .toList();

    /// UPLOADED FILE URLS

    List<String> fileUrls = <String>[];

    /// FILED SELECTED FILES
    List<File> resourceFile = <File>[];

    for (int i = 0; i < rawFiles.length; i++) {
      File file = File(rawFiles[i]);
      resourceFile.add(file);
    }

    for (int i = 0; i < rawFiles.length; i++) {
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
  Future<void> createForum(
      BuildContext context, Map<String, dynamic> body) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();
      if (imageFileList.isEmpty) {
        final ApiResponseModel response =
            await ForumRepository.createForum(body);

        if (response.success) {
          _forumController.addNewForum(response.data);
          // Get.snackbar('Success', 'Post created successfully');
        }
      } else {
        if (imageFileList.isNotEmpty &&
            (body['ytUrl'] != null && body['ytUrl'] != '')) {
          loading(false);
          update();
          return showSnackbar(
              message: 'You cannot add image & YouTube link, please remove one',
              title: 'OOPS!',
              error: true);
        }
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final ApiResponseModel response = await ForumRepository.createForum(
              <String, dynamic>{...body, 'images': await uploadFile()});

          if (response.success) {
            imageFileList.clear();
            _forumController.addNewForum(response.data);
            // Get.snackbar('Success', 'Post created successfully');
          }
        }
      }
      loading(false);
      update();
    } else {
      showSnackbar(
          message: 'Post can\'t be empty or contain unwanted characters',
          title: 'OOPS!',
          error: true);
      return;
    }
  }

  /// EDIT POST CONTROLLER (EDIT POST TO REMOTE DATA SOURCE)
  Future<void> editForum(Map<String, dynamic> body,
      {bool isBossup = true}) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();

      final List<String> hasNewUpload = updatingImageFileList
          .where((String element) =>
              !element.contains('http') && element.isNotEmpty)
          .toList();
      if (hasNewUpload.isEmpty) {
        final ApiResponseModel response = await ForumRepository.editForum(
            <String, dynamic>{...body, 'images': updatingImageFileList});

        if (response.success) {
          updatingImageFileList.clear();
          final BossUpController bossUpController = Get.find();

          if (isBossup) {
            final int forumIndex = bossUpController.forums.indexWhere(
                (ForumModel element) => element.forumId == body['forumId']);
            bossUpController.updateForum(forumIndex, <String, dynamic>{
              ...response.data,
              'likes': body['likes'],
              'coins': body['coins'],
              'user': body['user'],
              'comments': body['comments']
            });
          } else {
            final int forumIndex = _forumController.forums.indexWhere(
                (ForumModel element) => element.forumId == body['forumId']);
            _forumController.updateForum(forumIndex, <String, dynamic>{
              ...response.data,
              'likes': body['likes'],
              'coins': body['coins'],
              'user': body['user'],
              'comments': body['comments']
            });
          }

          Get.back();
        }
      } else {
        final List<String>? uploadedFiles = await uploadUpdatingFile();
        if (uploadedFiles == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final List<String> alreadyUploadedFileUrls = updatingImageFileList
              .where((String element) => element.contains('http'))
              .toList();
          //////stopped here
          final ApiResponseModel response =
              await ForumRepository.editForum(<String, dynamic>{
            ...body,
            'images': <String>[...alreadyUploadedFileUrls, ...uploadedFiles]
          });

          if (response.success) {
            updatingImageFileList.clear();
            final BossUpController bossUpController = Get.find();

            if (isBossup) {
              final int forumIndex = bossUpController.forums.indexWhere(
                  (ForumModel element) => element.forumId == body['forumId']);
              bossUpController.updateForum(forumIndex, <String, dynamic>{
                ...response.data,
                'likes': body['likes'],
                'coins': body['coins'],
                'user': body['user'],
                'comments': body['comments']
              });
            } else {
              final int forumIndex = _forumController.forums.indexWhere(
                  (ForumModel element) => element.forumId == body['forumId']);
              _forumController.updateForum(forumIndex, <String, dynamic>{
                ...response.data,
                'likes': body['likes'],
                'coins': body['coins'],
                'user': body['user'],
                'comments': body['comments']
              });
            }

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

  void removeUpdatingImage(int index) {
    RxList<String> myAE = updatingImageFileList;
    myAE.removeAt(index);
    updatingImageFileList = myAE;
    update();
  }

  /// PICK IMAGE FROM DEVICE GALLERY
  Future<void> onPickImage({bool isUpdating = false}) async {
    try {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      if (isUpdating) {
        final List<String> paths =
            pickedFileList.map((XFile e) => e.path).toList();
        updatingImageFileList =
            RxList<String>(<String>[...paths, ...updatingImageFileList]);
      } else {
        imageFileList =
            RxList<XFile>(<XFile>[...pickedFileList, ...imageFileList]);
      }
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
    imageFileList.clear();
    updatingImageFileList.clear();
    super.onClose();
  }
}
