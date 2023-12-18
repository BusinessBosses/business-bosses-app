import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  bool loading = true;
  final List<UserModel> suggestedUsers = <UserModel>[];
  final List<UserModel> searchedUsers = <UserModel>[];
  final List<UserModel> connections = <UserModel>[];
  final List<UserModel> connecteds = <UserModel>[];
  final TextEditingController searchController = TextEditingController();
  final ProfileController _profileController = Get.find();

  bool isSearching = false;
  bool loadingSearch = false;
  void toggleSearchState() {
    isSearching = !isSearching;
    update();
  }

  Future<void> search(String query) async {
    loadingSearch = true;
    update();

    final ApiResponseModel res =
        await ApiService.get(path: '/users/name/$query');
    for (int i = 0; i < res.data.length; i++) {
      final mapData = res.data[i];
      final UserModel modelizedData = UserModel.fromMap(mapData);

      searchedUsers.add(modelizedData);
    }
    loadingSearch = false;
    update();
  }

  Future<void> getConnections(String userId) async {
    final ApiResponseModel res =
        await ApiService.get(path: 'connection/data/$userId');
    if (res.success) {
      for (int i = 0; i < res.data['connections']['data'].length; i++) {
        final Map<String, dynamic> mapData = res.data['connections']['data'][i];
        final UserModel modelizedConnection = UserModel.fromMap(mapData);

        connections.add(modelizedConnection);
      }
      for (int i = 0; i < res.data['connecteds']['data'].length; i++) {
        final Map<String, dynamic> mapData = res.data['connecteds']['data'][i];
        final UserModel modelizedConnection = UserModel.fromMap(mapData);

        connecteds.add(modelizedConnection);
      }

      for (int i = 0;
          i < res.data['suggestedUsers']['data']['rows'].length;
          i++) {
        final Map<String, dynamic> mapData =
            res.data['suggestedUsers']['data']['rows'][i];
        final UserModel modelizedConnection = UserModel.fromMap(mapData);

        suggestedUsers.add(modelizedConnection);
      }
    }
    loading = false;
    update();
  }

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: '/connection/connect',
        body: <String, dynamic>{
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: '/connection/disconnect',
        body: <String, dynamic>{
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  void connectToUser(UserModel user) async {
    final int checkConnected =
        connecteds.indexWhere((UserModel element) => element.uid == user.uid);
    _profileController.updateConnections(user.uid);
    update();

    if (checkConnected == -1) {
      connecteds.add(user);
      await connect(user.uid);
    } else {
      connecteds.removeAt(checkConnected);
      await disconnect(user.uid);
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    if (Get.arguments == null) {
      Get.back();
    } else {
      getConnections(Get.arguments['uid']);
    }
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    isSearching = false;
    suggestedUsers.clear();
    searchedUsers.clear();
    connections.clear();
    super.onClose();
  }
}
