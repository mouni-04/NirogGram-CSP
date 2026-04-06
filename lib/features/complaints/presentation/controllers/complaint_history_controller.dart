import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/services/firestore_complaint_service.dart';
import '../../domain/entities/complaint.dart';

class ComplaintHistoryController extends ChangeNotifier {
  ComplaintHistoryController(this._complaintService);

  final FirestoreComplaintService _complaintService;

  StreamSubscription<List<Complaint>>? _subscription;
  List<Complaint> complaints = const [];

  void watchUserComplaints(String userId) {
    _subscription?.cancel();
    _subscription = _complaintService.watchUserComplaints(userId).listen((data) {
      complaints = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
