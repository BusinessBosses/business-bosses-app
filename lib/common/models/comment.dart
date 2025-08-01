import 'my_user.dart';

class Comment {
  String? commentId;
  String? uid;
  // String userName;
  // String userPhotoUrl;
  // String userBio;
  String? comment;
  int? timestamp;
  MyUser? user;

  Comment({
    this.commentId,
    this.uid,
    // this.userName,
    // this.userPhotoUrl,
    // this.userBio,
    this.comment,
    this.timestamp,
    this.user,
  });

  factory Comment.toObject(Map<dynamic, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      uid: map['uid'] as String,
      // userName: map['userName'] as String,
      // userPhotoUrl: map['userPhotoUrl'] as String,
      // userBio: map['userBio'] as String,
      comment: map['comment'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

  Map<String, dynamic> toMapToComment() {
    // ignore: unnecessary_cast
    return <String, Object?>{
      'commentId': commentId,
      'uid': uid,
      // 'userName': this.userName,
      // 'userPhotoUrl': this.userPhotoUrl,
      // 'userBio': this.userBio,
      'comment': comment,
      'timestamp': timestamp,
    } as Map<String, dynamic>;
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return <String, Object?>{
      'commentId': commentId,
      'uid': uid,
      // 'userName': this.userName,
      // 'userPhotoUrl': this.userPhotoUrl,
      // 'userBio': this.userBio,
      'comment': comment,
      'timestamp': timestamp,
    } as Map<String, dynamic>;
  }

  static List<Comment> toCommentList(Map<dynamic, dynamic> map) {
    List<Comment> comments = <Comment>[];
    map.forEach((dynamic key, dynamic data) {
      final Comment comment = Comment.toObject(data);
      comments.add(comment);
    });
    return comments;
  }

  static Map<dynamic, dynamic> toMapList(List<Comment> items) {
    Map<dynamic, dynamic> map = <dynamic, dynamic>{};
    for (Comment element in items) {
      map[element.commentId] = element.toMap();
    }
    return map;
  }
}
