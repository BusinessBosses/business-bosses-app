import 'dart:convert';

import '../../../services/api_service.dart';
import '../../../common/models/api_response_model.dart';

/// INDUSTRY MODEL
class Industry {
  String? industryId;
  String? industry;
  String? photo;
  String? description;
  int? timestamp;
  bool? active;
  String? categoryId;
  List<String>? joinedUsers;
  String? criteria;
  String? award;
  String? createTitle;
  String? createInfo;
  String? createDescription;
  DateTime? startAt; // Updated to DateTime
  DateTime? endedAt; // Updated to DateTime

  /// INDUSTRY MODEL
  Industry({
    this.industryId,
    this.industry,
    this.photo,
    this.description,
    this.timestamp,
    this.active,
    this.categoryId,
    this.joinedUsers,
    this.award,
    this.criteria,
    this.createTitle,
    this.createInfo,
    this.createDescription,
    this.startAt,
    this.endedAt,
  });

  factory Industry.toObject(Map<dynamic, dynamic> map) {
    return Industry(
      industryId: map['industryId'] as String,
      industry: map['industry'] as String,
      photo: map['photo'] as String,
      description: map['description'] as String,
      active: map['active'] as bool,
      timestamp: int.parse(map['timestamp'].toString()),
      categoryId: map['categoryId'] as String,
      joinedUsers: map['joinedUsers'] == null
          ? <String>[]
          : List<String>.from(map['joinedUsers']),
      criteria: map['criteria'] as String?,
      award: map['award'] as String?,
      createTitle: map['createTitle'] as String?,
      createInfo: map['createInfo'] as String?,
      createDescription: map['createDescription'] as String?,
      startAt: map['startAt'] == null
          ? null
          : DateTime.parse(map['startAt'] as String),
      endedAt: map['endedAt'] == null
          ? null
          : DateTime.parse(map['endedAt'] as String),
    );
  }

  factory Industry.fromMap(Map<String, dynamic> map) {
    return Industry(
      industryId: map['industryId'],
      industry: map['industry'],
      photo: map['photo'],
      description: map['description'],
      timestamp: map['timestamp'],
      active: map['active'],
      categoryId: map['categoryId'],
      joinedUsers: List<String>.from(map['joinedUsers'] ?? []),
      criteria: map['criteria'],
      award: map['award'],
      createTitle: map['createTitle'],
      createInfo: map['createInfo'],
      createDescription: map['createDescription'],
      startAt: map['startAt'] != null ? DateTime.parse(map['startAt']) : null,
      endedAt: map['endedAt'] != null ? DateTime.parse(map['endedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'industryId': industryId,
      'industry': industry,
      'photo': photo,
      'description': description,
      'timestamp': timestamp,
      'active': active,
      'categoryId': categoryId,
      'joinedUsers': joinedUsers,
      'criteria': criteria,
      'award': award,
      'createTitle': createTitle,
      'createInfo': createInfo,
      'createDescription': createDescription,
      'startAt': startAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
    };
  }

  static List<Industry> toIndustries({
    required List snapshot,
  }) {
    List<Industry> industries = <Industry>[];
    for (int i = 0; i < snapshot.length; i++) {
      final Industry industry = Industry.toObject(snapshot[i]);
      industries.add(industry);
    }
    // snapshot.forEach((key, data) {
    //   final Industry industry = Industry.toObject(data);
    //   if (industry.active ?? true) industries.add(industry);
    // });
    return industries;
  }

  static List<Industry> toJustSortIndustryList(List<dynamic> responseData) {
    // ignore: unnecessary_null_comparison
    if (responseData == null) return <Industry>[];
    List<Industry> items = <Industry>[];
    for (final postJson in responseData) {
      Industry pt = Industry.toObject(postJson);
      items.add(pt);
    }
    items.sort(
        (Industry a, Industry b) => b.timestamp!.compareTo(a.timestamp as num));
    return items;
  }

  Future<List<Industry>> fetchIndustry() async {
    final ApiResponseModel response =
        await ApiService.get(path: Uri.parse('industry/get').toString());

    if (response.success == true) {
      final List<dynamic> responseData = jsonDecode(response.data.rows);
      final List<Industry> industries =
          Industry.toJustSortIndustryList(responseData);

      return industries;
    } else {
      throw Exception('Failed to fetch industries');
    }
  }
}
