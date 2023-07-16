import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../utils/constants/constants.dart';

class BossUpController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  List<ForumModel> forums = [];
  List<UserModel> members = [];
  RxInt totalForums = RxInt(0);
  RxInt page = RxInt(0);
  RxInt membersPage = RxInt(0);
  RxBool loadingNextMembers = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool loadingMembers = RxBool(false);
  RxBool errorMembers = RxBool(false);
  Future<void> fetchForums() async {
    loading(true);
    error(false);
    update();
    ApiResponseModel response;
    response =
        await ForumRepository.getForums(page.value, Constants.BOSSUPINDUSTRYID);
    if (response.success) {
      totalForums(int.parse(response.data['count'].toString()));
      page(page.value + 1);
      for (int i = 0; i < response.data['rows'].length; i++) {
        if (response.data['rows'][i]['user'] != null) {
          forums.add(ForumModel.fromMap({
            ...response.data['rows'][i],
            'likes': response.data['rows'][i]['likes']
                .map((dynamic like) => like['userId'].toString())
                .toList(),
            'coins': response.data['rows'][i]['coins']
                .map((dynamic coin) => coin['userId'].toString())
                .toList()
          }));
        }
      }
      _homeController.addBossupForums(forums);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  Future<void> fetchIndustryUsers(String industryId,
      {bool isNext = false}) async {
    members.clear();
    membersPage(0);
    if (isNext && loadingNextMembers.value) return;
    if (isNext) {
      loadingNextMembers(true);
    } else {
      loadingMembers(true);
      errorMembers(false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
    final ApiResponseModel response =
        await ForumRepository.getForumMembers(membersPage.value, industryId);
    if (response.success) {
      membersPage(membersPage.value + 1);
      for (int i = 0; i < response.data.length; i++) {
        members.add(UserModel.fromMap(response.data[i]));
      }
    } else {
      errorMembers(true);
    }
    loadingNextMembers(false);
    loadingMembers(false);

    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String type, String receiverUid) {
    final int postIndex =
        forums.indexWhere((ForumModel element) => element.forumId == postId);
    if (postIndex != -1) {
      final bool checkLiked = forums[postIndex].likes!.contains(userId);
      if (checkLiked) {
        forums[postIndex]
            .likes!
            .removeWhere((String element) => element == userId);
      } else {
        forums[postIndex].likes!.add(userId);
      }
    }
    update();
    if (_profileController.myProfile.uid != receiverUid) {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'type': type,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'type': type,
      });
    }
  }

  void joinAndLeaveIndustry(String userId, String industryId) {
    socket.emit('join-leave-industry', {
      'industryId': industryId,
      'userId': userId,
    });
  }

  /// COMMENT FUNCTION
  void comment(String postId, CommentModel comment) {
    final int postIndex =
        forums.indexWhere((ForumModel element) => element.forumId == postId);
    if (postIndex != -1) {
      forums[postIndex].comments!.add(comment);
    }
    update();
  }

  /// COIN AND UNCOIN FUNCTION
  void postCoin(String userId, String postId,
      ProfileController profileController, String type) {
    final int postIndex =
        forums.indexWhere((ForumModel element) => element.forumId == postId);
    if (postIndex != -1) {
      final bool checkIfCoined = forums[postIndex].coins!.contains(userId);
      if (checkIfCoined) {
        profileController.updateCoinCount(1);
        forums[postIndex]
            .coins!
            .removeWhere((String element) => element == userId);
      } else {
        profileController.updateCoinCount(-1);
        forums[postIndex].coins!.add(userId);
      }
      socket.emit('coin', {
        'postId': postId,
        'userId': userId,
        'type': type,
      });
    }
    update();
  }

  /// ADD NEW POST TO STATE
  void addNewForum(Map<String, dynamic> newPost) async {
    ForumModel modelizedNewPost = ForumModel.fromMap({
      ...newPost,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': _profileController.myProfile.toMap()
    });

    forums.insert(0, modelizedNewPost);

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    socket = _homeController.socket;
    if (_homeController.bossupForums.isEmpty) {
      fetchForums();
    } else {
      forums = _homeController.bossupForums;
    }
    super.onInit();
  }
}
