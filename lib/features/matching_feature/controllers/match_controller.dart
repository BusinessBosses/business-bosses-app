import 'dart:convert';
import 'dart:developer';

import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/features/matching_feature/models/match_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchController extends GetxController {
  // --- State Variables ---
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxList<MatchModel> matchList = <MatchModel>[].obs;
  RxList<MatchModel> bookmarkedMatches = <MatchModel>[].obs;

  static const String _bookmarkKey = 'bookmarked_matches';

  // Assumes ProfileController is already available via Get.find()
  final ProfileController profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
    loadBookmarks();
  }

  Future<void> toggleBookmark(MatchModel match) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (bookmarkedMatches.any((MatchModel m) => m.id == match.id)) {
      // remove
      bookmarkedMatches.removeWhere((MatchModel m) => m.id == match.id);
    } else {
      // add
      bookmarkedMatches.add(match);
    }
    update();

    // save to shared prefs
    final List<String> encoded =
        bookmarkedMatches.map((MatchModel m) => jsonEncode(m.toMap())).toList();
    await prefs.setStringList(_bookmarkKey, encoded);
  }

  bool isBookmarked(String matchId) {
    return bookmarkedMatches.any((MatchModel m) => m.id == matchId);
  }

  Future<void> loadBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_bookmarkKey) ?? <String>[];

    bookmarkedMatches.value =
        saved.map((String s) => MatchModel.fromJson(jsonDecode(s))).toList();
  }

  /// Fetches matches from the API and updates the state.
  Future<void> fetchMatches() async {
    try {
      isLoading(true);
      errorMessage('');

      // Make the API call
      final ApiResponseModel response = await ApiService.get(
          path: 'users/${profileController.myProfile.uid}/matches');

      if (response.success) {
        // --- UPDATED LOGIC ---
        // 1. Safely access the list of matches from the JSON response.
        final List<dynamic> matchesData = response.data ?? <dynamic>[];

        // 2. Map the raw JSON list to a list of Match objects.
        final List<MatchModel> fetchedMatches = matchesData
            .map((dynamic json) => MatchModel.fromJson(json))
            .toList();

        // 3. Assign the newly parsed list to our observable.
        matchList.assignAll(fetchedMatches);
      } else {
        // If the API reports success: false, throw an error to be caught below
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessage('Failed to load matches. Please try again.');
      log('MatchController Error: $e'); // For debugging
    } finally {
      isLoading(false);
    }
  }
}
