import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.age,
    required super.gender,
    required super.country,
    required super.city,
    required super.district,
    super.latitude,
    super.longitude,
    required super.category,
    required super.description,
    required super.evidenceUrls,
    required super.createdAt,
    super.riskLevel,
    super.votesReal,
    super.votesFake,
    super.reportCount,
    super.isVerified,
    super.socialMedia,
  });

  factory ReportModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReportModel(
      id: doc.id,
      firstName: data['personalInfo']['firstName'] ?? '',
      lastName: data['personalInfo']['lastName'] ?? '',
      age: data['personalInfo']['age'] ?? 0,
      gender: data['personalInfo']['gender'] ?? '',
      country: data['location']['country'] ?? '',
      city: data['location']['city'] ?? '',
      district: data['location']['district'] ?? '',
      latitude: data['location']['coordinates'] != null ? (data['location']['coordinates'] as GeoPoint).latitude : null,
      longitude: data['location']['coordinates'] != null ? (data['location']['coordinates'] as GeoPoint).longitude : null,
      category: data['reportDetails']['category'] ?? '',
      description: data['reportDetails']['description'] ?? '',
      evidenceUrls: List<String>.from(data['reportDetails']['evidenceUrls'] ?? []),
      createdAt: (data['metadata']['createdAt'] as Timestamp).toDate(),
      riskLevel: data['metadata']['riskLevel'] ?? 1,
      votesReal: data['votes']['real'] ?? 0,
      votesFake: data['votes']['fake'] ?? 0,
      reportCount: data['metadata']['reportCount'] ?? 1,
      isVerified: data['metadata']['verified'] ?? false,
      socialMedia: data['socialMedia'] != null ? Map<String, String>.from(data['socialMedia']) : null,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'personalInfo': {
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
      },
      'location': {
        'country': country,
        'city': city,
        'district': district,
        'coordinates': latitude != null && longitude != null ? GeoPoint(latitude!, longitude!) : null,
      },
      'socialMedia': socialMedia,
      'reportDetails': {
        'category': category,
        'description': description,
        'evidenceUrls': evidenceUrls,
      },
      'metadata': {
        'createdAt': Timestamp.fromDate(createdAt),
        'reportCount': reportCount,
        'lastReportedAt': Timestamp.now(), // Update on new report
        'verified': isVerified,
        'riskLevel': riskLevel,
      },
      'votes': {
        'real': votesReal,
        'fake': votesFake,
      },
      'searchKeywords': _generateKeywords(), // Helper for search
    };
  }

  List<String> _generateKeywords() {
    // Basic implementation for Firestore "contains" search workaround
    List<String> keywords = [];
    String full = "$firstName $lastName".toLowerCase();
    for (int i = 1; i <= full.length; i++) {
      keywords.add(full.substring(0, i));
    }
    return keywords;
  }
}
