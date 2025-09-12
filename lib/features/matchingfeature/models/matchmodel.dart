class Matches {
  final String id;
  final String name;
  final String type;
  final String description;
  final double rating;
  final String location;
  final List<String> services;
  final String responseTime;
  final String budget;
  final bool isPremium;
  final bool isVerified;
  final int matchPercentage;
  final String? fundingStage;
  final String? seekingAmount;
  final String? valuation;
  final String? revenue;
  final String? timeline;
  final String? urgency;

  Matches({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.rating,
    required this.location,
    required this.services,
    required this.responseTime,
    required this.budget,
    required this.isPremium,
    required this.isVerified,
    required this.matchPercentage,
    this.fundingStage,
    this.seekingAmount,
    this.valuation,
    this.revenue,
    this.timeline,
    this.urgency,
  });

  factory Matches.fromJson(Map<String, dynamic> json) {
    return Matches(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      rating: json['rating'].toDouble(),
      location: json['location'],
      services: List<String>.from(json['services']),
      responseTime: json['responseTime'],
      budget: json['budget'],
      isPremium: json['isPremium'],
      isVerified: json['isVerified'],
      matchPercentage: json['matchPercentage'],
      fundingStage: json['fundingStage'],
      seekingAmount: json['seekingAmount'],
      valuation: json['valuation'],
      revenue: json['revenue'],
      timeline: json['timeline'],
      urgency: json['urgency'],
    );
  }
}
