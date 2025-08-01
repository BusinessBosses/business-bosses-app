import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CommentController extends GetxController {
  late io.Socket socket;
  List<CommentModel> comments = <CommentModel>[];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  Future<void> fetchComments(String postId) async {
    loading(true);
    error(false);
    comments.clear();
    update();
    ApiResponseModel response;
    response = await HomeRepository.fetchComments(postId);
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        comments.add(CommentModel.fromMap(<String, dynamic>{
          ...response.data['rows'][i],
        }));
      }
    } else {
      error(true);
    }
    loading(false);

    update();
  }

  @override
  void onInit() {
    //
    super.onInit();
  }

  @override
  void dispose() {
    //
    super.dispose();
  }
}
