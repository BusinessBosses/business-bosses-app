class BusinessInfo {
  final String name;
  final String industry;
  final String bio;
  final String website;

  BusinessInfo({
    required this.name,
    required this.industry,
    required this.bio,
    required this.website,
  });

  BusinessInfo copyWith({
    String? name,
    String? industry,
    String? bio,
    String? website,
  }) {
    return BusinessInfo(
      name: name ?? this.name,
      industry: industry ?? this.industry,
      bio: bio ?? this.bio,
      website: website ?? this.website,
    );
  }
}
