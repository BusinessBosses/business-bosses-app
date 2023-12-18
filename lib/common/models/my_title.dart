class MyTitle {
  int id;
  String? title;

  MyTitle({
    required this.id,
    this.title,
  });

  factory MyTitle.toObject(Map<dynamic, dynamic> map) {
    return MyTitle(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }

  Map<dynamic, dynamic> toMap() {
    // ignore: unnecessary_cast
    return <String, Object?>{
      'id': id,
      'title': title,
    } as Map<dynamic, dynamic>;
  }

  Map<dynamic, dynamic> toSetMap() {
    // ignore: unnecessary_cast
    return <String, Object?>{
      'id': id,
      'title': title,
    } as Map<dynamic, dynamic>;
  }

  static List<MyTitle> toCategoriesList({
    required List snapshot,
  }) {
    // ignore: unnecessary_null_comparison
    if (snapshot == null) return <MyTitle>[];
    List<MyTitle> cats = <MyTitle>[];
    // Map<dynamic, dynamic> values = snapshot.value;
    for (int i = 0; i < snapshot.length; i++) {
      final MyTitle cat = MyTitle.toObject(snapshot[i]);
      cats.add(cat);
    }
    // Sort the cats list alphabetically by the title property
    cats.sort((MyTitle a, MyTitle b) => a.title!.compareTo(b.title!));
    return cats;
  }
}
