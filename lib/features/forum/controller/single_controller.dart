import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/repository/forum_repository.dart';
import 'package:get/get.dart';

class SingleController extends GetxController {
  ForumModel? forum;
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  Future<void> fetchForum(ForumModel toLoadForum) async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response =
        await ForumRepository.getForum(toLoadForum.forumId);
    if (response.success) {
      if (response.data != null) {
        forum = ForumModel.fromMap(<String, dynamic>{
          ...response.data,
          'likes': response.data['likes']
              .map((dynamic like) => like['userId'].toString())
              .toList(),
          'coins': response.data['coins']
              .map((dynamic coin) => coin['userId'].toString())
              .toList()
        });
      }
    } else {
      error(true);
    }
    loading(false);

    update();
  }
}
