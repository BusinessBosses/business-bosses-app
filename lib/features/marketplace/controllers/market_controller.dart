import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../../utils/constants/constants.dart';
import '../../home/repository/home_repository.dart';
import '../models/market_model.dart';

class MarketController extends GetxController {
  late IO.Socket socket;
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);
  RxInt paginationPage = RxInt(0);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool isJoined = RxBool(false);
  bool isLoading = true;
  // final ProfileController _profileController = Get.find();

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    final List psts = post;
    markets.clear();
    for (int i = 0; i < psts.length; i++) {
      markets.add(MarketModel.fromMap({
        ...psts[i],
        'likes': psts[i]['likes']
            .map((dynamic like) => like['userId'].toString())
            .toList(),
        'coins': psts[i]['likes']
            .map((dynamic coin) => coin['userId'].toString())
            .toList()
      }));
    }
    // update();
  }

  void processMembersToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      users.add(
        UserModel.fromMap(
          {
            ...psts[i]['user'],
          },
        ),
      );
    }
    // update();
  }

  /// ADD NEW POST TO STATE
  void addNewPost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    MarketModel modelizedNewPost = MarketModel.fromMap({
      ...newPost,
      'userId': profileController.myProfile.uid,
      'promote': false,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': profileController.myProfile.toMap(),
    });

    markets.insert(0, modelizedNewPost);

    update();
  }

  void filterMarket(String? location, String? category) async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response =
        await HomeRepository.filterMarket(location, category);
    if (response.success) {
      processPostsToState(response.data);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void like(String userId, String postId, String type) {
    final int postIndex =
        markets.indexWhere((MarketModel element) => element.marketId == postId);
    if (postIndex != -1) {
      final bool checkLiked = markets[postIndex].likes!.contains(userId);
      if (checkLiked) {
        markets[postIndex]
            .likes!
            .removeWhere((String element) => element == userId);
      } else {
        markets[postIndex].likes!.add(userId);
      }
    }
    update();
    socket.emit('like', {
      'postId': postId,
      'userId': userId,
      'type': type,
    });
  }

  /// COIN AND UNCOIN FUNCTION
  void coin(String userId, String postId, ProfileController profileController,
      String type) {
    final int postIndex =
        markets.indexWhere((MarketModel element) => element.marketId == postId);
    if (postIndex != -1) {
      final bool checkIfCoined = markets[postIndex].coins!.contains(userId);
      if (checkIfCoined) {
        profileController.updateCoinCount(1);
        markets[postIndex]
            .coins!
            .removeWhere((String element) => element == userId);
      } else {
        profileController.updateCoinCount(-1);
        markets[postIndex].coins!.add(userId);
      }
      socket.emit('coin', {
        'postId': postId,
        'userId': userId,
        'type': type,
      });
    }
    update();
  }

  /// COMMENT FUNCTION
  void comment(String postId, CommentModel comment) {
    final int postIndex =
        markets.indexWhere((MarketModel element) => element.marketId == postId);
    if (postIndex != -1) {
      markets[postIndex].comments!.add(comment);
    }
    update();
  }

  Future<void> initMarket() async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response = await HomeRepository.fetchMarket();
    if (response.success) {
      processPostsToState(response.data['rows']);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  Future<void> initUsers() async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response = await HomeRepository.fetchMarketMembers();
    if (response.success) {
      processMembersToState(response.data['rows']);
    } else {
      error(true);
    }
    loading(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(Constants.USER_ID);
    bool isJoin = users.any((UserModel user) => user.uid == userId);
    if (isJoin) {
      isJoined(true);
    }

    update();
  }

  initSocket() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': <String>['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initSocket();
    isLoading = false;
    update();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
