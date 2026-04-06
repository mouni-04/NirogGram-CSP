import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore data model for a complaint document in `complaints` collection.
class ComplaintFirestoreModel {
  const ComplaintFirestoreModel({
    required this.complaintId,
    required this.userId,
    required this.issueType,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.createdAt,
  });

  final String complaintId;
  final String userId;
  final String issueType;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;

  Map<String, dynamic> toMapForCreate() {
    return {
      'complaintId': complaintId,
      'userId': userId,
      'issueType': issueType,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ComplaintFirestoreModel.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'];

    DateTime? parsedCreatedAt;
    if (createdAtRaw is Timestamp) {
      parsedCreatedAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      parsedCreatedAt = createdAtRaw;
    } else if (createdAtRaw is String) {
      parsedCreatedAt = DateTime.tryParse(createdAtRaw);
    }

    return ComplaintFirestoreModel(
      complaintId: (map['complaintId'] as String?) ?? '',
      userId: (map['userId'] as String?) ?? '',
      issueType: (map['issueType'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      imageUrl: (map['imageUrl'] as String?) ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      status: (map['status'] as String?) ?? 'pending',
      createdAt: parsedCreatedAt,
    );
  }
}
