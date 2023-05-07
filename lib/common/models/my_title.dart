class MyTitle {
  String categoryId;
  int timestamp;
  String category;

  MyTitle({
    required this.categoryId,
    required this.timestamp,
    required this.category,
  });

  factory MyTitle.toObject(Map<dynamic, dynamic> map) {
    return MyTitle(
      categoryId: map['categoryId'] as String,
      timestamp: map['timestamp'] as int,
      category: map['category'] as String,
    );
  }

  Map<dynamic, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'categoryId': categoryId,
      'timestamp': timestamp,
      'category': category,
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toSetMap() {
    // ignore: unnecessary_cast
    return {
      'categoryId': categoryId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'category': category,
    } as Map<dynamic, dynamic>;
  }
}
