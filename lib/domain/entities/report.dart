class Report {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String country;
  final String city;
  final String district;
  final double? latitude;
  final double? longitude;
  final String category;
  final String description;
  final List<String> evidenceUrls;
  final DateTime createdAt;
  final int riskLevel; // 1-5
  final int votesReal;
  final int votesFake;
  final int reportCount;
  final bool isVerified;
  final Map<String, String>? socialMedia;

  Report({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.country,
    required this.city,
    required this.district,
    this.latitude,
    this.longitude,
    required this.category,
    required this.description,
    required this.evidenceUrls,
    required this.createdAt,
    this.riskLevel = 1,
    this.votesReal = 0,
    this.votesFake = 0,
    this.reportCount = 1,
    this.isVerified = false,
    this.socialMedia,
  });

  String get fullName => '$firstName $lastName';
  String get maskedName => '$firstName ${lastName[0]}.'; // Privacy
}
