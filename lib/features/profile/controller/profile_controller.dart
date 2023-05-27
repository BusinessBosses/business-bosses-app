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
    final UserModel modelizedData = UserModel.fromMap({
      ...userData,
      'connections': userData['connections']['connections'],
      'connecteds': userData['connecteds']
    });
    myProfile = modelizedData;
    update();
  }

  void updateCoinCount(int num) {
    myProfile = UserModel.fromMap(
        {...myProfile.toMap(), 'coinscount': myProfile.coinscount! + num});
    update();
  }

  /// UPDATE USER DATA
  void updateProfile(Map<String, dynamic> newData) {
    myProfile = UserModel.fromMap(newData);
    update();
  }

  void updateConnections(String uid) {
    final bool checkIfConnected = myProfile.connecteds == null
        ? false
        : myProfile.connecteds!.contains(uid);
    final List<String>? newConnecteds = checkIfConnected
        ? myProfile.connecteds?.where((String element) => element != uid).toList()
        : myProfile.connecteds == null
            ? [uid]
            : [...myProfile.connecteds!, uid];
    myProfile = UserModel.fromMap({
      ...myProfile.toMap(),
      'connecteds': newConnecteds,
      'connectedCount': checkIfConnected
          ? myProfile.connectedCount! - 1
          : myProfile.connectedCount! + 1
    });

    update();
  }

  static Future<Map<String, dynamic>> loadData(String userId) async {
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
      // print({
      //   ...response.data['user']['data'],
      //   'connections': response.data['user']['data']['connections']
      //       ['connections']
      // });
      return {
        'posts': posts,
        'user': {
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              ['connections']
        }
      };
    } else {
      return {
        'posts': [],
        'user': {
          ...response.data['user']['data'],
          'connections': response.data['user']['data']['connections']
              ['connections']
        }
      };
    }
  }
}
