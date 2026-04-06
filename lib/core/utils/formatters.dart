import '../constants/status_constants.dart';

String statusLabel(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.pending:
      return 'Pending';
    case ComplaintStatus.inProgress:
      return 'In Progress';
    case ComplaintStatus.resolved:
      return 'Resolved';
  }
}
