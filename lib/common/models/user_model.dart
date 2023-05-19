// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
  final String? bio;
  final String? website;
  final String? instagram;
  final String? twitter;
  final String? industry;
  final String? category;
  final String? location;
  final List<String>? achievements;
  final List<String>? productsandservices;
  final List<ReferralsModel>? refers;
  final List<String>? deviceTokens;
  final List<String>? connections;
  final List<String>? connecteds;
  final List<DisconnectionsModel>? disconnections;
  final bool? active;
  final bool? deactivated;
  final String? ageRange;
  final String? gender;
  final List<ProfileViewerModel>? profileViews;
  late final int? connectionCount;
  final int? connectedCount;
  final int? unReadCount;
  final bool? isRanked;
  final String? inviteId;

  UserModel(
      {this.uid = '',
      this.username = '',
      this.email = '',
      this.timestamp,
      this.bossOfTheWeekTimeStamp,
      this.bossOfTheWeekUpTimeStamp,
      this.photoUrl,
      this.coinscount,
      this.name,
      this.companyName,
      this.surname,
      this.bio,
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
      this.connections,
      this.connecteds,
      this.inviteId});

  UserModel copyWith(
      {String? uid,
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
      List<String>? achievements,
      List<String>? productsandservices,
      List<ReferralsModel>? refers,
      List<String>? deviceTokens,
      List<String>? connections,
      List<String>? connecteds,
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
      String? inviteId}) {
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
      inviteId: inviteId ?? this.inviteId,
      connections: connections ?? this.connections,
      connecteds: connecteds ?? this.connecteds,
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
      'connections': connections,
      'connecteds': connecteds,
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
      'inviteId': inviteId,
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
      bio: map['bio'] != null ? map['bio'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      industry: map['industry'] != null ? map['industry'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      achievements: map['achievements'] != null
          ? List<String>.from((map['achievements']))
          : null,
      productsandservices: map['productsandservices'] != null
          ? List<String>.from((map['productsandservices']))
          : null,
      refers: map['refers'] != null
          ? List<ReferralsModel>.from(
              (map['refers'] as List<int>).map<ReferralsModel?>(
                (x) => ReferralsModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      deviceTokens: map['deviceTokens'] != null
          ? List<String>.from((map['deviceTokens'] as List<String>))
          : null,
      connections: map['connections'] != null
          ? List<String>.from((map['connections']))
          : null,
      connecteds: map['connecteds'] != null
          ? List<String>.from((map['connecteds']))
          : null,
      disconnections: map['disconnections'] != null
          ? List<DisconnectionsModel>.from(
              (map['disconnections'] as List<int>).map<DisconnectionsModel?>(
                (x) => DisconnectionsModel.fromMap(x as Map<String, dynamic>),
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
                (x) => ProfileViewerModel.fromMap(x as Map<String, dynamic>),
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
      inviteId: map['inviteId'] != null ? map['inviteId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, timestamp: $timestamp, bossOfTheWeekTimeStamp: $bossOfTheWeekTimeStamp, bossOfTheWeekUpTimeStamp: $bossOfTheWeekUpTimeStamp, photoUrl: $photoUrl, coinscount: $coinscount, name: $name, companyName: $companyName, surname: $surname, bio: $bio, website: $website, instagram: $instagram, twitter: $twitter, industry: $industry, category: $category, location: $location, achievements: $achievements, productsandservices: $productsandservices, refers: $refers, deviceTokens: $deviceTokens, disconnections: $disconnections, active: $active, deactivated: $deactivated, ageRange: $ageRange, gender: $gender, profileViews: $profileViews, connectionCount: $connectionCount, connectedCount: $connectedCount, unReadCount: $unReadCount, isRanked: $isRanked)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.timestamp == timestamp &&
        other.bossOfTheWeekTimeStamp == bossOfTheWeekTimeStamp &&
        other.bossOfTheWeekUpTimeStamp == bossOfTheWeekUpTimeStamp &&
        other.photoUrl == photoUrl &&
        other.coinscount == coinscount &&
        other.name == name &&
        other.companyName == companyName &&
        other.surname == surname &&
        other.bio == bio &&
        other.website == website &&
        other.instagram == instagram &&
        other.twitter == twitter &&
        other.industry == industry &&
        other.category == category &&
        other.location == location &&
        listEquals(other.achievements, achievements) &&
        listEquals(other.productsandservices, productsandservices) &&
        listEquals(other.refers, refers) &&
        listEquals(other.deviceTokens, deviceTokens) &&
        listEquals(other.connections, connections) &&
        listEquals(other.connecteds, connecteds) &&
        listEquals(other.disconnections, disconnections) &&
        other.active == active &&
        other.deactivated == deactivated &&
        other.ageRange == ageRange &&
        other.gender == gender &&
        listEquals(other.profileViews, profileViews) &&
        other.connectionCount == connectionCount &&
        other.connectedCount == connectedCount &&
        other.unReadCount == unReadCount &&
        other.isRanked == isRanked &&
        other.inviteId == inviteId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        timestamp.hashCode ^
        bossOfTheWeekTimeStamp.hashCode ^
        bossOfTheWeekUpTimeStamp.hashCode ^
        photoUrl.hashCode ^
        coinscount.hashCode ^
        name.hashCode ^
        companyName.hashCode ^
        surname.hashCode ^
        bio.hashCode ^
        website.hashCode ^
        instagram.hashCode ^
        twitter.hashCode ^
        industry.hashCode ^
        category.hashCode ^
        location.hashCode ^
        achievements.hashCode ^
        productsandservices.hashCode ^
        refers.hashCode ^
        deviceTokens.hashCode ^
        connections.hashCode ^
        connecteds.hashCode ^
        disconnections.hashCode ^
        active.hashCode ^
        deactivated.hashCode ^
        ageRange.hashCode ^
        gender.hashCode ^
        profileViews.hashCode ^
        connectionCount.hashCode ^
        connectedCount.hashCode ^
        unReadCount.hashCode ^
        inviteId.hashCode ^
        isRanked.hashCode;
  }
}
