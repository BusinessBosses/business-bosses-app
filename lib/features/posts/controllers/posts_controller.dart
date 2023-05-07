import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/repository/post_repository.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  RxList<PostModel> posts = RxList<PostModel>(<PostModel>[]);
  RxInt paginationPage = RxInt(0);
  final int postsSize = 20;
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);

  /// PROCESS RAW API DATA, MODELIZE AND SAVE TO STATE
  void processPostsToState(dynamic post) {
    final List psts = post;
    for (int i = 0; i < psts.length; i++) {
      posts.add(PostModel.fromMap({
        ...psts[i],
        'likes':
            psts[i]['likes'].map((like) => like['userId'].toString()).toList(),
        'coins':
            psts[i]['likes'].map((coin) => coin['userId'].toString()).toList()
      }));
    }
  }

  /// ADD NEW POST TO STATE
  void addNewPost(Map<String, dynamic> newPost) {
    PostModel modelizedNewPost = PostModel.fromMap({
      ...newPost,
      'coins': [],
      'likes': [],
      'comments': [],
      'user': {
        'username': 'testUser1',
        'email': 'test1@gmail.com',
        'uid': '4cc78ac9-df9b-43ad-b63e-de769b1fdfb1',
      }
    });
    // modelizedNewPost.coins = <String>[];
    // modelizedNewPost.comments = <CommentModel>[];
    // modelizedNewPost.likes = <String>[];

    posts.insert(0, modelizedNewPost);

    update();
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadPosts() async {
    loading(true);
    error(false);
    final ApiResponseModel response =
        await PostRepository.fetchPosts(paginationPage.value, postsSize);
    if (response.success) {
      paginationPage(paginationPage.value + 1);
      processPostsToState(response.data['rows']);
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    loadPosts();
    super.onInit();
  }
}
