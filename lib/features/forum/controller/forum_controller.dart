import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ForumController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  List<ForumModel> forums = [];
  RxInt totalForums = RxInt(0);
  RxInt page = RxInt(0);
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  Future<void> fetchForums() async {
    loading(true);
    error(false);
    update();

    final response =
        await ForumRepository.getForums(page.value, Get.arguments.industryId);
    if (response.success) {
      totalForums(int.parse(response.data['count'].toString()));
      page(page.value + 1);
      for (var i = 0; i < response.data['rows'].length; i++) {
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
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String type) {
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
    socket.emit('like', {
      'postId': postId,
      'userId': userId,
      'type': type,
    });
  }

  void joinAndLeaveIndustry(String userId, String industryId) {
    socket.emit('join-leave-industry', {
      'industryId': industryId,
      'userId': userId,
    });
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    fetchForums();
    super.onInit();
  }
}
