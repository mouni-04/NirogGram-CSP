import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/status_constants.dart';

class Complaint {
  const Complaint({
    required this.id,
    required this.userId,
    required this.issueType,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });

  final String id;
  final String userId;
  final String issueType;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'complaintId': id,
      'userId': userId,
      'issueType': issueType,
      'description': description,
      'status': status.name,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'];

    DateTime parsedCreatedAt;
    if (createdAtRaw is Timestamp) {
      parsedCreatedAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      parsedCreatedAt = createdAtRaw;
    } else if (createdAtRaw is String) {
      parsedCreatedAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return Complaint(
      id: (map['complaintId'] ?? map['id']) as String,
      userId: map['userId'] as String,
      issueType: map['issueType'] as String,
      description: map['description'] as String,
      status: ComplaintStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => ComplaintStatus.pending,
      ),
      createdAt: parsedCreatedAt,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
