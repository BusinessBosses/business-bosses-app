import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/features/forum/widgets/postonhomepopup.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../home/repository/home_repository.dart';

class BossUpController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  RxList<ForumModel> forums = <ForumModel>[].obs;
  List<UserModel> members = <UserModel>[];
  List<UserModel> searchedUsers = <UserModel>[];
  List<ForumModel> searchedPosts = <ForumModel>[];
  RxInt totalForums = RxInt(0);
  RxInt membersPage = RxInt(0);
  RxBool loadingNextMembers = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool loadingMembers = RxBool(false);
  RxBool loadingPosts = RxBool(false);
  RxBool errorMembers = RxBool(false);
  RxBool isUserSearch = RxBool(false);
  RxBool isPostSearch = RxBool(false);
  RxBool loadingPostSearch = RxBool(false);
  late List<String> connecteds =
      _profileController.myProfile.connecteds ?? <String>[];

  void clearUserSearch() {
    isUserSearch(false);
    update();
  }

  void clearPostSearch() {
    isPostSearch(false);
    update();
  }

  Future<void> fetchForums(String industryId) async {
    loading(true);
    update();
    try {
      final ApiResponseModel response =
          await ForumRepository.getForums(0, industryId);
      if (response.success) {
        totalForums(int.parse(response.data['count'].toString()));

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

        nonRankedForums.sort((ForumModel a, ForumModel b) =>
            b.likes!.length.compareTo(a.likes!.length));

        List<ForumModel> combinedForums = <ForumModel>[
          ...rankedForums,
          ...nonRankedForums
        ];
        forums.assignAll(combinedForums); // Add the combined list of forums
      } else {
        error(true);
      }
    } catch (e) {
      // You can set error flag to true to indicate that an error occurred
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

  void deleteForum(String forumId) async {
    forums.removeWhere((ForumModel element) => element.forumId == forumId);
    if (_profileController.userresources
            .indexWhere((ForumModel element) => element.forumId == forumId) !=
        -1) {
      _profileController.userresources
          .removeWhere((ForumModel element) => element.forumId == forumId);
    }
    await ForumRepository.deleteForum(forumId);
    ApiService.put(
      path: 'users/${_profileController.myProfile.uid}',
      body: <String, dynamic>{
        'postChallenges': _profileController.myProfile.postChallenges,
      },
    );
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

  Future<void> searchUsers(String query, String? industryid) async {
    loadingMembers(true);
    update();
    searchedUsers.clear();

    if (members.isEmpty) {
      await fetchIndustryUsers(industryid!);
    }

    for (dynamic user in members) {
      if (user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedUsers.add(user);
      }
    }

    loadingMembers(false);

    update();
  }

  Future<void> searchPosts(String query) async {
    loadingPostSearch(true);
    update();

    searchedPosts.clear();

    for (dynamic forum in forums) {
      if (forum.description!.toLowerCase().contains(query.toLowerCase())) {
        searchedPosts.add(forum);
      }
    }

    loadingPostSearch(false);
    update();
  }

  void connectToUser(UserModel user) async {
    final int checkConnected =
        connecteds.indexWhere((String element) => element == user.uid);
    _profileController.updateConnections(user.uid);
    update();
    if (isUserSearch.value) {
      final int checkConnectedSearch =
          connecteds.indexWhere((String element) => element == user.uid);
      if (checkConnectedSearch == -1) {
        connecteds.add(user.uid);
      } else {
        connecteds.removeAt(checkConnectedSearch);
      }
    }
    if (checkConnected == -1) {
      connecteds.add(user.uid);
      await connect(user.uid);
    } else {
      connecteds.removeAt(checkConnected);
      await disconnect(user.uid);
    }

    update();
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: '/connection/connect', body: <String, dynamic>{
      'userId': _profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(
        path: '/connection/disconnect',
        body: <String, dynamic>{
          'userId': _profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
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
    _profileController.userresources.insert(0, modelizedNewPost);

    Get.off(() => PostonhomePopUp(
          forum: modelizedNewPost,
          isBossUp: true,
        ));

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    socket = _homeController.socket;

    super.onInit();
  }
}
