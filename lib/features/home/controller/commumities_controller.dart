import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommunitiesController extends GetxController {
  late IO.Socket socket;
  final HomeController _homeController = Get.find();

  List<Industry> industries = [];
  List<Industry> searchedIndustries = [];
  List<ForumModel> searchedForums = [];
  RxBool loading = RxBool(false);
  RxBool loadingSearch = RxBool(false);
  RxBool error = RxBool(false);
  RxBool searchError = RxBool(false);

  List<Industry> getCategoryIndustries(String categoryId) {
    return industries
        .where((Industry element) => element.categoryId == categoryId)
        .toList();
  }

  Future<void> onSearch(int index, String query) async {
    if (index == 0) {
      searchedIndustries = industries
          .where((Industry element) =>
              element.industry!.toLowerCase().contains(query.toLowerCase()) ||
              element.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      loadingSearch(true);
      searchError(false);
      update();
      final ApiResponseModel response = await HomeRepository.searchIndustries(query.trim());
      if (response.success) {
        for (int i = 0; i < response.data['rows'].length; i++) {
          searchedForums.add(ForumModel.fromMap({
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
        searchError(true);
      }
    }
    loadingSearch(false);
    update();
  }

  void clearSearch() {
    searchedForums.clear();
    searchedIndustries.clear();
  }

  void postLike(String userId, String postId, String type) {
    final int postIndex = searchedForums
        .indexWhere((ForumModel element) => element.forumId == postId);
    if (postIndex != -1) {
      final bool checkLiked = searchedForums[postIndex].likes!.contains(userId);
      if (checkLiked) {
        searchedForums[postIndex]
            .likes!
            .removeWhere((String element) => element == userId);
      } else {
        searchedForums[postIndex].likes!.add(userId);
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
  void postCoin(String userId, String postId,
      ProfileController profileController, String type) {
    final int postIndex = searchedForums
        .indexWhere((ForumModel element) => element.forumId == postId);
    if (postIndex != -1) {
      final bool checkIfCoined =
          searchedForums[postIndex].coins!.contains(userId);
      if (checkIfCoined) {
        profileController.updateCoinCount(1);
        searchedForums[postIndex]
            .coins!
            .removeWhere((String element) => element == userId);
      } else {
        profileController.updateCoinCount(-1);
        searchedForums[postIndex].coins!.add(userId);
      }
      socket.emit('coin', {
        'postId': postId,
        'userId': userId,
        'type': type,
      });
    }
    update();
  }

  Future<void> fetchIndustries() async {
    loading(true);
    error(false);
    update();

    final ApiResponseModel response = await HomeRepository.fetchIndustries();
    if (response.success) {
      industries = Industry.toIndustries(snapshot: response.data['rows']);
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    socket = _homeController.socket;
    fetchIndustries();

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    clearSearch();
    super.onClose();
  }
}
