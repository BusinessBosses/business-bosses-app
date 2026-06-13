class BusinessInfo {
  final String name;
  final String industry;
  final String bio;
  final String website;
  final String location;
  final String postType;
  final String price;
  final String additionalDetails;

  BusinessInfo({
    required this.name,
    required this.industry,
    required this.bio,
    required this.website,
    required this.location,
    required this.postType,
    this.price = '',
    this.additionalDetails = '',
  });

  BusinessInfo copyWith({
    String? name,
    String? industry,
    String? bio,
    String? website,
    String? location,
    String? postType,
    String? price,
    String? additionalDetails,
  }) {
    return BusinessInfo(
      name: name ?? this.name,
      industry: industry ?? this.industry,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      location: location ?? this.location,
      postType: postType ?? this.postType,
      price: price ?? this.price,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}
