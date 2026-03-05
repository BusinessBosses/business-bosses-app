import 'dart:developer';

import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/my_connect.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ReachController extends GetxController {
  /// Reach data
  Map<String, dynamic>? data;
  Map<String, dynamic>? shopData;
  Map<String, dynamic>? myReach;

  /// Referrals list
  final RxList<UserModel> referrals = <UserModel>[].obs;

  /// Loader
  final RxBool loading = false.obs;
  final RxBool analysisLoading = false.obs;
  final RxBool leaderboardLoading = false.obs;
  final GetStorage sandBox = GetStorage();

  final List<MyConnect> connections = <MyConnect>[];
  final List<MyConnect> connecteds = <MyConnect>[];
  final List<MyConnect> disconnections = <MyConnect>[];

  List<Map<String, dynamic>> globalLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> industryLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> countryLeaders = <Map<String, dynamic>>[];

  /// Load reach + referrals
  Future<void> loadData(String userId, String currentUserId) async {
    // 🔥 Check for cached data first
    final dynamic cachedReach = sandBox.read('impact_data_$userId');
    if (cachedReach != null) {
      data = _parseMap(cachedReach);
      if (userId == currentUserId) {
        myReach = data;
      }
      loading.value = false;
      update();
    } else {
      loading.value = true;
    }

    try {
      /// Load reach data
      final ApiResponseModel response =
          await ApiService.get(path: 'impact/user/$userId');

      if (response.success) {
        data = _parseMap(response.data);
        await sandBox.write('impact_data_$userId', response.data);

        if (userId == currentUserId) {
          myReach = data;
        }
      }

      /// Load referrals (no extra loader toggle)
      await loadReferrals(userId, showLoader: false);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reach data');
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> loadShopData(String shopId) async {
    final dynamic cachedShopReach = sandBox.read('impact_shop_$shopId');
    if (cachedShopReach != null) {
      shopData = _parseMap(cachedShopReach);
      loading.value = false;
      update();
    } else {
      loading.value = true;
    }
    try {
      /// Load reach data
      final ApiResponseModel response =
          await ApiService.get(path: 'impact/shop/$shopId');
      if (response.success) {
        shopData = _parseMap(response.data);
        await sandBox.write('impact_shop_$shopId', response.data);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reach data');
    } finally {
      loading.value = false;
      update();
    }
  }

  /// Load referrals
  Future<void> loadConnectionAnalysis(String userId) async {
    final dynamic cachedAnalysis = sandBox.read('connection_analysis_$userId');
    if (cachedAnalysis != null) {
      _processConnectionAnalysis(cachedAnalysis);
      analysisLoading.value = false;
      update();
    } else {
      analysisLoading.value = true;
    }

    try {
      final ApiResponseModel response =
          await ApiService.get(path: 'connection/analysis');
      if (response.success) {
        await sandBox.write('connection_analysis_$userId', response.data);
        _processConnectionAnalysis(response.data);
      }
    } catch (e) {
      debugPrint('Error loading connection analysis: $e');
    } finally {
      analysisLoading.value = false;
      update();
    }
  }

  void _processConnectionAnalysis(dynamic data) {
    connections.clear();
    connecteds.clear();
    disconnections.clear();

    if (data['connections'] != null) {
      connections.addAll((data['connections'] as List<dynamic>)
          .map((dynamic e) => MyConnect.fromMap(e)));
    }
    if (data['connecteds'] != null) {
      connecteds.addAll((data['connecteds'] as List<dynamic>)
          .map((dynamic e) => MyConnect.fromMap(e)));
    }
    if (data['disconnections'] != null) {
      disconnections.addAll((data['disconnections'] as List<dynamic>)
          .map((dynamic e) => MyConnect.fromMap(e)));
    }
  }

  Future<void> loadLeaderboardData({String? industry, String? country}) async {
    final dynamic cachedGlobal = sandBox.read('leaderboard_global');
    if (cachedGlobal != null) {
      globalLeaders = _mapApiResponse(cachedGlobal, useGlobalRank: true);
    }

    if (industry != null) {
      final dynamic cachedIndustry =
          sandBox.read('leaderboard_industry_$industry');
      if (cachedIndustry != null) {
        industryLeaders = _mapApiResponse(cachedIndustry, useGlobalRank: false);
      }
    }

    if (country != null) {
      final dynamic cachedCountry =
          sandBox.read('leaderboard_country_$country');
      if (cachedCountry != null) {
        countryLeaders = _mapApiResponse(cachedCountry, useGlobalRank: false);
      }
    }

    if (globalLeaders.isEmpty &&
        (industry == null || industryLeaders.isEmpty) &&
        (country == null || countryLeaders.isEmpty)) {
      leaderboardLoading.value = true;
    }
    update();

    try {
      final List<Future<ApiResponseModel>> futures = <Future<ApiResponseModel>>[
        ApiService.get(path: 'impact/top/shops?limit=30'),
      ];

      if (industry != null) {
        futures.add(ApiService.get(
          path:
              'impact/top/shops/category?category=${Uri.encodeComponent(industry)}&limit=30',
        ));
      }

      if (country != null) {
        futures.add(ApiService.get(
          path:
              'impact/top/shops/location?location=${Uri.encodeComponent(country)}&limit=30',
        ));
      }

      final List<ApiResponseModel> results = await Future.wait(futures);

      if (results[0].success) {
        globalLeaders = _mapApiResponse(results[0].data, useGlobalRank: true);
        await sandBox.write('leaderboard_global', results[0].data);
      }

      int currentIndex = 1;
      if (industry != null && results.length > currentIndex) {
        if (results[currentIndex].success) {
          industryLeaders =
              _mapApiResponse(results[currentIndex].data, useGlobalRank: false);
          await sandBox.write(
              'leaderboard_industry_$industry', results[currentIndex].data);
        }
        currentIndex++;
      }

      if (country != null && results.length > currentIndex) {
        if (results[currentIndex].success) {
          countryLeaders =
              _mapApiResponse(results[currentIndex].data, useGlobalRank: false);
          await sandBox.write(
              'leaderboard_country_$country', results[currentIndex].data);
        }
      }
    } catch (e) {
      debugPrint('Error loading leaderboard data: $e');
    } finally {
      leaderboardLoading.value = false;
      update();
    }
  }

  List<Map<String, dynamic>> _mapApiResponse(
    dynamic data, {
    bool useGlobalRank = false,
  }) {
    final List<dynamic> list = data is List<dynamic> ? data : <dynamic>[];

    return list
        .asMap()
        .entries
        .map<Map<String, dynamic>>((MapEntry<int, dynamic> entry) {
      final int index = entry.key;
      final Map<String, dynamic> item = Map<String, dynamic>.from(entry.value);
      final dynamic shopData = item['shop'];
      if (shopData == null) return <String, dynamic>{};

      // Since Shop and UserModel models are already used elsewhere,
      // we just pass them through or keep as map.
      // LeaderboardScreen expects 'user' and other fields.

      return <String, dynamic>{
        'rank': useGlobalRank ? (item['globalRank'] ?? index + 1) : index + 1,
        'name': shopData['name'],
        'description': shopData['description'],
        'user': UserModel.fromMap(shopData['user']),
        'score': item['impactScore'] ?? 0,
        'image': shopData['image'] ?? '',
        'verified': shopData['verificationStatus'] == 'approved',
      };
    }).toList();
  }

  Future<void> loadReferrals(String userId, {bool showLoader = true}) async {
    final dynamic cachedReferrals = sandBox.read('referrals_data_$userId');
    if (cachedReferrals != null) {
      final List<dynamic> list = _parseList(cachedReferrals);
      referrals.assignAll(
        list.map((dynamic e) => UserModel.fromMap(e)).toList(),
      );
      analysisLoading.value = false;
      update();
    } else if (showLoader) {
      loading.value = true;
    }

    try {
      final ApiResponseModel response =
          await ApiService.get(path: 'users/invites');

      if (response.success) {
        await sandBox.write('referrals_data_$userId', response.data);
        final List<dynamic> list = _parseList(response.data);

        referrals.assignAll(
          list.map((dynamic e) => UserModel.fromMap(e)).toList(),
        );
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Failed to load referrals');
    } finally {
      if (showLoader) loading.value = false;
      update();
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
  List<dynamic> _parseList(dynamic source) {
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
