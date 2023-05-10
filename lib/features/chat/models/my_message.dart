class MyMessage {
  String? messageId;
  String? messageText;
  int? timestamp;
  List<String>? images = [];
  List<String>? deletedBy = [];
  List<String>? singleDeletedBy = [];
  // List<MyAssetEntity> myAssetsEntitiesImages = [];
  String? senderUid;
  String? receiverUid;
  // bool deleted;
  bool? deletedTillHere;

  MyMessage({
    this.messageId,
    this.messageText,
    this.deletedBy,
    this.singleDeletedBy,
    this.timestamp,
    this.images,
    this.deletedTillHere,
    // this.deleted,
    this.senderUid,
    this.receiverUid,
    // this.myAssetsEntitiesImages,
  });

  factory MyMessage.toObject(Map<dynamic, dynamic> map) {
    return MyMessage(
      messageId: map['messageId'] as String,
      messageText: map['messageText'] as String,
      timestamp: map['timestamp'] as int,
      images: map['images'] == null ? [] : List<String>.from(map['images']),
      deletedBy:
          map['deletedBy'] == null ? [] : List<String>.from(map['deletedBy']),
      singleDeletedBy: map['singleDeletedBy'] == null
          ? []
          : List<String>.from(map['singleDeletedBy']),
      senderUid: map['senderUid'] as String,
      deletedTillHere: map['deletedTillHere'] as bool,
      // deleted: map['deleted'] as bool,
      receiverUid: map['receiverUid'] as String,
    );
  }

  // factory MyMessage.toObjectFromSnapshot(DataSnapshot snapshot) {
  //   Map<dynamic, dynamic> map = snapshot?.value;
  //   return MyMessage(
  //     messageId: map['messageId'] as String,
  //     messageText: map['messageText'] as String,
  //     timestamp: map['timestamp'] as int,
  //     images: map['images'] == null ? [] : List<String>.from(map['images']),
  //     deletedBy:
  //         map['deletedBy'] == null ? [] : List<String>.from(map['deletedBy']),
  //     singleDeletedBy: map['singleDeletedBy'] == null
  //         ? []
  //         : List<String>.from(map['singleDeletedBy']),
  //     senderUid: map['senderUid'] as String,
  //     deletedTillHere: map['deletedTillHere'] as bool ?? false,
  //     // deleted: map['deleted'] as bool??false,
  //     receiverUid: map['receiverUid'] as String,
  //   );
  // }

  Map<dynamic, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'messageId': messageId,
      'messageText': messageText,
      'timestamp': timestamp,
      'images': images,
      'singleDeletedBy': singleDeletedBy,
      'senderUid': senderUid,
      // 'deleted': this.deleted,
      'deletedBy': deletedBy,
      'deletedTillHere': deletedTillHere,
      'receiverUid': receiverUid,
    } as Map<dynamic, dynamic>;
  }

  // Map<dynamic, dynamic> toSetMap() {
  //   final MyFirebase _firebase = MyFirebase();
  //   // ignore: unnecessary_cast
  //   return {
  //     'messageId': messageId,
  //     'messageText': messageText,
  //     'images': images,
  //     'receiverUid': receiverUid,
  //     'timestamp': timestamp,
  //     // 'deleted': this.deleted,
  //     'deletedTillHere': deletedTillHere,
  //     'deletedBy': deletedBy,
  //     'singleDeletedBy': singleDeletedBy,
  //     'senderUid': _firebase.uid,
  //   } as Map<dynamic, dynamic>;
  // }
}
