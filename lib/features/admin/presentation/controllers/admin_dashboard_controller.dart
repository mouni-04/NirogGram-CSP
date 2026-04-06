import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/status_constants.dart';
import '../../../../core/services/firestore_complaint_service.dart';
import '../../../complaints/domain/entities/complaint.dart';

class AdminDashboardController extends ChangeNotifier {
  AdminDashboardController(this._complaintService);

  final FirestoreComplaintService _complaintService;

  StreamSubscription<List<Complaint>>? _subscription;
  List<Complaint> complaints = const [];

  void watchAllComplaints() {
    _subscription?.cancel();
    _subscription = _complaintService.watchAllComplaints().listen((data) {
      complaints = data;
      notifyListeners();
    });
  }

  Future<void> updateComplaintStatus({
    required String complaintId,
    required ComplaintStatus status,
  }) async {
    await _complaintService.updateComplaintStatus(
      complaintId: complaintId,
      status: status,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
