// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:business_bosses_v2/common/models/disconnections_models.dart';
import 'package:business_bosses_v2/common/models/profile_viewer_model.dart';
import 'package:business_bosses_v2/common/models/referrals_model.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final int? timestamp;
  final int? bossOfTheWeekTimeStamp;
  final int? bossOfTheWeekUpTimeStamp;
  final String? photoUrl;
  final int? coinscount;
  final String? name;
  final String? companyName;
  final String? surname;
  final String bio;
  final String? website;
  final String? instagram;
  final String? twitter;
  final String? industry;
  final String? category;
  final String? location;
  final String? achievements;
  final String? productsandservices;
  final List<ReferralsModel>? refers;
  final List<String>? deviceTokens;
  final List<DisconnectionsModel>? disconnections;
  final bool? active;
  final bool? deactivated;
  final String? ageRange;
  final String? gender;
  final List<ProfileViewerModel>? profileViews;

  // List<MyConnect> connects;

  final int? connectionCount;
  final int? connectedCount;
  final int? unReadCount;
  final bool? isRanked;
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.timestamp,
    this.bossOfTheWeekTimeStamp,
    this.bossOfTheWeekUpTimeStamp,
    this.photoUrl,
    this.coinscount,
    this.name,
    this.companyName,
    this.surname,
    required this.bio,
    this.website,
    this.instagram,
    this.twitter,
    this.industry,
    this.category,
    this.location,
    this.achievements,
    this.productsandservices,
    this.refers,
    this.deviceTokens,
    this.disconnections,
    this.active,
    this.deactivated,
    this.ageRange,
    this.gender,
    this.profileViews,
    this.connectionCount,
    this.connectedCount,
    this.unReadCount,
    this.isRanked,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    int? timestamp,
    int? bossOfTheWeekTimeStamp,
    int? bossOfTheWeekUpTimeStamp,
    String? photoUrl,
    int? coinscount,
    String? name,
    String? companyName,
    String? surname,
    String? bio,
    String? website,
    String? instagram,
    String? twitter,
    String? industry,
    String? category,
    String? location,
    String? achievements,
    String? productsandservices,
    List<ReferralsModel>? refers,
    List<String>? deviceTokens,
    List<DisconnectionsModel>? disconnections,
    bool? active,
    bool? deactivated,
    String? ageRange,
    String? gender,
    List<ProfileViewerModel>? profileViews,
    int? connectionCount,
    int? connectedCount,
    int? unReadCount,
    bool? isRanked,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      timestamp: timestamp ?? this.timestamp,
      bossOfTheWeekTimeStamp:
          bossOfTheWeekTimeStamp ?? this.bossOfTheWeekTimeStamp,
      bossOfTheWeekUpTimeStamp:
          bossOfTheWeekUpTimeStamp ?? this.bossOfTheWeekUpTimeStamp,
      photoUrl: photoUrl ?? this.photoUrl,
      coinscount: coinscount ?? this.coinscount,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      surname: surname ?? this.surname,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      industry: industry ?? this.industry,
      category: category ?? this.category,
      location: location ?? this.location,
      achievements: achievements ?? this.achievements,
      productsandservices: productsandservices ?? this.productsandservices,
      refers: refers ?? this.refers,
      deviceTokens: deviceTokens ?? this.deviceTokens,
      disconnections: disconnections ?? this.disconnections,
      active: active ?? this.active,
      deactivated: deactivated ?? this.deactivated,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      profileViews: profileViews ?? this.profileViews,
      connectionCount: connectionCount ?? this.connectionCount,
      connectedCount: connectedCount ?? this.connectedCount,
      unReadCount: unReadCount ?? this.unReadCount,
      isRanked: isRanked ?? this.isRanked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'timestamp': timestamp,
      'bossOfTheWeekTimeStamp': bossOfTheWeekTimeStamp,
      'bossOfTheWeekUpTimeStamp': bossOfTheWeekUpTimeStamp,
      'photoUrl': photoUrl,
      'coinscount': coinscount,
      'name': name,
      'companyName': companyName,
      'surname': surname,
      'bio': bio,
      'website': website,
      'instagram': instagram,
      'twitter': twitter,
      'industry': industry,
      'category': category,
      'location': location,
      'achievements': achievements,
      'productsandservices': productsandservices,
      'refers': refers?.map((ReferralsModel x) => x.toMap()).toList(),
      'deviceTokens': deviceTokens,
      'disconnections':
          disconnections?.map((DisconnectionsModel x) => x.toMap()).toList(),
      'active': active,
      'deactivated': deactivated,
      'ageRange': ageRange,
      'gender': gender,
      'profileViews':
          profileViews?.map((ProfileViewerModel x) => x.toMap()).toList(),
      'connectionCount': connectionCount,
      'connectedCount': connectedCount,
      'unReadCount': unReadCount,
      'isRanked': isRanked,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      timestamp: map['timestamp'] != null ? map['timestamp'] as int : null,
      bossOfTheWeekTimeStamp: map['bossOfTheWeekTimeStamp'] != null
          ? map['bossOfTheWeekTimeStamp'] as int
          : null,
      bossOfTheWeekUpTimeStamp: map['bossOfTheWeekUpTimeStamp'] != null
          ? map['bossOfTheWeekUpTimeStamp'] as int
          : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      coinscount: map['coinscount'] != null ? map['coinscount'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      companyName:
          map['companyName'] != null ? map['companyName'] as String : null,
      surname: map['surname'] != null ? map['surname'] as String : null,
      bio: map['bio'] as String,
      website: map['website'] != null ? map['website'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      industry: map['industry'] != null ? map['industry'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      achievements:
          map['achievements'] != null ? map['achievements'] as String : null,
      productsandservices: map['productsandservices'] != null
          ? map['productsandservices'] as String
          : null,
      refers: map['refers'] != null
          ? List<ReferralsModel>.from(
              (map['refers'] as List<int>).map<ReferralsModel?>(
                (int x) => ReferralsModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      deviceTokens: map['deviceTokens'] != null
          ? List<String>.from((map['deviceTokens'] as List<String>))
          : null,
      disconnections: map['disconnections'] != null
          ? List<DisconnectionsModel>.from(
              (map['disconnections'] as List<int>).map<DisconnectionsModel?>(
                (int x) =>
                    DisconnectionsModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      active: map['active'] != null ? map['active'] as bool : null,
      deactivated:
          map['deactivated'] != null ? map['deactivated'] as bool : null,
      ageRange: map['ageRange'] != null ? map['ageRange'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      profileViews: map['profileViews'] != null
          ? List<ProfileViewerModel>.from(
              (map['profileViews'] as List<int>).map<ProfileViewerModel?>(
                (int x) =>
                    ProfileViewerModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      connectionCount:
          map['connectionCount'] != null ? map['connectionCount'] as int : null,
      connectedCount:
          map['connectedCount'] != null ? map['connectedCount'] as int : null,
      unReadCount:
          map['unReadCount'] != null ? map['unReadCount'] as int : null,
      isRanked: map['isRanked'] != null ? map['isRanked'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, timestamp: $timestamp, bossOfTheWeekTimeStamp: $bossOfTheWeekTimeStamp, bossOfTheWeekUpTimeStamp: $bossOfTheWeekUpTimeStamp, photoUrl: $photoUrl, coinscount: $coinscount, name: $name, companyName: $companyName, surname: $surname, bio: $bio, website: $website, instagram: $instagram, twitter: $twitter, industry: $industry, category: $category, location: $location, achievements: $achievements, productsandservices: $productsandservices, refers: $refers, deviceTokens: $deviceTokens, disconnections: $disconnections, active: $active, deactivated: $deactivated, ageRange: $ageRange, gender: $gender, profileViews: $profileViews, connectionCount: $connectionCount, connectedCount: $connectedCount, unReadCount: $unReadCount, isRanked: $isRanked)';
  }
}
