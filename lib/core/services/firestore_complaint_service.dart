import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../features/complaints/data/models/complaint_firestore_model.dart';
import '../../features/complaints/domain/entities/complaint.dart';
import '../constants/status_constants.dart';

/// Handles Firestore CRUD operations for complaints collection.
class FirestoreComplaintService {
  FirestoreComplaintService({FirebaseFirestore? firestore, Uuid? uuid})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  CollectionReference<Map<String, dynamic>> get _complaintsRef =>
      _firestore.collection('complaints');

  Future<void> saveComplaint(ComplaintFirestoreModel model) async {
    await _complaintsRef.doc(model.complaintId).set(model.toMapForCreate());
  }

  Future<String> createComplaint({
    String? complaintId,
    required String userId,
    required String issueType,
    required String description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    final id = complaintId ?? _uuid.v4();

    final complaintModel = ComplaintFirestoreModel(
      complaintId: id,
      userId: userId,
      issueType: issueType,
      description: description,
      imageUrl: imageUrl ?? '',
      latitude: latitude,
      longitude: longitude,
      status: ComplaintStatus.pending.name,
    );

    await saveComplaint(complaintModel);

    return id;
  }

  Stream<List<Complaint>> watchUserComplaints(String userId) {
    return _complaintsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) => Complaint.fromMap(doc.data())).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Stream<List<Complaint>> watchAllComplaints() {
    return _complaintsRef
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) => Complaint.fromMap(doc.data())).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Future<void> updateComplaintStatus({
    required String complaintId,
    required ComplaintStatus status,
  }) async {
    await _complaintsRef.doc(complaintId).update({
      'status': status.name,
    });
  }
}
