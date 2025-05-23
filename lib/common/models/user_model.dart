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

  // final List<String>? deviceTokens;

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
    // this.deviceTokens,
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

    // List<String>? deviceTokens,

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
    bool? isUpdated,
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
      // deviceTokens: deviceTokens ?? this.deviceTokens,
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
      // 'deviceTokens': deviceTokens,
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
      postChallenges: map['postChallenges'] != null
          ? List<String>.from((map['postChallenges']))
          : null,
      interests: map['interests'] != null
          ? List.from(map['interests'])
              .map((e) => Industry.toObject(e as Map<String, dynamic>))
              .toList()
          : null,
      productsandservices: map['productsandservices'] == null ||
              map['productsandservices'].runtimeType == String
          ? null
          : List<String>.from((map['productsandservices'])),

      referals: map['referals'] != null
          ? List.from(map['referals'])
              .map((e) => ReferralsModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,

      // deviceTokens: map['deviceTokens'] != null
      //     ? List<String>.from((map['deviceTokens'] as List<String>))
      //     : null,

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
      unReadCount: map['unReadCount'] != null ? map['unReadCount'] as int : 0,
      isRanked: map['isRanked'] != null ? map['isRanked'] as bool : null,
      isSubscribed:
          map['isSubscribed'] != null ? map['isSubscribed'] as bool : false,
      toPost: map['toPost'] != null ? map['toPost'] as bool : false,
      isUpdated: map['isUpdated'] != null ? map['isUpdated'] as bool : false,
      inviteId: map['inviteId'] != null ? map['inviteId'] as String : null,
      weeklyRank:
          map['weeklyRank'] != null ? map['weeklyRank'] as String : null,
      monthlyRank:
          map['monthlyRank'] != null ? map['monthlyRank'] as String : null,
      averageRating: map['averageRating'] != null
          ? (map['averageRating'] is int
              ? (map['averageRating'] as int).toDouble()
              : map['averageRating'] as double)
          : null,
      hasShop: map['hasShop'] != null ? map['hasShop'] as bool : false,
    );
  }

  int get coinsCount => coinscount ?? 0;

  void incrementCoinsCount(int incrementBy) {
    coinscount = (coinscount ?? 0) + incrementBy;
  }
}
