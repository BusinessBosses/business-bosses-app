import 'dart:developer';

import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ReachController extends GetxController {
  /// Reach data
  Map<String, dynamic>? data;
  Map<String, dynamic>? myReach;

  /// Referrals list
  final RxList<UserModel> referrals = <UserModel>[].obs;

  /// Loader
  final RxBool loading = false.obs;

  /// Load reach + referrals
  Future<void> loadData(String userId, String currentUserId) async {
    try {
      loading.value = true;

      /// Load reach data
      final ApiResponseModel response =
          await ApiService.get(path: 'impact/user/$userId');

      data = _parseMap(response.data);

      if (userId == currentUserId) {
        myReach = data;
      }

      /// Load referrals (no extra loader toggle)
      await loadReferrals(showLoader: false);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reach data');
    } finally {
      loading.value = false;
    }
  }

  /// Load referrals
  Future<void> loadReferrals({bool showLoader = true}) async {
    try {
      if (showLoader) loading.value = true;

      final ApiResponseModel response =
          await ApiService.get(path: 'users/invites');

      final List list = _parseList(response.data);

      referrals.assignAll(
        list.map((e) => UserModel.fromMap(e)).toList(),
      );
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to load referrals');
    } finally {
      if (showLoader) loading.value = false;
    }
  }

  /// Safely parse Map data
  Map<String, dynamic>? _parseMap(dynamic source) {
    if (source is Map<String, dynamic>) {
      return source;
    }
    if (source is Map) {
      return Map<String, dynamic>.from(source);
    }
    return null;
  }

  /// Safely extract List from API response
  List _parseList(dynamic source) {
    if (source is List) {
      return source;
    }
    if (source is Map && source['data'] is List) {
      return source['data'];
    }
    if (source is Map) {
      return source.values.toList();
    }
    return <dynamic>[];
  }
}
