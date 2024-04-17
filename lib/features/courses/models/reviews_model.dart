// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/common/models/user_model.dart';

class ReviewModel {
  int id;
  String authorId;
  String courseId;
  int rating;
  String userId;
  String? reviewText;
  UserModel rater;
  String createdAt;
  ReviewModel(
      {required this.userId,
      required this.authorId,
      required this.courseId,
      required this.rating,
      required this.id,
      required this.rater,
      this.reviewText,
      required this.createdAt});

  ReviewModel copyWith({
    int? id,
    String? authorId,
    String? courseId,
    int? rating,
    String? userId,
    String? reviewText,
    UserModel? rater,
    String? createdAt,
  }) {
    return ReviewModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      courseId: courseId ?? this.courseId,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      rater: rater ?? this.rater,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'authorId': authorId,
      'courseId': courseId,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': createdAt,
      'rater': rater.toMap(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'] as String,
      createdAt: map['createdAt'] as String,
      id: map['id'] as int,
      rater: UserModel.fromMap(map['rater'] as Map<String, dynamic>),
      rating: map['rating'] as int,
      reviewText: map['reviewText'] as String,
      authorId: map['authorId'] as String,
      courseId: map['courseId'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewModel(userId: $userId, id: $id, authorId: $authorId, courseId: $courseId, rating: $rating, reviewText: $reviewText, createdAt: $createdAt, rater: $rater,)';
  }
}
