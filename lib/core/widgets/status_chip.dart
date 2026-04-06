import 'package:flutter/material.dart';

import '../constants/status_constants.dart';

/// A compact status indicator used across complaint list/detail screens.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ComplaintStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ComplaintStatus.pending => ('Pending', Colors.orange),
      ComplaintStatus.inProgress => ('In Progress', Colors.blue),
      ComplaintStatus.resolved => ('Resolved', Colors.green),
    };

    return Chip(
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: color.withValues(alpha: 0.16),
      labelStyle: TextStyle(color: color.shade800, fontWeight: FontWeight.w600),
      visualDensity: VisualDensity.compact,
    );
  }
}
