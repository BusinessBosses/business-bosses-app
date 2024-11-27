class Campaign {
  final List<String> clientIds;
  final int id;
  final String userId;
  final String campaignName;
  final String message;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Campaign({
    required this.clientIds,
    required this.id,
    required this.userId,
    required this.campaignName,
    required this.message,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from a map
  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      clientIds: List<String>.from(map['clientIds']),
      id: map['id'] as int,
      userId: map['userId'],
      campaignName: map['campaignName'],
      message: map['message'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientIds': clientIds,
      'id': id,
      'userId': userId,
      'campaignName': campaignName,
      'message': message,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
