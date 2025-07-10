import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralsController extends GetxController {
  bool loading = true;
  final List<UserModel> searchedUsers = <UserModel>[];
  final List<UserModel> referrals = <UserModel>[];
  final TextEditingController searchController = TextEditingController();
  final ProfileController _profileController = Get.find();
  late List<String> connecteds =
      _profileController.myProfile.connecteds ?? <String>[];

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
        await ApiService.get(path: 'users/name/$query');
    for (int i = 0; i < res.data.length; i++) {
      final mapData = res.data[i];
      final UserModel modelizedData = UserModel.fromMap(mapData);

      searchedUsers.add(modelizedData);
    }
    loadingSearch = false;
    update();
  }

  Future<void> getReferrals() async {
    final ApiResponseModel res =
        await ApiService.get(path: 'referal/${Get.arguments}');
    if (res.success) {
      for (int i = 0; i < res.data.length; i++) {
        final mapData = res.data[i];
        final UserModel modelizedConnection = UserModel.fromMap(mapData);

        referrals.add(modelizedConnection);
      }
    }
    loading = false;
    update();
  }

  Future<void> connect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/connect',
        body: <String, dynamic>{'connectedId': userId});
  }

  Future<void> disconnect(String userId) async {
    // ignore: unused_local_variable
    final ApiResponseModel res = await ApiService.post(
        path: 'connection/disconnect',
        body: <String, dynamic>{'connectedId': userId});
  }

  void connectToUser(UserModel user) async {
    final int checkConnected =
        connecteds.indexWhere((String element) => element == user.uid);
    _profileController.updateConnections(user.uid);
    update();

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
  void onInit() {
    // TODO: implement onInit

    getReferrals();
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
    searchedUsers.clear();
    super.onClose();
  }
}
