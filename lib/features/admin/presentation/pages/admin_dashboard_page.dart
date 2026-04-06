import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/status_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/presentation/pages/complaint_details_page.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late final AdminDashboardController _controller;
  ComplaintStatus? _activeFilter;

  @override
  void initState() {
    super.initState();
    _controller = AdminDashboardController(sl())..watchAllComplaints();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateStatusTo(String complaintId, ComplaintStatus status) async {
    await _controller.updateComplaintStatus(
      complaintId: complaintId,
      status: status,
    );
  }

  List<Complaint> _filteredComplaints() {
    if (_activeFilter == null) {
      return _controller.complaints;
    }

    return _controller.complaints
        .where((item) => item.status == _activeFilter)
        .toList(growable: false);
  }

  Widget _buildStatusFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
    );
  }

  Widget _buildComplaintImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.image_not_supported_outlined));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const CircleAvatar(
          child: Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: 'View all complaints on map',
            onPressed: () => Navigator.pushNamed(context, AppRouter.adminComplaintsMap),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.complaints.isEmpty) {
            return const Center(child: Text('No complaints available.'));
          }

          final complaints = _filteredComplaints();
          if (complaints.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusFilters(),
                  const SizedBox(height: 18),
                  const Expanded(
                    child: Center(child: Text('No complaints in selected status.')),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusFilters(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = complaints[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildComplaintImage(complaint.imageUrl),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint.issueType,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          complaint.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        StatusChip(status: complaint.status),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRouter.complaintDetails,
                                        arguments: ComplaintDetailsArgs(
                                          complaint: complaint,
                                          isAdmin: true,
                                        ),
                                      ),
                                      icon: const Icon(Icons.description_outlined),
                                      label: const Text('Details'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AppRouter.mapLocation,
                                        arguments: complaint,
                                      ),
                                      icon: const Icon(Icons.map_outlined),
                                      label: const Text('Map'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<ComplaintStatus>(
                                initialValue: complaint.status,
                                decoration: const InputDecoration(
                                  labelText: 'Update status',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: ComplaintStatus.pending,
                                    child: Text('Pending'),
                                  ),
                                  DropdownMenuItem(
                                    value: ComplaintStatus.inProgress,
                                    child: Text('In Progress'),
                                  ),
                                  DropdownMenuItem(
                                    value: ComplaintStatus.resolved,
                                    child: Text('Resolved'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _updateStatusTo(complaint.id, value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
