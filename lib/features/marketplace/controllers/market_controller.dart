import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
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
  RxList<MarketModel> searchResult = RxList<MarketModel>(<MarketModel>[]);
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);
  RxInt paginationPage = RxInt(1);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool loadingMore = RxBool(false);
  RxBool isJoined = RxBool(false);
  bool isLoading = true;
  RxBool isfiltered = RxBool(false);
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  void removeListing(String marketId) {
    final int marketIndex = markets
        .indexWhere((MarketModel element) => element.marketId == marketId);
    if (marketIndex != -1) {
      markets.removeAt(marketIndex);
      update();
    }
  }

  void updateListing(int index, Map<String, dynamic> data) {
    if (index != -1) {
      markets[index] = MarketModel.fromMap(data);
    }
    update();
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post, {bool? isSearch}) {
    if (isSearch ?? false) {
      isfiltered(true);
      searchResult.clear();
      final List psts = post;
      for (int i = 0; i < psts.length; i++) {
        searchResult.add(MarketModel.fromMap({
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
    } else {
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
      _homeController.addMarkets(markets);
    }
  }

  void updateFiltered() {
    isfiltered = RxBool(false);
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processMorePostsToState(dynamic post) {
    final List psts = post;
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
    _homeController.addMarkets(markets);
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

  Future<void> updatePost(Map<String, dynamic> updatedPost) async {
    final int postIndex = markets.indexWhere(
        (MarketModel element) => element.marketId == updatedPost['marketId']);
    if (postIndex != -1) {
      MarketModel modelizedUpdatedPost = MarketModel.fromMap({
        ...updatedPost,
      });

      markets[postIndex] = modelizedUpdatedPost;

      update();
    }
  }

  /// UPDATE MARKET RATING IF THERE IS AN UPDATE IN REVIEWS
  void updateUser(String id, double newAverageRating) {
    final List<int> postIndices = <int>[];

    for (int i = 0; i < markets.length; i++) {
      if (markets[i].userId == id) {
        postIndices.add(i);
      }
    }

    for (final int index in postIndices) {
      final MarketModel market = markets[index];
      final UserModel? user = market.user;
      final UserModel? updatedUser =
          user?.copyWith(averageRating: newAverageRating);
      final MarketModel updatedMarket = market.copyWith(user: updatedUser);
      markets[index] = updatedMarket;
    }

    update();
  }

  void filterMarket(String? location, String? category) async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response =
        await HomeRepository.filterMarket(location, category);
    if (response.success) {
      processPostsToState(response.data, isSearch: true);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  /// LIKE AND UNLIKE FUNCTION
  void like(String userId, String postId, String type, String receiverUid) {
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

  ///  INITIALIZE MARKETPLACE LISTINGS
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

  Future<void> loadMore(int size, int page) async {
    loadingMore(true);
    update();

    final ApiResponseModel response =
        await HomeRepository.fetchMoreMarket(size, page);
    if (response.success) {
      processMorePostsToState(response.data['rows']);
    } else {
      error(true);
    }
    loadingMore(false);

    update();
  }

  Future<void> initUsers() async {
    // loading(true);
    // error(false);
    update();

    final ApiResponseModel response = await HomeRepository.fetchMarketMembers();
    if (response.success) {
      processMembersToState(response.data['rows']);
    } else {
      // error(true);
    }
    // loading(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(Constants.USER_ID);
    bool isJoin = users.any((UserModel user) => user.uid == userId);
    if (isJoin) {
      isJoined(true);
    }

    update();
  }

  // initSocket() {
  //   socket = IO.io(Constants.socketUrl, <String, dynamic>{
  //     'autoConnect': false,
  //     'transports': <String>['websocket'],
  //   });
  //   socket.connect();
  //   socket.onConnect((_) {
  //     print('Connection established');
  //   });

  //   socket.onDisconnect((_) => print('Connection Disconnection'));
  //   socket.onConnectError((err) => print(err));
  //   socket.onError((err) => print(err));
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    socket = _homeController.socket;
    isLoading = false;
    if (_homeController.markets.isEmpty) {
      initMarket();
      initUsers();
    } else {
      users = _homeController.marketMembers;
      markets = _homeController.markets;
    }
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
