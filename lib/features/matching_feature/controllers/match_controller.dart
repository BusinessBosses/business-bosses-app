import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';

class MatchController extends GetxController {
  // --- State Variables ---
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxList<Match> matchList = <Match>[].obs;

  // Assumes ProfileController is already available via Get.find()
  final ProfileController profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
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
        final List<Match> fetchedMatches =
            matchesData.map((json) => Match.fromJson(json)).toList();

        // 3. Assign the newly parsed list to our observable.
        matchList.assignAll(fetchedMatches);
      } else {
        // If the API reports success: false, throw an error to be caught below
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessage('Failed to load matches. Please try again.');
      print('MatchController Error: $e'); // For debugging
    } finally {
      isLoading(false);
    }
  }
}
