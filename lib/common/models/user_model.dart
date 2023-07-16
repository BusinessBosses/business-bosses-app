// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:business_bosses_v2/features/forum/models/industry.dart';
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
  final List<Industry>? interests;
  final List<String>? productsandservices;
  final List<ReferralsModel>? referals;
  String? deviceTokens;
  final List<String>? connections;
  final List<String>? connecteds;
  final List<DisconnectionsModel>? disconnections;
  final bool? active;
  final bool? deactivated;
  final bool isSubscribed;
  final String? ageRange;
  final String? gender;
  final List<ProfileViewerModel>? profileViews;
  late final int? connectionCount;
  final int? connectedCount;
  final int? referalCount;
  final int? invitations;
  final int? unReadCount;
  final bool? isRanked;
  final String? inviteId;
  final double? averageRating;

  UserModel({
    this.uid = '',
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
    this.interests,
    this.productsandservices,
    this.referals,
    this.deviceTokens,
    this.invitations,
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
    this.referalCount,
    this.inviteId,
    this.averageRating,
    this.isSubscribed = false,
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
    List<String>? achievements,
    List<Industry>? interests,
    List<String>? productsandservices,
    List<ReferralsModel>? referals,
    String? deviceTokens,
    List<String>? connections,
    List<String>? connecteds,
    List<DisconnectionsModel>? disconnections,
    bool? active,
    bool? deactivated,
    String? ageRange,
    String? gender,
    List<ProfileViewerModel>? profileViews,
    int? connectionCount,
    int? referalCount,
    int? invitations,
    int? connectedCount,
    int? unReadCount,
    bool? isRanked,
    String? inviteId,
    double? averageRating,
    bool? isSubscribed = false,
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
      interests: interests ?? this.interests,
      productsandservices: productsandservices ?? this.productsandservices,
      referals: referals ?? this.referals,
      deviceTokens: deviceTokens ?? this.deviceTokens,
      disconnections: disconnections ?? this.disconnections,
      active: active ?? this.active,
      deactivated: deactivated ?? this.deactivated,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      profileViews: profileViews ?? this.profileViews,
      connectionCount: connectionCount ?? this.connectionCount,
      referalCount: referalCount ?? this.referalCount,
      invitations: invitations ?? this.invitations,
      connectedCount: connectedCount ?? this.connectedCount,
      unReadCount: unReadCount ?? this.unReadCount,
      isRanked: isRanked ?? this.isRanked,
      inviteId: inviteId ?? this.inviteId,
      connections: connections ?? this.connections,
      connecteds: connecteds ?? this.connecteds,
      averageRating: averageRating ?? this.averageRating,
      isSubscribed: isSubscribed ?? this.isSubscribed,
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
      'interests': interests?.map((Industry x) => x.toMap()).toList(),
      'productsandservices': productsandservices,
      'referals': referals?.map((ReferralsModel x) => x.toMap()).toList(),
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
      'referalCount': referalCount,
      'invitations': invitations,
      'connectedCount': connectedCount,
      'unReadCount': unReadCount,
      'isRanked': isRanked,
      'inviteId': inviteId,
      'averageRating': averageRating,
      'isSubscribed': isSubscribed,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
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
      interests: map['interests'] != null
          ? List.from(map['interests'])
              .map((e) => Industry.toObject(e as Map<String, dynamic>))
              .toList()
          : null,
      productsandservices: map['productsandservices'] != null
          ? List<String>.from((map['productsandservices']))
          : null,
      referals: map['referals'] != null
          ? List.from(map['referals'])
              .map((e) => ReferralsModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      deviceTokens:
          map['deviceTokens'] != null ? map['deviceTokens'] as String : null,
      connections: map['connections'] != null
          ? List<String>.from((map['connections']))
          : null,
      connecteds: map['connecteds'] != null
          ? List<String>.from((map['connecteds']))
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
      referalCount:
          map['referalCount'] != null ? map['referalCount'] as int : null,
      invitations:
          map['invitations'] != null ? map['invitations'] as int : null,
      connectedCount:
          map['connectedCount'] != null ? map['connectedCount'] as int : null,
      unReadCount:
          map['unReadCount'] != null ? map['unReadCount'] as int : null,
      isRanked: map['isRanked'] != null ? map['isRanked'] as bool : null,
      isSubscribed:
          map['isSubscribed'] != null ? map['isSubscribed'] as bool : false,
      inviteId: map['inviteId'] != null ? map['inviteId'] as String : null,
      averageRating: map['averageRating'] != null
          ? (map['averageRating'] is int
              ? (map['averageRating'] as int).toDouble()
              : map['averageRating'] as double)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, timestamp: $timestamp, bossOfTheWeekTimeStamp: $bossOfTheWeekTimeStamp, bossOfTheWeekUpTimeStamp: $bossOfTheWeekUpTimeStamp, photoUrl: $photoUrl, coinscount: $coinscount, name: $name, companyName: $companyName, surname: $surname, bio: $bio, website: $website, instagram: $instagram, twitter: $twitter, industry: $industry, category: $category, location: $location, achievements: $achievements, productsandservices: $productsandservices, referals: $referals, deviceTokens: $deviceTokens, disconnections: $disconnections, active: $active, deactivated: $deactivated, ageRange: $ageRange, gender: $gender, profileViews: $profileViews, connectionCount: $connectionCount, connectedCount: $connectedCount, unReadCount: $unReadCount, isRanked: $isRanked, averageRating: $averageRating)';
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
        listEquals(other.referals, referals) &&
        other.deviceTokens == deviceTokens &&
        listEquals(other.connections, connections) &&
        listEquals(other.connecteds, connecteds) &&
        listEquals(other.disconnections, disconnections) &&
        other.active == active &&
        other.deactivated == deactivated &&
        other.ageRange == ageRange &&
        other.gender == gender &&
        listEquals(other.profileViews, profileViews) &&
        other.connectionCount == connectionCount &&
        other.referalCount == referalCount &&
        other.invitations == invitations &&
        other.connectedCount == connectedCount &&
        other.unReadCount == unReadCount &&
        other.isRanked == isRanked &&
        other.inviteId == inviteId &&
        other.isSubscribed == isSubscribed &&
        other.averageRating == averageRating;
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
        referals.hashCode ^
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
        referalCount.hashCode ^
        invitations.hashCode ^
        connectedCount.hashCode ^
        unReadCount.hashCode ^
        inviteId.hashCode ^
        isRanked.hashCode ^
        isSubscribed.hashCode ^
        averageRating.hashCode;
  }
}
