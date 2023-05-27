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
      timestamp: int.parse(map['timestamp'].toString()),
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

  static List<MyTitle> toCategoriesList({
    required List snapshot,
  }) {
    if (snapshot == null) return [];
    List<MyTitle> cats = [];
    // Map<dynamic, dynamic> values = snapshot.value;
    for (int i = 0; i < snapshot.length; i++) {
      final MyTitle cat = MyTitle.toObject(snapshot[i]);
      cats.add(cat);
    }

    return cats;
  }
}
