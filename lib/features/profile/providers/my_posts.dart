import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../posts/models/post_model.dart';

class MyPosts with ChangeNotifier {
  List<PostModel> _items = [];

  void initializerPost(List<PostModel> posts) {
    _items = posts;
    scheduleMicrotask(() => notifyListeners());
  }

  List<PostModel> get posts {
    return [..._items];
  }

  void updatePost(PostModel post) {
    int index = _items.indexWhere((PostModel p) => p.postId == post.postId);
    if (index != -1) {
      _items[index] = post;
      scheduleMicrotask(() => notifyListeners());
    }
  }

  void deletePost(String postId) {
    int index = _items.indexWhere((PostModel p) => p.postId == postId);
    if (index != -1) {
      _items.removeAt(index);
      scheduleMicrotask(() => notifyListeners());
    }
  }

  // ============ POST GALLERY ============

  List<PostGallery> _postGalleryItems = [];

  void initializerPostGallery(List<PostGallery> postGallery) {
    _postGalleryItems = postGallery;
    scheduleMicrotask(() => notifyListeners());
  }

  void addPost(PostModel post) {
    _items.insert(0, post);
  }

  // void addToPostGallery(Post post_and_forum) {
  //   debugPrint(
  //       '_postGalleryItem: length: ${_postGalleryItems.length}: post_and_forum: ${post_and_forum.images.length}');
  //   MyFirebase firebase = MyFirebase();
  //   List<PostGallery> pgs = firebase.toAPostGallery(post_and_forum: post_and_forum);
  //   for (int i = 0; i < pgs.length; i++) {
  //     _postGalleryItems.insert(0, pgs[i]);
  //   }
  //   // debugPrint('pgs: ${pgs.length}');
  //   // pgs.map((pg) {
  //   //   _postGalleryItems.insert(0, pg);
  //   // });
  //   notifyListeners();
  //   debugPrint('_postGalleryItem: legth: ${_postGalleryItems.length}');
  // }

  List<PostGallery> get postGalleryItems {
    // if (_items.length <= _loadedNumberOfPostOnce) {
    //   totalDisplayed = _items.length;
    // notifyListeners();
    return [..._postGalleryItems];
    // } else {
    //   displayNextPost();
    //   return [..._postGalleryItem];
    // }
  }

// void displayNextPost() {
//   if (total <= totalDisplayed) return;
//   int i;
//   for (i = totalDisplayed;
//       i <= min(_items.length, totalDisplayed + _loadedNumberOfPostOnce);
//       i++) {
//     _displayedItems.add(_items[i]);
//   }
//   totalDisplayed = i - 1;
//   // notifyListeners();
// }
//
// List<Post> get items {
//   return _items;
// }
}

class PostGallery {
  String? image;
  String? postId;
  String? userUid;

  PostGallery({
    this.image,
    this.postId,
    this.userUid,
  });
}
