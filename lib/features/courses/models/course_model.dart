// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';

class CourseModel {
  final int id;
  final String industryId;
  final String? description;
  final String? title;
  final String userId;
  final String? price;
  final dynamic promotionDuration;
  final List<String>? documents;
  final int? timestamp;
  final List<CommentModel>? comments;
  final UserModel? user;
  int? views = 0;
  final bool? isPromoted;
  final bool? isApproved;
  final String? courseType;
  final String? paymentMethod;
  final String? transcript;
  final List<String>? youtubeUrls;
  CourseModel({
    required this.id,
    required this.industryId,
    required this.userId,
    this.description,
    this.title,
    this.documents,
    this.timestamp,
    this.views = 0,
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
    int? id,
    String? industryId,
    String? description,
    String? title,
    String? userId,
    List<String>? documents,
    int? timestamp,
    List<CommentModel>? comments,
    UserModel? user,
    bool? isPromoted,
    int? views,
    String? price,
    dynamic promotionDuration,
    bool? isApproved,
    String? courseType,
    String? paymentMethod,
    String? transcript,
    List<String>? youtubeUrls,
  }) {
    return CourseModel(
      id: id ?? this.id,
      industryId: industryId ?? this.industryId,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      documents: documents ?? this.documents,
      timestamp: timestamp ?? this.timestamp,
      comments: comments ?? this.comments,
      user: user ?? this.user,
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
      'userId': userId,
      'documents': documents,
      'timestamp': timestamp,
      'comments': comments!.map((CommentModel x) => x.toMap()).toList(),
      'user': user!.toMap(),
      'views': views,
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
      id: map['id'] as int,
      industryId: map['industryId'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      userId: map['userId'] as String,
      price: map['price'] != null ? map['price'] as String : null,
      courseType:
          map['courseType'] != null ? map['courseType'] as String : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      transcript:
          map['transcript'] != null ? map['transcript'] as String : null,
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
      comments: List.from(map['comments'])
          .map((e) => CommentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      views: map['views'] != null ? map['views'] as int : 0,
      isPromoted: map['isPromoted'] ?? false,
      isApproved: map['isApproved'] ?? false,
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

  void setViews(int newViews) {
    views = newViews;
  }
}
