// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/courses/models/course_comment_model.dart';

class CourseModel {
  final String id;
  final String industryId;
  final String? description;
  final String? title;
  final String? thumbnail;
  final String? contentType;
  final String userId;
  final String? price;
  final dynamic promotionDuration;
  final List<String>? documents;
  final int? timestamp;
  late final List<String>? likes;
  final List<String>? coins;
  final List<CourseCommentModel>? comments;
  final List<String>? purchases;
  final UserModel? user;
  int views = 0;
  final bool? isPromoted;
  final double? averageRating;
  final bool? isApproved;
  final String? courseType;
  final String? paymentMethod;
  final List<String>? transcript;
  final List<String>? youtubeUrls;
  CourseModel({
    required this.id,
    required this.industryId,
    required this.userId,
    this.description,
    this.title,
    this.thumbnail,
    this.contentType,
    this.averageRating = 0.0,
    this.documents,
    this.timestamp,
    this.purchases,
    this.views = 0,
    this.likes,
    this.coins,
    this.comments,
    this.user,
    this.isPromoted,
    this.price,
    this.promotionDuration,
    this.isApproved,
    this.courseType,
    this.paymentMethod,
    this.transcript,
    this.youtubeUrls,
  });

  CourseModel copyWith({
    String? id,
    String? industryId,
    String? description,
    String? title,
    String? userId,
    String? thumbnail,
    String? contentType,
    List<String>? documents,
    int? timestamp,
    List<CourseCommentModel>? comments,
    List<String>? purchases,
    UserModel? user,
    bool? isPromoted,
    int? views,
    String? price,
    List<String>? likes,
    List<String>? coins,
    double? averageRating,
    dynamic promotionDuration,
    bool? isApproved,
    String? courseType,
    String? paymentMethod,
    List<String>? transcript,
    List<String>? youtubeUrls,
  }) {
    return CourseModel(
      id: id ?? this.id,
      industryId: industryId ?? this.industryId,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      contentType: contentType ?? this.contentType,
      documents: documents ?? this.documents,
      timestamp: timestamp ?? this.timestamp,
      comments: comments ?? this.comments,
      purchases: purchases ?? this.purchases,
      user: user ?? this.user,
      likes: likes ?? this.likes,
      coins: coins ?? this.coins,
      averageRating: averageRating ?? this.averageRating,
      views: views ?? this.views,
      isPromoted: isPromoted ?? this.isPromoted,
      price: price ?? this.price,
      promotionDuration: promotionDuration ?? this.promotionDuration,
      isApproved: isApproved ?? this.isApproved,
      courseType: courseType ?? this.courseType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transcript: transcript ?? this.transcript,
      youtubeUrls: youtubeUrls ?? this.youtubeUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'industryId': industryId,
      'description': description,
      'title': title,
      'thumbnail': thumbnail,
      'contentType': contentType,
      'averageRating': averageRating,
      'userId': userId,
      'documents': documents,
      'timestamp': timestamp,
      'comments': comments!.map((CourseCommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'views': views,
      'likes': likes,
      'coins': coins,
      'purchases': purchases,
      'isPromoted': isPromoted,
      'price': price,
      'promotionDuration': promotionDuration,
      'isApproved': isApproved,
      'courseType': courseType,
      'paymentMethod': paymentMethod,
      'transcript': transcript,
      'youtubeUrls': youtubeUrls,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      industryId: map['industryId'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      contentType:
          map['contentType'] != null ? map['contentType'] as String : null,
      userId: map['userId'] as String,
      price: map['price'] != null ? map['price'] as String : null,
      courseType:
          map['courseType'] != null ? map['courseType'] as String : null,
      averageRating: map['averageRating'] != null
          ? (map['averageRating'] is int
              ? (map['averageRating'] as int).toDouble()
              : map['averageRating'] as double)
          : 0.0,
      likes: map['likes'] != null
          ? List<String>.from(map['likes'].map((dynamic like) {
              if (like is Map<String, dynamic>) {
                return like['userId'].toString();
              }
              return like.toString();
            }))
          : null,
      coins: map['coins'] != null
          ? List<String>.from(map['coins'].map((dynamic coin) {
              if (coin is Map<String, dynamic>) {
                return coin['userId'].toString();
              }
              return coin.toString();
            }))
          : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      promotionDuration: map['promotionDuration'] != null
          ? map['promotionDuration'] as String
          : null,
      documents: map['documents'] != null && map['documents'] != ''
          ? List<String>.from((map['documents']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
                  .isEmpty
              ? null
              : List<String>.from((map['documents']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
          : null,
      timestamp: map['timestamp'] != null
          ? int.parse(map['timestamp'].toString())
          : null,
      comments: map['comments'] != null
          ? List<dynamic>.from(map['comments'])
              .map((dynamic e) =>
                  CourseCommentModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      purchases: map['purchases'] != null
          ? List<String>.from((map['purchases']))
          : null,
      views: map['views'] != null ? map['views'] as int : 0,
      isPromoted: map['isPromoted'] ?? false,
      isApproved: map['isApproved'] ?? false,
      transcript: map['transcript'] != null && map['transcript'] != ''
          ? List<String>.from((map['transcript']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
                  .isEmpty
              ? null
              : List<String>.from((map['transcript']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
          : null,
      youtubeUrls: map['youtubeUrls'] != null && map['youtubeUrls'] != ''
          ? List<String>.from((map['youtubeUrls']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
                  .isEmpty
              ? null
              : List<String>.from((map['youtubeUrls']))
                  .where((String element) => element.isNotEmpty)
                  .toList()
          : null,
    );
  }

  void setViews() {
    views += 1;
  }
}
