class BusinessInfo {
  final String name;
  final String industry;
  final String bio;
  final String website;
  final String location;
  final String postType;

  BusinessInfo({
    required this.name,
    required this.industry,
    required this.bio,
    required this.website,
    required this.location,
    required this.postType,
  });

  BusinessInfo copyWith({
    String? name,
    String? industry,
    String? bio,
    String? website,
    String? location,
    String? postType,
  }) {
    return BusinessInfo(
      name: name ?? this.name,
      industry: industry ?? this.industry,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      location: location ?? this.location,
      postType: postType ?? this.postType,
    );
  }
}
