import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../features/complaints/domain/entities/complaint.dart';
import '../constants/status_constants.dart';

class ComplaintService {
  ComplaintService({FirebaseFirestore? firestore, Uuid? uuid})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  CollectionReference<Map<String, dynamic>> get _complaintsRef =>
      _firestore.collection('complaints');

  Future<String> submitComplaint({
    required String userId,
    required String issueType,
    required String description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    final id = _uuid.v4();
    final complaint = Complaint(
      id: id,
      userId: userId,
      issueType: issueType,
      description: description,
      status: ComplaintStatus.pending,
      createdAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
    );

    await _complaintsRef.doc(id).set(complaint.toMap());
    return id;
  }

  Stream<List<Complaint>> watchUserComplaints(String userId) {
    return _complaintsRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Complaint.fromMap(doc.data())).toList();
    });
  }

  Stream<List<Complaint>> watchAllComplaints() {
    return _complaintsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Complaint.fromMap(doc.data())).toList();
    });
  }

  Future<void> updateStatus({
    required String complaintId,
    required ComplaintStatus status,
  }) async {
    await _complaintsRef.doc(complaintId).update({
      'status': status.name,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
