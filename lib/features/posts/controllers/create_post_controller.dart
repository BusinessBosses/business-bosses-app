import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/repository/post_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/widgets/gallery_screen.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';
import '../presentation/boost_post_screen.dart';

/// CREATEPOSTCONTROLLER
class CreatePostController extends GetxController {
  final HomeController _homeController = Get.find();
  late IO.Socket socket;

  /// ALL USERS FOR MENTIONS
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);

  /// SELECTED IMAGES
  RxList<XFile> imageFileList = RxList<XFile>(<XFile>[]);
  RxList<String> updatingImageFileList = RxList<String>(<String>[]);

  ///my asserts
  List<MyAssetEntity> myAssetsEntities = <MyAssetEntity>[];

  /// file processing
  List<bool> fileProcessing = <bool>[];

  ///seleted video
  File? selectedVid;

  ///video thumbnail
  File? vidThumbnail;

  /// PROMOTE STATE
  RxBool shouldPromote = false.obs;

  final bool _promote = false;

  /// LOADING STATE
  RxBool loading = false.obs;
  late ImagePicker _picker;

  ///   VALIDATE CREATE POST DATA
  bool validateCreatePostData(Map<String, dynamic> data) {
    final String title = data['title'].toString();
    final String ytUrl = data['ytUrl'].toString();
    // if (title.isEmpty && imageFileList.isEmpty) {
    //   return false;
    // } else if (ytUrl.isNotEmpty && ytUrl != '') {
    //   // Regular expression to match YouTube video URLs
    //   final RegExp regExp = RegExp(
    //       r'^https?://(?:www\.)?youtu\.?be(?:\.com)?/.*(?:\?v=|/embed/|/videos/|/watch\?v=)([\w-]+)');
    //   print(ytUrl);
    //   if (regExp.hasMatch(ytUrl)) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   return true; // Return false if ytUrl is null
    // }

    if (title.isEmpty && imageFileList.isEmpty) {
      return false;
    } else {
      return true; // Return false if ytUrl is null
    }
  }

  /// UPLOAD FILE TO REMOTE SERVER
  Future<Map<String, dynamic>?> uploadFile() async {
    /// UPLOADED FILE URLS
    List<String> fileUrls = <String>[];
    Map<String, dynamic> mediaUrls = <String, dynamic>{};

    if (selectedVid != null) {
      MediaUploadResult result =
          await ApiService.uploadMediaFiles(selectedVid!, vidThumbnail!);
      String videoUrl = result.videoUrl;
      String thumbnailUrl = result.thumbnailUrl;

      if (videoUrl == null) {
        showSnackbar(message: 'Error Uploading video');
        return null;
      } else {
        return mediaUrls = <String, dynamic>{
          'images': thumbnailUrl,
          'videoUrl': videoUrl
        };
      }
    } else {
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
    }

    // return fileUrls;
    if (fileUrls.isNotEmpty) {
      return <String, dynamic>{'fileUrls': fileUrls};
    } else if (mediaUrls.isNotEmpty) {
      return mediaUrls;
    }

    return null;
  }

  /// CREATE POST CONTROLLER (REGISTER NEW POST TO REMOTE DATA SOURCE)
  Future<void> createPost(
      Map<String, dynamic> body, ProfileController profileController) async {
    if (validateCreatePostData(body)) {
      loading(true);
      update();
      if (imageFileList.isEmpty && selectedVid == null) {
        final ApiResponseModel response = await PostRepository.createPost(body);

        if (response.success) {
          _homeController.addNewPost(response.data, profileController);
          profileController.addNewPost(response.data);

          if (shouldPromote.value == true) {
            Get.to(() => BoostPost(
                  postId: response.data['postId'],
                  postTitle: response.data['title'],
                ));
          } else {
            Get.back();
          }
          Get.snackbar('Success', 'Post created successfully');
        }
      } else if (selectedVid != null) {
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final Map<String, dynamic>? files = await uploadFile();
          final thumbnail = files?['images'];
          final videoUrl = files?['videoUrl'];
          final ApiResponseModel response =
              await PostRepository.createPost(<String, dynamic>{
            ...body,
            'images': thumbnail,
            'videoUrl': videoUrl
          });

          if (response.success) {
            imageFileList.clear();
            _homeController.addNewPost(response.data, profileController);
            profileController.addNewPost(response.data);
            // Emit a WebSocket event to notify other users of the new post
            socket.emit('newPostEvent', {'newPost': "this is the new posts"});

            if (shouldPromote.value == true) {
              Get.to(() => BoostPost(
                    postId: response.data['postId'],
                    postTitle: response.data['title'],
                  ));
            } else {
              Get.back();
            }
            Get.snackbar('Success', 'Post created successfully');
          }
        }
      } else {
        if (await uploadFile() == null) {
          showSnackbar(message: 'Error Uploading video');
        } else {
          final Map<String, dynamic>? file = await uploadFile();
          final ApiResponseModel response = await PostRepository.createPost(
              <String, dynamic>{...body, 'images': file?['fileUrls']});

          if (response.success) {
            imageFileList.clear();
            _homeController.addNewPost(response.data, profileController);
            profileController.addNewPost(response.data);

            if (shouldPromote.value == true) {
              Get.to(() => BoostPost(
                    postId: response.data['postId'],
                    postTitle: response.data['title'],
                  ));
            } else {
              Get.back();
            }
            Get.snackbar('Success', 'Post created successfully');
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

  /// delete a selected post
  void onDeletePost(String postId) async {
    try {
      final ApiResponseModel response = await ApiService.delete(
        path: 'post/delete-post/$postId',
      );
      final ProfileController profileController = Get.find();
      final HomeController homeController = Get.find();

      if (response.success) {
        showSnackbar(message: 'Post deleted successfully!', title: 'Success');
        profileController.removePost(postId);
        homeController.removePost(postId);
        return;
      } else {
        showSnackbar(
            message: 'Failed to delete post.', title: 'O0PS!', error: true);
        return;
      }
    } catch (e) {
      rethrow;
      // showSnackbar(
      //     message: 'Error deleting post.', title: 'O0PS!', error: true);
    }
  }

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

  void initializePostEditImage(List<String>? images) {
    if (images != null) {
      updatingImageFileList.addAll(images);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  /// delete a selected post
  Future<void> onEditPost(PostModel? post, String title) async {
    loading(true);
    update();
    if (validateCreatePostData(post!.toMap())) {
      final List<String> hasNewUpload = updatingImageFileList
          .where((String element) =>
              !element.contains('http') && element.isNotEmpty)
          .toList();
      if (hasNewUpload.isEmpty) {
        final ApiResponseModel response = await ApiService.put(
          path: 'post/update-post/${post.postId}',
          body: <String, dynamic>{
            'title': title,
            'images': updatingImageFileList
          },
        );

        if (response.success) {
          final ProfileController profileController = Get.find();
          final HomeController homeController = Get.find();
          PostModel modelizedPost = PostModel.fromMap(<String, dynamic>{
            ...post.toMap(),
            ...response.data,
          });
          homeController.updatePost(modelizedPost);
          profileController.updatePost(modelizedPost);
          Get.back();
          showSnackbar(message: 'Post updated successfully!', title: 'Success');
        } else {
          showSnackbar(
              message: 'Failed to editing post.', title: 'O0PS!', error: true);
        }
      } else {
        final List<String>? uploadedFiles = await uploadUpdatingFile();
        if (uploadedFiles == null) {
          showSnackbar(message: 'Error Uploading image');
        } else {
          final List<String> alreadyUploadedFileUrls = updatingImageFileList
              .where((String element) => element.contains('http'))
              .toList();

          final ApiResponseModel response = await ApiService.put(
            path: 'post/update-post/${post.postId}',
            body: <String, dynamic>{
              'title': title,
              'images': <String>[...alreadyUploadedFileUrls, ...uploadedFiles]
            },
          );
          if (response.success) {
            final ProfileController profileController = Get.find();
            final HomeController homeController = Get.find();
            PostModel modelizedPost = PostModel.fromMap(<String, dynamic>{
              ...post.toMap(),
              ...response.data,
            });
            homeController.updatePost(modelizedPost);
            profileController.updatePost(modelizedPost);
            Get.back();
            showSnackbar(
                message: 'Post updated successfully!', title: 'Success');
          } else {
            showSnackbar(
                message: 'Failed to editing post.',
                title: 'O0PS!',
                error: true);
          }
        }
      }
    }
    loading(false);
    update();
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

  void removeUpdatingImage(int index) {
    RxList<String> myAE = updatingImageFileList;
    myAE.removeAt(index);
    updatingImageFileList = myAE;
    update();
  }

  /// PICK IMAGE FROM DEVICE GALLERY
  Future<void> onPickImage(GalleryType type, {bool isUpdating = false}) async {
    // print(" $updatingImageFileList $isUpdating");
    if (type == GalleryType.videos) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        try {
          final String? uint8list = await VideoThumbnail.thumbnailFile(
            video: File(video.path).path,
            imageFormat: ImageFormat.PNG,
            maxWidth:
                128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 10,
          );

          selectedVid = File(video.path);
          vidThumbnail = File(uint8list!);
          print('++++++>>>>>>>>>>>>>>>this is the video $selectedVid');
          print('++++++>>>>>>>>>>>>>>>this is the video $vidThumbnail');

          update();
        } catch (e) {
          //handle error
        }
      }
    } else {
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
        // handle error
      }
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

    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');

      socket.onDisconnect((_) => print('Connection Disconnection'));
      socket.onConnectError((err) => print(err));
      socket.onError((err) => print(err));
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    users.clear();
    imageFileList.clear();
    shouldPromote(false);
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
