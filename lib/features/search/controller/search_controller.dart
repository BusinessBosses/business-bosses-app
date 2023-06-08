import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/search/repository/search_repository.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class CompleteSearchController extends GetxController {
  List<UserModel> recommendedConnections = [];
  List<UserModel> searchedUsers = [];
  List<PostModel> searchedPosts = [];
  List<ForumModel> searchedForums = [];
  RxInt page = RxInt(0);
  RxBool loadingSearch = RxBool(false);
  RxBool isUserSearch = RxBool(false);
  RxBool loading = RxBool(true);
  RxBool error = RxBool(false);
  final ProfileController _profileController = Get.find();
  late List<String> connecteds = _profileController.myProfile.connecteds ?? [];

  void clearUserSearch() {
    isUserSearch(false);
    update();
  }

  Future<void> search(String query, {int currentIndex = 0}) async {
    loadingSearch(true);
    update();

    if (currentIndex == 0) {
      isUserSearch(true);
      update();
      final ApiResponseModel response =
          await SearchRepository.searchUsers(query.trim());
      if (response.success) {
        for (int i = 0; i < response.data.length; i++) {
          final mapData = response.data[i];
          final UserModel modelizedData = UserModel.fromMap(mapData);

          searchedUsers.add(modelizedData);
        }
      }
    } else if (currentIndex == 1) {
      final ApiResponseModel response =
          await SearchRepository.searchPosts(query.trim());
      if (response.success) {
        for (int i = 0; i < response.data['rows'].length; i++) {
          final mapData = response.data['rows'][i];
          // final PostModel modelizedData = PostModel.fromMap(mapData);

          searchedPosts.add(PostModel.fromMap({
            ...mapData,
            'likes': mapData['likes']
                .map((dynamic like) => like['userId'].toString())
                .toList(),
            'coins': mapData['likes']
                .map((dynamic coin) => coin['userId'].toString())
                .toList()
          }));
        }
      }
    } else {
      final ApiResponseModel response =
          await HomeRepository.searchIndustries(query.trim());
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
      }
    }

    loadingSearch(false);
    update();
  }

  Future<void> getData() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response =
        await SearchRepository.getData(page.value);

    if (response.success) {
      page(page.value + 1);

      for (int i = 0; i < response.data['rows'].length; i++) {
        recommendedConnections.add(UserModel.fromMap(response.data['rows'][i]));
      }
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: '/connection/connect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(path: '/connection/disconnect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
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

  @override
  void onClose() {
    // TODO: implement onClose
    searchedForums.clear();
    searchedPosts.clear();
    searchedUsers.clear();
    recommendedConnections.clear();
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
