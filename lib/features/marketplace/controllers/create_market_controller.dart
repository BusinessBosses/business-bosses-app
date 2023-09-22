import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
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
  RxList<String> updatingImageFileList = RxList<String>(<String>[]);
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);

  void addUpdatingImageFileList(List<String> imagePath) {
    updatingImageFileList.addAll(imagePath);
    update();
  }

  ///ADD IMAGES FOR PREVIEW
  void initializeMarketEditImage(List<String>? images) {
    if (images != null) {
      updatingImageFileList.addAll(images);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
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

  Future<dynamic> uploadUpdatingFile() async {
    /// RAW FILES
    final List<String> rawFiles = updatingImageFileList
        .where((String element) => !element.contains('http'))
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
          title: 'Oops!',
          error: true);
      return;
    }
  }

  /// EDIT POST CONTROLLER (EDIT POST TO REMOTE DATA SOURCE)
  Future<void> editForum(Map<String, dynamic> body) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();

      final List<String> hasNewUpload = updatingImageFileList
          .where((String element) => !element.contains('http'))
          .toList();
      if (hasNewUpload.isEmpty) {
        final ApiResponseModel response =
            await ForumRepository.editListing(body);

        if (response.success) {
          updatingImageFileList.clear();
          final int forumIndex = _marketController.markets.indexWhere(
              (MarketModel element) => element.marketId == body['marketId']);
          _marketController.updateListing(forumIndex, <String, dynamic>{
            ...response.data,
            'likes': body['likes'],
            'coins': body['coins'],
            'user': body['user'],
            'comments': body['comments']
          });

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
          final ApiResponseModel response = await ForumRepository.editForum({
            ...body,
            'images': [...alreadyUploadedFileUrls, ...uploadedFiles]
          });

          if (response.success) {
            updatingImageFileList.clear();
            final int forumIndex = _marketController.markets.indexWhere(
                (MarketModel element) => element.marketId == body['marketId']);
            _marketController.updateListing(forumIndex, <String, dynamic>{
              ...response.data,
              'likes': body['likes'],
              'coins': body['coins'],
              'user': body['user'],
              'comments': body['comments']
            });

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
    updatingImageFileList.clear();
    super.onClose();
  }
}
