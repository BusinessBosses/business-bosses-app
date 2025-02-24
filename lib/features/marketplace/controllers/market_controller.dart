import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';

import 'package:get/get.dart';

import '../../../common/models/comment_model.dart';
import '../../../common/models/user_model.dart';
import '../../home/repository/home_repository.dart';
import '../models/market_model.dart';

class MarketController extends GetxController {
  List<MarketModel> allmarkets = <MarketModel>[];
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  RxList<Product> proProducts = RxList<Product>(<Product>[]);
  RxList<Service> proServices = RxList<Service>(<Service>[]);
  RxList<Object> proItems = RxList<Object>(<Object>[]);
  RxList<MarketModel> products = RxList<MarketModel>(<MarketModel>[]);
  RxList<Order> orders = RxList<Order>(<Order>[]);
  RxList<MarketModel> services = RxList<MarketModel>(<MarketModel>[]);
  RxList<MarketModel> searchResult = RxList<MarketModel>(<MarketModel>[]);
  RxList<UserModel> users = RxList<UserModel>(<UserModel>[]);
  List<UserModel> searchedUsers = <UserModel>[];
  List<MarketModel> searchedPosts = <MarketModel>[];
  List<MarketModel> searchedServices = <MarketModel>[];
  RxBool loadingSearch = RxBool(false);
  RxBool loadingPostSearch = RxBool(false);
  RxBool loadingServicesSearch = RxBool(false);
  RxInt paginationPage = RxInt(1);
  final int postsSize = 20;
  RxBool isUserSearch = RxBool(false);
  RxBool isPostSearch = RxBool(false);
  RxBool isServiceSearch = RxBool(false);
  RxBool error = RxBool(false);
  String marketDescription = '';
  String donationDescription = '';
  RxBool loading = RxBool(false);
  RxBool oloading = RxBool(false);
  RxBool oerror = RxBool(false);
  RxBool loadingMore = RxBool(false);
  RxBool isJoined = RxBool(false);
  bool isLoading = true;
  String? selectedLocation;
  String? selectedCategory;
  String searchQuery = '';

  RxBool isfiltered = RxBool(false);
  List<Product> filteredProducts = <Product>[];
  List<Service> filteredServices = <Service>[];

  // Combined list of all matching items
  List<Object> allFilteredItems = <Object>[];
  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();
  late List<String> connecteds =
      _profileController.myProfile.connecteds ?? <String>[];
  void removeListing(String marketId) {
    ApiService.delete(path: 'markets/$marketId');
    final int marketIndex = markets
        .indexWhere((MarketModel element) => element.marketId == marketId);
    if (marketIndex != -1) {
      markets.removeAt(marketIndex);
    }

    // Check in the products list
    final int productIndex = products
        .indexWhere((MarketModel element) => element.marketId == marketId);
    if (productIndex != -1) {
      products.removeAt(productIndex);
    }

    // Check in the services list
    final int serviceIndex = services
        .indexWhere((MarketModel element) => element.marketId == marketId);
    if (serviceIndex != -1) {
      services.removeAt(serviceIndex);
    }
    update();
  }

  void clearUserSearch() {
    isUserSearch(false);
    update();
  }

  void clearPostSearch() {
    isPostSearch(false);
    update();
  }

  void changeLocation(String name) {
    selectedLocation = name;
    update();
  }

  void clearServiceSearch() {
    isServiceSearch(false);
    update();
  }

  void updateListing(int index, Map<String, dynamic> data) {
    if (index != -1) {
      // Create an updated market model
      MarketModel updatedMarket = MarketModel.fromMap(data);
      // Update in the main list
      markets[index] = MarketModel.fromMap(data);

      // Update in the products list if it's a product
      final int productIndex = products.indexWhere(
          (MarketModel element) => element.marketId == updatedMarket.marketId);
      if (productIndex != -1) {
        products[productIndex] = updatedMarket;
      }
      // Update in the services list if it's a service

      final int serviceIndex = services.indexWhere(
          (MarketModel element) => element.marketId == updatedMarket.marketId);

      if (serviceIndex != -1) {
        services[serviceIndex] = updatedMarket;
      }

      update();
    }
  }

  void updatemarketViews(MarketModel post) {
    final int postIndex = markets
        .indexWhere((MarketModel element) => element.marketId == post.marketId);
    if (postIndex != -1) {
      // Increment the view count of the post by 1
      post.setViews(post.views! + 1);
      update();
    }
    final int promotedIndex = _homeController.promotedMarkets
        .indexWhere((MarketModel element) => element.marketId == post.marketId);
    if (promotedIndex != -1) {
      // Increment the view count of the post by 1
      _homeController.promotedMarkets[promotedIndex].setViews(post.views! + 1);
      update();
    }
    HomeRepository.updatemarketViews(post.marketId, post.views!);
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post, {bool? isSearch}) {
    if (isSearch ?? false) {
      isfiltered(true);
      searchResult.clear();
      final List psts = post;
      for (int i = 0; i < psts.length; i++) {
        searchResult.add(MarketModel.fromMap(<String, dynamic>{
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
      for (int i = 0; i < psts.length; i++) {
        markets.add(MarketModel.fromMap(<String, dynamic>{
          ...psts[i],
          'likes': psts[i]['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'coins': psts[i]['likes']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
        }));
      }
      // Filter markets based on isProduct value
      final List<MarketModel> productMarkets =
          markets.where((MarketModel market) => market.isProduct).toList();
      final List<MarketModel> serviceMarkets =
          markets.where((MarketModel market) => !market.isProduct).toList();
      products.clear();
      services.clear();
      products.addAll(productMarkets);
      services.addAll(serviceMarkets);
    }
  }

  void clearFilter() {
    // Clear all filtered lists
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();
    isfiltered(false);
    update();
  }

  Future<bool> migrateOldMarketplaceData() async {
    final ApiResponseModel response = await ApiService.post(
      path: 'cronjob/migrate-marketplace-data',
      body: <String, dynamic>{'userId': _profileController.myProfile.uid},
    );
    if (response.success) {
      await initMarket();
      return true;
    }
    return false;
  }

  Future<bool> checkOldMarketplaceData() async {
    final ApiResponseModel response = await ApiService.get(
      path: 'markets/user/${_profileController.myProfile.uid}',
    );
    if (response.success) {
      if (response.data['count'] > 0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void filterItems(String searchQuery) {
    filteredProducts.clear();
    filteredServices.clear();
    allFilteredItems.clear();

    final String query = searchQuery.toLowerCase().trim();
    final String? normalizedCategory = selectedCategory?.toLowerCase().trim();

    for (dynamic item in proItems) {
      final String? itemCategory = (item is Product || item is Service)
          ? item.category?.toLowerCase().trim()
          : null;

      bool matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);

      bool matchesCategory = (normalizedCategory == null) ||
          (itemCategory != null && itemCategory == normalizedCategory);

      if (matchesQuery && matchesCategory) {
        if (item is Product) {
          filteredProducts.add(item);
        } else if (item is Service) {
          filteredServices.add(item);
        }
        allFilteredItems.add(item);
      }
    }
    print('Category: $selectedCategory');
    isfiltered(true);
    update();
  }

  void updateFiltered() {
    isfiltered = RxBool(false);
  }

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processMorePostsToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      markets.add(MarketModel.fromMap(<String, dynamic>{
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
          <dynamic, dynamic>{
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
    MarketModel modelizedNewPost = MarketModel.fromMap(<String, dynamic>{
      ...newPost,
      'userId': profileController.myProfile.uid,
      'promote': false,
      'coins': <String>[],
      'likes': <String>[],
      'comments': <CommentModel>[],
      'user': profileController.myProfile.toMap(),
    });

    markets.insert(0, modelizedNewPost);

    // Check if it's a product and add to the products list
    if (modelizedNewPost.isProduct) {
      products.insert(0, modelizedNewPost);
    } else {
      // If it's not a product, assume it's a service and add to the services list
      services.insert(0, modelizedNewPost);
    }

    update();
  }

  Future<void> updatePost(Map<String, dynamic> updatedPost) async {
    final int postIndex = markets.indexWhere(
        (MarketModel element) => element.marketId == updatedPost['marketId']);
    if (postIndex != -1) {
      MarketModel modelizedUpdatedPost = MarketModel.fromMap(<String, dynamic>{
        ...updatedPost,
      });

      markets[postIndex] = modelizedUpdatedPost;

      // Update in the products list if it's a product
      if (modelizedUpdatedPost.isProduct) {
        final int productIndex = products.indexWhere((MarketModel element) =>
            element.marketId == modelizedUpdatedPost.marketId);
        if (productIndex != -1) {
          products[productIndex] = modelizedUpdatedPost;
        }
      }

      // Update in the services list if it's not a product
      if (!modelizedUpdatedPost.isProduct) {
        final int serviceIndex = services.indexWhere((MarketModel element) =>
            element.marketId == modelizedUpdatedPost.marketId);
        if (serviceIndex != -1) {
          services[serviceIndex] = modelizedUpdatedPost;
        }
      }

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

  // void filterMarket(String? location, String? category) async {
  //   loading(true);
  //   error(false);
  //   update();

  //   final ApiResponseModel response =
  //       await HomeRepository.filterMarket(location, category);
  //   if (response.success) {
  //     processPostsToState(response.data, isSearch: true);
  //   } else {
  //     error(true);
  //   }
  //   loading(false);

  //   update();
  // }

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
    final int promotedIndex = _homeController.promotedMarkets
        .indexWhere((MarketModel element) => element.marketId == postId);
    if (promotedIndex != -1) {
      final bool checkLiked = _homeController
          .promotedMarkets[promotedIndex].likes!
          .contains(userId);
      if (checkLiked) {
        _homeController.promotedMarkets[promotedIndex].likes!
            .removeWhere((String element) => element == userId);
      } else {
        _homeController.promotedMarkets[promotedIndex].likes!.add(userId);
      }
    }
    update();
    // if (_profileController.myProfile.uid != receiverUid) {
    //   socket.emit('like', <String, String>{
    //     'postId': postId,
    //     'userId': userId,
    //     'type': type,
    //     'receiverUid': receiverUid,
    //   });
    // } else {
    //   socket.emit('like', <String, String>{
    //     'postId': postId,
    //     'userId': userId,
    //     'type': type,
    //   });
    // }
  }

  /// COIN AND UNCOIN FUNCTION
  void coin(String userId, String postId, ProfileController profileController,
      String type, String receiverUid) {
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
    }
    final int promotedIndex = _homeController.promotedMarkets
        .indexWhere((MarketModel element) => element.marketId == postId);
    if (promotedIndex != -1) {
      final bool checkIfCoined = _homeController
          .promotedMarkets[promotedIndex].coins!
          .contains(userId);
      if (checkIfCoined) {
        _homeController.promotedMarkets[promotedIndex].coins!
            .removeWhere((String element) => element == userId);
      } else {
        _homeController.promotedMarkets[promotedIndex].coins!.add(userId);
      }
    }
    // socket.emit('coin', <String, String>{
    //   'postId': postId,
    //   'userId': userId,
    //   'type': type,
    //   'receiverUid': receiverUid,
    // });
    update();
  }

  /// COMMENT FUNCTION
  void comment(String postId, CommentModel comment) {
    final int postIndex =
        markets.indexWhere((MarketModel element) => element.marketId == postId);
    if (postIndex != -1) {
      markets[postIndex].comments!.add(comment);
    }
    final int promotedIndex = _homeController.promotedMarkets
        .indexWhere((MarketModel element) => element.marketId == postId);
    if (promotedIndex != -1) {
      _homeController.promotedMarkets[promotedIndex].comments!.add(comment);
    }
    update();
  }

  ///  INITIALIZE MARKETPLACE LISTINGS
  Future<void> initMarket() async {
    try {
      // Clear existing data and reset state
      markets.clear();
      loading(true);
      error(false);
      update();

      // Fetch data in parallel
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        HomeRepository.fetchMarketDescription(),
      ]);

      final ApiResponseModel description = responses[0];

      await initProItems();

      if (description.success) {
        final List<dynamic> rows = description.data['rows'];

        // Extract specific entries
        final dynamic marketEntry = rows.firstWhere(
          (dynamic entry) => entry['title'] == 'market',
          orElse: () => null,
        );
        final dynamic donationEntry = rows.firstWhere(
          (dynamic entry) => entry['title'] == 'donation',
          orElse: () => null,
        );
        final dynamic popUpEntry = rows.firstWhere(
          (dynamic entry) => entry['id'] == 6,
          orElse: () => null,
        );

        // Assign extracted data
        marketDescription = marketEntry?['description'] ?? '';
        donationDescription = donationEntry?['description'] ?? '';
        _homeController.notificationStatus = popUpEntry?['title'] ?? '';
        _homeController.notificationDescription =
            popUpEntry?['description'] ?? '';
      } else {
        marketDescription = '';
      }
    } catch (e) {
      error(true);
    } finally {
      loading(false);
      update();
    }
  }

  Future<void> initProItems() async {
    // Clear previous data
    proProducts.clear();
    proServices.clear();
    proItems.clear();

    try {
      // Fetch data
      final List<ApiResponseModel> responses =
          await Future.wait(<Future<ApiResponseModel>>[
        ApiService.get(path: 'goods/all'),
        ApiService.get(path: 'services/all'),
      ]);

      final ApiResponseModel responseProducts = responses[0];
      final ApiResponseModel responseServices = responses[1];

      // Process products
      if (responseProducts.success) {
        proProducts.addAll(responseProducts.data['rows']
            .map<Product>((dynamic json) => Product.fromJson(json))
            .where((Product product) => product.isActive)
            .toList());
      } else {
        throw Exception('Failed to fetch products.');
      }

      // Process services
      if (responseServices.success) {
        proServices.addAll(responseServices.data['rows']
            .map<Service>((dynamic json) => Service.fromJson(json))
            .where((Service service) => service.isActive)
            .toList());
      } else {
        throw Exception('Failed to fetch services.');
      }

      // Combine items
      proItems.addAll(<Object>[...proProducts, ...proServices]);
    } catch (e) {
      error(true);
    } finally {
      loading(false);
    }
  }

  Future<void> initOrder() async {
    orders.clear();
    final ApiResponseModel responseOrders = await ApiService.get(
        path: 'orders/user-orders/${_profileController.myProfile.uid}');
    // Process orders
    if (responseOrders.success) {
      orders.addAll(responseOrders.data['rows']
          .map<Order>((dynamic json) => Order.fromJson(json))
          .toList());
    } else {
      throw Exception('Failed to fetch orders.');
    }
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

  Future<void> searchUsers(String query) async {
    loadingSearch(true);
    update();

    searchedUsers.clear();

    for (UserModel user in users) {
      if (user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedUsers.add(user);
      }
    }
    loadingSearch(false);
    update();
  }

  Future<void> searchPosts(String query) async {
    loadingPostSearch(true);
    update();

    searchedPosts.clear();

    // Assuming products is the list of already fetched products
    for (MarketModel product in products) {
      bool titleMatches = product.title != null &&
          product.title!.toLowerCase().contains(query.toLowerCase());

      if (titleMatches ||
          product.description.toLowerCase().contains(query.toLowerCase())) {
        searchedPosts.add(product);
      }
    }

    loadingPostSearch(false);
    update();
  }

  Future<void> searchServices(String query) async {
    loadingServicesSearch(true);
    update();

    searchedServices.clear();

    // Assuming services is the list of already fetched services
    for (MarketModel service in services) {
      bool titleMatches = service.title != null &&
          service.title!.toLowerCase().contains(query.toLowerCase());

      if (titleMatches ||
          service.description.toLowerCase().contains(query.toLowerCase())) {
        searchedServices.add(service);
      }
    }

    loadingServicesSearch(false);
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

  // Future<void> initUsers() async {
  //   // loading(true);
  //   // error(false);
  //   update();

  //   final ApiResponseModel response = await HomeRepository.fetchMarketMembers();
  //   if (response.success) {
  //     processMembersToState(response.data['rows']);
  //   } else {
  //     // error(true);
  //   }
  //   // loading(false);
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? userId = prefs.getString(Constants.USER_ID);
  //   bool isJoin = users.any((UserModel user) => user.uid == userId);
  //   if (isJoin) {
  //     isJoined(true);
  //   }

  //   update();
  // }

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
    // socket = _homeController.socket;
    isLoading = false;
    if (_homeController.markets.isEmpty) {
      initMarket();
      // initUsers();
    } else {
      // users = _homeController.marketMembers;
      markets = _homeController.markets;
    }
    update();
    super.onInit();
  }

  @override
  void dispose() {
    // socket.disconnect();
    // socket.dispose();
    super.dispose();
  }
}
