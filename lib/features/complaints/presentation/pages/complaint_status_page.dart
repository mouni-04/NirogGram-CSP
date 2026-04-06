import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/status_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../domain/entities/complaint.dart';
import '../controllers/complaint_history_controller.dart';

/// Complaint status tracking screen with quick filters.
class ComplaintStatusPage extends StatefulWidget {
  const ComplaintStatusPage({super.key, required this.user});

  final AppUser user;

  @override
  State<ComplaintStatusPage> createState() => _ComplaintStatusPageState();
}

class _ComplaintStatusPageState extends State<ComplaintStatusPage> {
  late final ComplaintHistoryController _controller;
  ComplaintStatus? _activeFilter;

  @override
  void initState() {
    super.initState();
    _controller = ComplaintHistoryController(sl())..watchUserComplaints(widget.user.uid);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Complaint> _applyFilter(List<Complaint> complaints) {
    if (_activeFilter == null) {
      return complaints;
    }
    return complaints.where((item) => item.status == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Status')),
      body: ResponsivePage(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final filtered = _applyFilter(_controller.complaints);

            return Column(
              children: [
                // Filter controls to quickly inspect each complaint state.
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: _activeFilter == null,
                      onSelected: (_) => setState(() => _activeFilter = null),
                    ),
                    ChoiceChip(
                      label: const Text('Pending'),
                      selected: _activeFilter == ComplaintStatus.pending,
                      onSelected: (_) => setState(() => _activeFilter = ComplaintStatus.pending),
                    ),
                    ChoiceChip(
                      label: const Text('In Progress'),
                      selected: _activeFilter == ComplaintStatus.inProgress,
                      onSelected: (_) => setState(() => _activeFilter = ComplaintStatus.inProgress),
                    ),
                    ChoiceChip(
                      label: const Text('Resolved'),
                      selected: _activeFilter == ComplaintStatus.resolved,
                      onSelected: (_) => setState(() => _activeFilter = ComplaintStatus.resolved),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No complaints for this filter.'))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final complaint = filtered[index];
                            return Card(
                              child: ListTile(
                                title: Text(complaint.issueType),
                                subtitle: Text(complaint.description),
                                trailing: StatusChip(status: complaint.status),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.complaintDetails,
                                  arguments: complaint,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
