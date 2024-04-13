import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../home/repository/home_repository.dart';

class BossUpController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  List<ForumModel> forums = <ForumModel>[];
  List<UserModel> members = <UserModel>[];
  RxInt totalForums = RxInt(0);
  RxInt page = RxInt(0);
  RxInt membersPage = RxInt(0);
  RxBool loadingNextMembers = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool loadingMembers = RxBool(false);
  RxBool errorMembers = RxBool(false);

  Future<void> fetchForums(String industryId) async {
    loading(true);
    error(false);
    update();
    ApiResponseModel response;
    response = await ForumRepository.getForums(page.value, industryId);

    if (response.success) {
      totalForums(int.parse(response.data['count'].toString()));
      page(page.value + 1);

      // Separate lists for ranked and non-ranked posts
      List<ForumModel> rankedForums = <ForumModel>[];
      List<ForumModel> nonRankedForums = <ForumModel>[];

      for (int i = 0; i < response.data['rows'].length; i++) {
        if (response.data['rows'][i]['user'] != null) {
          ForumModel forum = ForumModel.fromMap(<String, dynamic>{
            ...response.data['rows'][i],
            'likes': response.data['rows'][i]['likes']
                .map((dynamic like) => like['userId'].toString())
                .toList(),
            'coins': response.data['rows'][i]['coins']
                .map((dynamic coin) => coin['userId'].toString())
                .toList()
          });

          if (forum.isRanked != null && forum.isRanked!) {
            rankedForums.add(forum);
          } else {
            nonRankedForums.add(forum);
          }
        }
      }
      // After categorizing ranked and non-ranked forums
      nonRankedForums.sort((ForumModel a, ForumModel b) =>
          b.likes!.length.compareTo(a.likes!.length));
      // Combine ranked and non-ranked posts, with ranked posts at the beginning
      List<ForumModel> combinedForums = <ForumModel>[
        ...rankedForums,
        ...nonRankedForums
      ];

      // Clear the existing list before adding new forums
      forums.addAll(combinedForums); // Add the combined list of forums

      _homeController.addBossupForums(forums);
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  void updateForum(int index, Map<String, dynamic> data) {
    if (index != -1) {
      forums[index] = ForumModel.fromMap(data);
    }
    update();
  }

  void updateForumViews(ForumModel post) {
    final int postIndex = forums
        .indexWhere((ForumModel element) => element.forumId == post.forumId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      post.setViews(post.views! + 1);
      update();
      HomeRepository.updateForumViews(post.forumId, post.views!);
    }
  }

  void deleteForum(String forumId) {
    final HomeController homeController = Get.find();
    forums.removeWhere((ForumModel element) => element.forumId == forumId);
    homeController.removeForum(forumId);

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

      _homeController.addBossupMembers(members);
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
      socket.emit('like', <String, String>{
        'postId': postId,
        'userId': userId,
        'type': type,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', <String, String>{
        'postId': postId,
        'userId': userId,
        'type': type,
      });
    }
  }

  void joinAndLeaveIndustry(String userId, Industry industry) {
    socket.emit('join-leave-industry', <String, String?>{
      'industryId': industry.industryId,
      'userId': userId,
    });
    _profileController.toggleInterests(industry);
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
      ProfileController profileController, String type, String receiverUid) {
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
      socket.emit('coin', <String, String>{
        'postId': postId,
        'userId': userId,
        'type': type,
        'receiverUid': receiverUid,
      });
    }
    update();
  }

  /// ADD NEW POST TO STATE
  void addNewForum(Map<String, dynamic> newPost) async {
    ForumModel modelizedNewPost = ForumModel.fromMap(<String, dynamic>{
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

    super.onInit();
  }
}
