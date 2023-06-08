class Ranking {
  String? uid;
  num? point;
  num? timestamp;
  num? percentage;
  num? rankingPercentage;

  Ranking({
    this.uid,
    this.point,
    this.timestamp,
    this.percentage,
    this.rankingPercentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'point': point,
      'timestamp': timestamp,
      'percentage': percentage,
      'rankingPercentage': rankingPercentage,
    };
  }

  factory Ranking.fromMap(Map map) {
    return Ranking(
      uid: map['uid'] as String,
      point: map['point'] as num,
      timestamp: map['timestamp'] as num,
      percentage: map['percentage'] as num,
      rankingPercentage: map['rankingPercentage'] as num,
    );
  }

//   factory Ranking.fromSnapshot(DataSnapshot snapshot) {
//     if (!snapshot.exists) return Ranking();
//     return Ranking.fromMap(snapshot.value);
// /*    return Ranking(
//       uid: map['uid'] as String,
//       point: map['point'] as num,
//       timestamp: map['timestamp'] as num,
//       totalPercentage: map['percentage'] as num,
//       rankingPercentage: map['rankingPercentage'] as num,
//     );*/
//   }

  bool get isEmpty {
    if ((uid?.isEmpty ?? true) &&
        (point == null) &&
        (timestamp == null) &&
        (percentage == null)) {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotEmpty {
    if ((uid?.isNotEmpty ?? false) &&
        (point != null) &&
        (timestamp != null) &&
        (percentage != null)) {
      return true;
    } else {
      return false;
    }
  }
}
