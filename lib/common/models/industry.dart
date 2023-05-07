// class Industry {
//   String industryId;
//   String industry;
//   String photo;
//   String description;
//   List<String> joinedUsers;
//   int timestamp;
//   bool active;
//   String categoryId;

//   Industry({
//     required this.industryId,
//     required this.industry,
//     required this.photo,
//     required this.description,
//     required this.joinedUsers,
//     required this.timestamp,
//     required this.active,
//     required this.categoryId,
//   });

//   static List<Industry> toJustSortIndustryList({DataSnapshot snapshot}) {
//     if (snapshot == null) return [];
//     List<Industry> items = [];
//     Map<dynamic, dynamic> values = snapshot.value;
//     values?.forEach((key, pst) {
//       Industry pt = Industry.toObject(pst);
//       items.add(pt);
//     });
//     items?.sort((a, b) => b.timestamp?.compareTo(a.timestamp ?? 0) ?? 0);
//     return items;
//   }

//   factory Industry.toObject(Map<dynamic, dynamic> map) {
//     return Industry(
//       industryId: map['industryId'] as String,
//       industry: map['industry'] as String,
//       photo: map['photo'] as String,
//       description: map['description'] as String,
//       active: map['active'] as bool,
//       joinedUsers: map['joinedUsers'] == null
//           ? []
//           : List<String>.from(map['joinedUsers']),
//       timestamp: map['timestamp'] as int,
//       categoryId: map['categoryId'] as String,
//     );
//   }

//   factory Industry.toObjectFromSnapshot(DataSnapshot snapshot) {
//     Map<dynamic, dynamic> map = snapshot.value;
//     return Industry(
//       industryId: map['industryId'] as String,
//       industry: map['industry'] as String,
//       photo: map['photo'] as String,
//       description: map['description'] as String,
//       active: map['active'] as bool,
//       joinedUsers: map['joinedUsers'] == null
//           ? []
//           : List<String>.from(map['joinedUsers']),
//       timestamp: map['timestamp'] as int,
//       categoryId: map['categoryId'] as String,
//     );
//   }

//   Map<dynamic, dynamic> toSetMap() {
//     // ignore: unnecessary_cast
//     return {
//       'industryId': industryId,
//       'industry': industry,
//       'photo': photo,
//       'description': 'It is about $industry',
//       'joinedUsers': [],
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'categoryId': categoryId,
//     } as Map<dynamic, dynamic>;
//   }

//   Map<dynamic, dynamic> toJoinedMap() {
//     // ignore: unnecessary_cast
//     return {
//       // 'industryId': this.id,
//       // 'industry': this.industry,
//       // 'description': this.description,
//       'joinedUsers': joinedUsers,
//       // 'timestamp': this.timestamp,
//     } as Map<dynamic, dynamic>;
//   }

//   static Map<String, dynamic> toIndustriesListMap(List<Industry> industries) {
//     Map<String, dynamic> map = {};
//     for (Industry ind in industries ?? []) {
//       map[ind.industryId] = ind.toSetMap();
//     }
//     return map;
//   }
// }
