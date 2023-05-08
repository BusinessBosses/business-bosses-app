// ignore_for_file: public_member_api_docs, always_specify_types, unnecessary_null_comparison

import 'my_refers.dart';

class MyUser {
  String uid;
  String username;
  String email;
  int timestamp;
  int bossOfTheWeekTimeStamp;
  int bossOfTheWeekUpTimeStamp;
  String photoUrl;
  num coinscount;
  String name;
  String companyName;
  String surname;
  String bio;
  String website;
  String instagram;
  String twitter;
  String industry;
  String category;
  String location;
  String achievements;
  String productsandservices;
  List<MyRefers> refers;
  List<String> deviceTokens;
  List<Disconnection> disconnections;
  bool active;
  bool deactivated;
  String ageRange;
  String gender;

  // List<MyConnect> connects;

  num connectionCount;
  num connectedCount;
  num unReadCount;
  bool isRanked;

  Map<String, dynamic> toCloudMap() {
    // ignore: unnecessary_cast
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'name': name,
      // 'companyName': this.companyName,
      // 'surname': this.surname,
      // 'bio': this.bio,
      // 'website': this.website,
      // 'instagram': this.instagram,
      // 'twitter': this.twitter,
      // 'industry': this.industry,
      // 'category': this.category,
      // 'location': this.location,
      // 'connects': this.connects,
      // 'deviceTokens': this.deviceTokens,
    } as Map<String, dynamic>;
  }

  MyUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.name,
    required this.timestamp,
    required this.photoUrl,
    required this.companyName,
    required this.surname,
    required this.bio,
    required this.website,
    required this.instagram,
    required this.twitter,
    required this.industry,
    required this.bossOfTheWeekTimeStamp,
    required this.bossOfTheWeekUpTimeStamp,
    required this.category,
    required this.location,
    required this.achievements,
    required this.productsandservices,
    // this.connects = const [],
    this.refers = const [],
    this.deviceTokens = const [],
    this.disconnections = const [],
    required this.active,
    required this.deactivated,
    required this.ageRange,
    required this.gender,
    required this.unReadCount,
    this.coinscount = 200,
    this.connectionCount = 0,
    this.connectedCount = 0,
    this.isRanked = false,
  });

  Map<String, Object> toSignUpMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'timestamp': timestamp,
      'deviceTokens': deviceTokens,
      'disconnections': disconnections,
      'unReadCount': 0,
      'coinscount': 200,
      // 'ageRange': ageRange,
      // 'gender': gender,
    };
  }

  Map<String, List<String>> toTokenMap() {
    return {
      'deviceTokens': deviceTokens,
    };
  }

  static Map<String, int> toReadNotificationMap() {
    return {
      'unReadCount': 0,
    };
  }

  Map<String, num> decreaseCoin() {
    return {
      'coinscount': coinscount - 1,
    };
  }

  Map<String, Object> toUpdateMap() {
    return {
      'companyName': companyName,
      'name': name,
      'surname': surname,
      'bossOfTheWeekTimeStamp': bossOfTheWeekTimeStamp,
      'bossOfTheWeekUpTimeStamp': bossOfTheWeekUpTimeStamp,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      // 'disconnections': disconnections,
      'website': website,
      'instagram': instagram,
      'twitter': twitter,
      'industry': industry,
      'category': category,
      'location': location,
      'ageRange': ageRange,
      'gender': gender,
      'achievements': achievements,
      'productsandservices': productsandservices,
    };
  }

  Map<String, String> toPhotoUrlMap() {
    return {
      'photoUrl': photoUrl,
    };
  }

  Map<String, bool> toDeactivatedMap(bool deactivatedValue) {
    return {'deactivated': deactivatedValue};
  }

  Map<String, List<String>> toTokenUpdateMap() {
    return {
      'deviceTokens': deviceTokens,
    };
  }

  factory MyUser.fromMap(Map map) {
    // print('MyUser.fromMapdata is in repo: ${map}');
    // print("");
    return MyUser(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      timestamp: map['timestamp'],
      photoUrl: map['photoUrl'],
      name: map['name'],
      companyName: map['companyName'],
      surname: map['surname'],
      bio: map['bio'],
      bossOfTheWeekTimeStamp: map['bossOfTheWeekTimeStamp'],
      bossOfTheWeekUpTimeStamp: map['bossOfTheWeekUpTimeStamp'],
      website: map['website'],
      instagram: map['instagram'],
      twitter: map['twitter'],
      industry: map['industry'],
      category: map['category'],
      location: map['location'],
      achievements: map['achievements'],
      productsandservices: map['productsandservices'],
      active: map['active'],
      deactivated: map['deactivated'],
      ageRange: map['ageRange'],
      gender: map['gender'],
      isRanked: map['isRanked'],
      deviceTokens: List<String>.from(map['deviceTokens'] ?? []),
      disconnections: Disconnection.toListOfDisconnectionsFormMap(
          map: map['disconnections']),
      unReadCount: map['unReadCount'],
      connectionCount: map['connectionCount'] ?? 0,
      coinscount: map['coinscount'] ?? 200,
      connectedCount: map['connectedCount'] ?? 0,
    );
  }

  // factory MyUser.fromSnapshot(DataSnapshot snapshot) {
  //   if (snapshot == null) {
  //     return MyUser();
  //   }
  //   var map = snapshot?.value;
  //   return MyUser.fromMap(map);
  //   // uid = map['uid'];
  //   // username = map['username'];
  //   // email = map['email'];
  //   // timestamp = map['timestamp'];
  //   // photoUrl = map['photoUrl'];
  //   // name = map['name'];
  //   // companyName = map['companyName'];
  //   // surname = map['surname'];
  //   // bio = map['bio'];
  //   // website = map['website'];
  //   // instagram = map['instagram'];
  //   // twitter = map['twitter'];
  //   // industry = map['industry'];
  //   // category = map['category'];
  //   // location = map['location'];
  //   // active = map['active'];
  //   // ageRange = map['ageRange'];
  //   // gender = map['gender'];
  //   // // connects = MyConnect.toListFormMap(map: map['connects']);
  //   // deviceTokens = List<String>.from(map['deviceTokens'] ?? []);
  //   // refers = MyRefers.toListFormMap(map: map['refers']);
  //   // profileViews = ProfileViewer.toListFormMap(map: map['profileViews']);
  //   // unReadCount = map['unReadCount'];
  //   // connectedCount = map['connectedCount'];
  //   // connectedCount = map['connectedCount'];
  // }

  // factory MyUser.fromSnapshots(DataSnapshot snapshot) {
  //   Map<dynamic, dynamic> data = snapshot.value;
  //   MyUser myUser = MyUser();
  //   data?.forEach((key, value) {
  //     myUser = MyUser.fromMap(value);
  //     //
  //     // uid = value['uid'];
  //     // username = value['username'];
  //     // email = value['email'];
  //     // timestamp = value['timestamp'];
  //     // photoUrl = value['photoUrl'];
  //     // name = value['name'];
  //     // companyName = value['companyName'];
  //     // surname = value['surname'];
  //     // bio = value['bio'];
  //     // website = value['website'];
  //     // instagram = value['instagram'];
  //     // twitter = value['twitter'];
  //     // industry = value['industry'];
  //     // category = value['category'];
  //     // location = value['location'];
  //     // active = value['active'];
  //     // ageRange = value['ageRange'];
  //     // gender = value['gender'];
  //     // // connects = MyConnect.toListFormMap(map: value['connects']);
  //     // deviceTokens = List<String>.from(value['deviceTokens'] ?? []);
  //     // refers = MyRefers.toListFormMap(map: value['refers']);
  //     // profileViews = ProfileViewer.toListFormMap(map: value['profileViews']);
  //     // unReadCount = value['unReadCount'];
  //     //
  //     // connectedCount = value['connectedCount'];
  //     // connectedCount = value['connectedCount'];
  //     // return;
  //   });
  //   return myUser;
  // }

  bool hasCompleteData() {
    if (uid == null) return false;
    if (username == null) return false;
    if (email == null) return false;
    if (timestamp == null) return false;
    // if (photoUrl == null) return false;
    if (name == null) return false;
    // if (companyName == null) return false;
    // if (surname == null) return false;
    if (bio == null) return false;

    // if (website == null) return false;
    // if (instagram == null) return false;
    // if (twitter == null) return false;
    // if (industry == null) return false;
    // if (category == null) return false;
    // if (location == null) return false;

    return true;
  }

  bool hasToken(String token) {
    if (token == null) return false;
    int? index = deviceTokens.indexWhere((t) => t == token);
    if (index > -1) {
      return true;
    } else {
      return false;
    }
  }

  List<String> removeToken(String token) {
    if (token == null) return deviceTokens;
    int? index = deviceTokens.indexWhere((String t) => t == token);
    if (index > -1) deviceTokens.removeAt(index);
    return deviceTokens;
  }

  static int? refCount(List<MyRefers> refs) {
    int? refCount = 0;
    if (refs == null || refs.isEmpty) return 0;
    for (MyRefers ref in refs) {
      // debugPrint('MyUser.refCount: ${ref.referTo.length}');
      refCount = (refCount! + ref.referTo.length);
    }
    return refCount;
  }

  Map<String, dynamic> toCMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      // 'timestamp': this.timestamp,
      'photoUrl': photoUrl,
      'name': name,
      'bossOfTheWeekTimeStamp': bossOfTheWeekTimeStamp,
      'bossOfTheWeekUpTimeStamp': bossOfTheWeekUpTimeStamp,
      'companyName': companyName,
      'surname': surname,
      'bio': bio,
      // 'website': this.website,
      // 'instagram': this.instagram,
      // 'twitter': this.twitter,
      // 'industry': this.industry,
      // 'category': this.category,
      // 'location': this.location,
      // 'refers': this.refers,
      // 'deviceTokens': this.deviceTokens,
      // 'active': this.active,
      // 'ageRange': this.ageRange,
      // 'gender': this.gender,
      // 'profileViews': this.profileViews,
      // 'connectionCount': this.connectionCount,
      // 'connectedCount': this.connectedCount,
      // 'unReadCount': this.unReadCount,
    };
  }

  Map<String, dynamic> toPMap() {
    return {
      'uid': uid,
      // 'username': this.username,
      // 'timestamp': this.timestamp,
      'photoUrl': photoUrl,
      'name': name,
      'bio': bio,
      // 'website': this.website,
      // 'instagram': this.instagram,
      // 'twitter': this.twitter,
      // 'industry': this.industry,
      // 'category': this.category,
      // 'location': this.location,
      // 'refers': this.refers,
      'deviceTokens': deviceTokens,
      // 'active': this.active,
      // 'ageRange': this.ageRange,
      // 'gender': this.gender,
      // 'profileViews': this.profileViews,
      // 'connectionCount': this.connectionCount,
      // 'connectedCount': this.connectedCount,
      // 'unReadCount': this.unReadCount,
    };
  }

  factory MyUser.fromCMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      timestamp: map['timestamp'] as int,
      bossOfTheWeekTimeStamp: map['bossOfTheWeekTimeStamp'] as int,
      bossOfTheWeekUpTimeStamp: map['bossOfTheWeekUpTimeStamp'] as int,
      photoUrl: map['photoUrl'] as String,
      name: map['name'] as String,
      companyName: map['companyName'] as String,
      surname: map['surname'] as String,
      bio: map['bio'] as String,
      isRanked: map['isRanked'],
      achievements: '',
      active: true,
      ageRange: '',
      category: '',
      deactivated: false,
      gender: '',
      industry: '',
      instagram: '',
      location: '',
      productsandservices: '',
      twitter: '',
      unReadCount: 0,
      website: '',
    );
  }
}

class Disconnection {
  String id, userId;
  int timeStamp;

  Disconnection(
      {required this.id, required this.userId, required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'timeStamp': timeStamp,
    };
  }

  static List<Disconnection> toListOfDisconnectionsFormMap({
    required Map map,
  }) {
    if (map.isEmpty) return [];
    List<Disconnection> disconnections = [];
    map.forEach((key, data) {
      final Disconnection ref = Disconnection.fromMap(data);
      disconnections.add(ref);
    });
    return disconnections;
  }

  factory Disconnection.fromMap(Map map) {
    return Disconnection(
      id: map['id'] as String,
      userId: map['userId'] as String,
      timeStamp: map['timeStamp'] as int,
    );
  }
}
