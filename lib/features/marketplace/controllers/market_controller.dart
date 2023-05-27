import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/market_model.dart';

class MarketController extends GetxController {
  late IO.Socket socket;
  RxList<MarketModel> markets = RxList<MarketModel>(<MarketModel>[]);
  List<Map<String, dynamic>> mixedPosts = [];
  RxInt paginationPage = RxInt(0);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);
  // final ProfileController _profileController = Get.find();

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      markets.add(MarketModel.fromMap({
        ...psts[i],
      }));
    }
    update();
  }

  /// ADD NEW POST TO STATE
  void addNewPost(
      Map<String, dynamic> newPost, ProfileController profileController) async {
    MarketModel modelizedNewPost = MarketModel.fromMap({
      ...newPost,
      'userId': profileController.myProfile.uid,
      'promote': false,
      'user': {
        'username': profileController.myProfile.username,
        'email': profileController.myProfile.email,
        'uid': profileController.myProfile.uid,
        'name': profileController.myProfile.name,
      }
    });

    markets.insert(0, modelizedNewPost);

    update();
  }

  initMarket() async {
    ApiResponseModel response = await ApiService.get(path: 'markets/all');
    processPostsToState(response.data['rows']);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initMarket();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
