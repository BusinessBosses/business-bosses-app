import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/profile/repository/profile_repository.dart';
import 'package:get/get.dart';

/// PROFILE CONTROLLER
class ProfileController extends GetxController {
  /// MODELIZED PROFILE DATA
  UserModel myProfile = UserModel();

  ///MODELIZE RAW DATA AND PUSH TO STATE
  void processDataToState(dynamic userData) {
    final UserModel modelizedData = UserModel.fromMap(userData);
    myProfile = modelizedData;
    update();
  }

  /// UPDATE USER DATA
  void updateProfile(Map<String, dynamic> newData) {
    myProfile = UserModel.fromMap(newData);
    update();
  }

  static Future<List<PostModel>> loadData(String userId) async {
    List<PostModel> posts = [];
    final ApiResponseModel response =
        // ProfileRepos
        await ProfileRepository.fetchData(0, 50, userId);
    if (response.success) {
      final List psts = response.data['posts']['rows'];
      for (int i = 0; i < psts.length; i++) {
        posts.add(PostModel.fromMap({
          ...psts[i],
          'likes': psts[i]['likes']
              .map((like) => like['userId'].toString())
              .toList(),
          'coins':
              psts[i]['likes'].map((coin) => coin['userId'].toString()).toList()
        }));
      }

      return posts;
    } else {
      return [];
    }
  }
}
