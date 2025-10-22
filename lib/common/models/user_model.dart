// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:business_bosses_v2/features/forum/models/industry.dart';

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
  int? coinscount;
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
  final List<String>? postChallenges;
  final List<String>? achievements;
  final List<Industry>? interests;
  final List<String>? productsandservices;
  final List<ReferralsModel>? referals;
  final bool toPost;
  final String? weeklyRank;
  final String? monthlyRank;
  final bool hasShop;
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
  final bool? isUpdated;
  final String? matchType; // ✅ NEW FIELD

  /// 🏆 New Achievement Counters
  final int? bossCount;
  final int? mentorCount;
  final int? backerCount;

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
    this.postChallenges,
    this.instagram,
    this.twitter,
    this.industry,
    this.category,
    this.location,
    this.achievements,
    this.interests,
    this.productsandservices,
    this.referals,
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
    this.isUpdated,
    this.toPost = true,
    this.weeklyRank,
    this.monthlyRank,
    this.hasShop = false,
    this.matchType, // ✅
    this.bossCount, // ✅
    this.mentorCount, // ✅
    this.backerCount, // ✅
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
    List<String>? postChallenges,
    List<Industry>? interests,
    List<String>? productsandservices,
    List<ReferralsModel>? referals,
    bool? toPost,
    String? weeklyRank,
    String? monthlyRank,
    bool? hasShop,
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
    bool? isSubscribed,
    bool? isUpdated,
    String? matchType, // ✅
    int? bossCount, // ✅
    int? mentorCount, // ✅
    int? backerCount, // ✅
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
      postChallenges: postChallenges ?? this.postChallenges,
      interests: interests ?? this.interests,
      productsandservices: productsandservices ?? this.productsandservices,
      referals: referals ?? this.referals,
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
      toPost: toPost ?? this.toPost,
      weeklyRank: weeklyRank ?? this.weeklyRank,
      monthlyRank: monthlyRank ?? this.monthlyRank,
      isUpdated: isUpdated ?? this.isUpdated,
      hasShop: hasShop ?? this.hasShop,
      matchType: matchType ?? this.matchType, // ✅
      bossCount: bossCount ?? this.bossCount, // ✅
      mentorCount: mentorCount ?? this.mentorCount, // ✅
      backerCount: backerCount ?? this.backerCount, // ✅
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
      'postChallenges': postChallenges,
      'interests': interests?.map((Industry x) => x.toMap()).toList(),
      'productsandservices': productsandservices,
      'referals': referals?.map((ReferralsModel x) => x.toMap()).toList(),
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
      'isUpdated': isUpdated,
      'toPost': toPost,
      'weeklyRank': weeklyRank,
      'monthlyRank': monthlyRank,
      'hasShop': hasShop,
      'matchType': matchType, // ✅
      'bossCount': bossCount, // ✅
      'mentorCount': mentorCount, // ✅
      'backerCount': backerCount, // ✅
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      timestamp: map['timestamp'] is int ? map['timestamp'] as int : null,
      bossOfTheWeekTimeStamp: map['bossOfTheWeekTimeStamp'] is int
          ? map['bossOfTheWeekTimeStamp'] as int
          : null,
      bossOfTheWeekUpTimeStamp: map['bossOfTheWeekUpTimeStamp'] is int
          ? map['bossOfTheWeekUpTimeStamp'] as int
          : null,
      photoUrl: map['photoUrl']?.toString(),
      coinscount: map['coinscount'] is int ? map['coinscount'] as int : null,
      name: map['name']?.toString(),
      companyName: map['companyName']?.toString(),
      surname: map['surname']?.toString(),
      bio: map['bio']?.toString(),
      website: map['website']?.toString(),
      instagram: map['instagram']?.toString(),
      twitter: map['twitter']?.toString(),
      industry: map['industry']?.toString(),
      category: map['category']?.toString(),
      location: map['location']?.toString(),
      achievements: map['achievements'] is List
          ? List<String>.from(map['achievements'])
          : null,
      postChallenges: map['postChallenges'] is List
          ? List<String>.from(map['postChallenges'])
          : null,
      interests: map['interests'] is List
          ? (map['interests'] as List<dynamic>)
              .map((dynamic e) => Industry.toObject(e as Map<String, dynamic>))
              .toList()
          : null,
      productsandservices: map['productsandservices'] is List
          ? List<String>.from(map['productsandservices'])
          : null,
      referals: map['referals'] is List
          ? (map['referals'] as List<dynamic>)
              .map((dynamic e) =>
                  ReferralsModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      connections: map['connections'] is List
          ? List<String>.from(map['connections'])
          : null,
      connecteds: map['connecteds'] is List
          ? List<String>.from(map['connecteds'])
          : null,
      active: map['active'] == true,
      deactivated: map['deactivated'] == true,
      ageRange: map['ageRange']?.toString(),
      gender: map['gender']?.toString(),
      connectionCount:
          map['connectionCount'] is int ? map['connectionCount'] as int : null,
      referalCount:
          map['referalCount'] is int ? map['referalCount'] as int : null,
      invitations: map['invitations'] is int ? map['invitations'] as int : null,
      connectedCount:
          map['connectedCount'] is int ? map['connectedCount'] as int : null,
      unReadCount: map['unReadCount'] is int ? map['unReadCount'] as int : 0,
      isRanked: map['isRanked'] == true,
      isSubscribed: map['isSubscribed'] == true,
      toPost: map['toPost'] == true,
      isUpdated: map['isUpdated'] == true,
      inviteId: map['inviteId']?.toString(),
      weeklyRank: map['weeklyRank']?.toString(),
      monthlyRank: map['monthlyRank']?.toString(),
      averageRating: map['averageRating'] is num
          ? (map['averageRating'] as num).toDouble()
          : 0.0,
      hasShop: map['hasShop'] == true,
      matchType: map['matchType']?.toString(),
      bossCount: map['bossCount'] is int ? map['bossCount'] as int : 0, // ✅
      mentorCount:
          map['mentorCount'] is int ? map['mentorCount'] as int : 0, // ✅
      backerCount:
          map['backerCount'] is int ? map['backerCount'] as int : 0, // ✅
    );
  }

  int get coinsCount => coinscount ?? 0;

  void incrementCoinsCount(int incrementBy) {
    coinscount = (coinscount ?? 0) + incrementBy;
  }

  String get firstName {
    if (name == null || name!.trim().isEmpty) return '';
    return name!.trim().split(RegExp(r'\s+')).first;
  }
}
