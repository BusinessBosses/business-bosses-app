import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  bool loading = true;
  final List<UserModel> suggestedUsers = [];
  final List<UserModel> searchedUsers = [];
  final List<UserModel> connections = [];
  final List<UserModel> connecteds = [];
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

    final res = await ApiService.get(path: '/users/name/$query');
    for (var i = 0; i < res.data.length; i++) {
      final mapData = res.data[i];
      final modelizedData = UserModel.fromMap(mapData);

      searchedUsers.add(modelizedData);
    }
    loadingSearch = false;
    update();
  }

  Future<void> getConnections() async {
    final ApiResponseModel res =
        await ApiService.get(path: '/connection/data/${Get.arguments['uid']}');
    if (res.success) {
      for (var i = 0; i < res.data['connections']['data'].length; i++) {
        final mapData = res.data['connections']['data'][i];
        final modelizedConnection = UserModel.fromMap(mapData);

        connections.add(modelizedConnection);
      }
      for (var i = 0; i < res.data['connecteds']['data'].length; i++) {
        final mapData = res.data['connecteds']['data'][i];
        final modelizedConnection = UserModel.fromMap(mapData);

        connecteds.add(modelizedConnection);
      }

      for (var i = 0; i < res.data['suggestedUsers']['data'].length; i++) {
        final mapData = res.data['suggestedUsers']['data'][i];
        final modelizedConnection = UserModel.fromMap(mapData);

        suggestedUsers.add(modelizedConnection);
      }
    }
    loading = false;
    update();
  }

  Future<void> connect(String userId) async {
    final res = await ApiService.post(path: '/connection/connect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  Future<void> disconnect(String userId) async {
    final res = await ApiService.post(path: '/connection/disconnect', body: {
      'userId': _profileController.myProfile.uid,
      'connectedId': userId
    });
  }

  void connectToUser(UserModel user) async {
    final checkConnected =
        connecteds.indexWhere((element) => element.uid == user.uid);
    _profileController.updateConnections(user.uid);
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

    getConnections();
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
