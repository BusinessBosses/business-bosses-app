import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/features/forum/widgets/postonhomepopup.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ForumController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  List<ForumModel> forums = <ForumModel>[];
  late Industry industry;

  List<UserModel> members = <UserModel>[];
  RxInt totalForums = RxInt(0);
  RxInt page = RxInt(0);
  RxInt membersPage = RxInt(0);
  RxBool loadingNextMembers = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool loadingMembers = RxBool(false);
  RxBool loadingSearch = RxBool(false);
  RxBool loadingPosts = RxBool(false);
  RxBool errorMembers = RxBool(false);
  RxList<ForumModel> userresources = <ForumModel>[].obs;
  List<UserModel> searchedUsers = <UserModel>[];
  List<ForumModel> searchedPosts = <ForumModel>[];
  RxBool isUserSearch = RxBool(false);
  RxBool loadingPostSearch = RxBool(false);
  RxBool isPostSearch = RxBool(false);
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

  void updateForum(int index, Map<String, dynamic> data) {
    if (index != -1) {
      forums[index] = ForumModel.fromMap(data);
    }
    update();
  }

  Future<void> deleteForum(String forumId) async {
    forums.removeWhere((ForumModel element) => element.forumId == forumId);
    update();
    await ForumRepository.deleteForum(forumId);
  }

  void toggleJoinAndLeaveIndustry() {
    final String myUid = _profileController.myProfile.uid;
    // print(myUid);
    if (industry.joinedUsers?.contains(myUid) ?? false) {
      industry.joinedUsers!.removeWhere((String element) => element == myUid);
    } else {
      if (industry.joinedUsers == null) {
        industry.joinedUsers = <String>[myUid];
      } else {
        industry.joinedUsers!.add(myUid);
      }
    }
    _profileController.toggleInterests(industry);
    update();
    joinAndLeaveIndustry(myUid, industry.industryId!);
  }

  Future<void> fetchForums() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response = await ForumRepository.getForums(
        page.value,
        Get.arguments.runtimeType == String
            ? Get.arguments
            : Get.arguments.industryId);
    if (response.success) {
      totalForums(int.parse(response.data['count'].toString()));
      page(page.value + 1);
      // industry = Industry.toObject(response.data['industry']);
      for (int i = 0; i < response.data['rows'].length; i++) {
        if (response.data['rows'][i]['user'] != null) {
          forums.add(ForumModel.fromMap(<String, dynamic>{
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
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  Future<void> fetchuserResources(String userId) async {
    try {
      loading(true); // Set loading to true before fetching data

      ApiResponseModel response = await ApiService.get(
          path: 'forum/get-user-forum/$userId?page=0&size=20');

      if (response.success) {
        userresources.clear();
        for (int i = 0; i < response.data['rows'].length; i++) {
          if (response.data['rows'] != null) {
            ForumModel userresource = ForumModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i],
              'likes': response.data['rows'][i]['likes']
                  .map((dynamic like) => like['userId'].toString())
                  .toList(),
            });
            userresources.add(userresource);
          }
        }
      } else {
        error(true); // Set error to true if there's an error
      }
    } catch (e) {
      error(true); // Set error to true if there's an error
    } finally {
      loading(false); // Set loading back to false after fetching data
    }
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

  Future<void> searchUsers(String query, String industryid) async {
    loadingSearch(true);
    update();

    searchedUsers.clear();

    if (members.isEmpty) {
      await fetchIndustryUsers(industryid);
    }

    for (var user in members) {
      if (user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedUsers.add(user);
      }
    }

    loadingSearch(false);
    update();
  }

  Future<void> searchPosts(
    String query,
  ) async {
    loadingPostSearch(true);
    update();

    searchedPosts.clear();

    // Assuming products is the list of already fetched products
    for (ForumModel product in forums) {
      if (product.description != null && product.description!.toLowerCase().contains(query.toLowerCase()) ||
        product.title != null && product.title!.toLowerCase().contains(query.toLowerCase()) ||
        product.user != null && 
        (product.user!.name != null && product.user!.name!.toLowerCase().contains(query.toLowerCase()) ||
         product.user!.username.toLowerCase().contains(query.toLowerCase()))) {
      searchedPosts.add(product);
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

  void joinAndLeaveIndustry(String userId, String industryId) {
    socket.emit('join-leave-industry', <String, String>{
      'industryId': industryId,
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
          isBossUp: false,
        ));
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    socket = _homeController.socket;
    print(Get.arguments);
    if (Get.arguments == null) {
      Get.back();
      return;
    } else {
      if (Get.arguments.runtimeType == Industry) {
        industry = Get.arguments;
        fetchForums();
      }
    }

    super.onInit();
  }
}
