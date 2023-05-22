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
          ? []
          : List<String>.from(map['joinedUsers']),
    );
  }

  static List<Industry> toIndustries({
    required List snapshot,
  }) {
    List<Industry> industries = [];
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
    if (responseData == null) return [];
    List<Industry> items = [];
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
