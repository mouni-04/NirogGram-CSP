import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/status_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../admin/presentation/controllers/admin_dashboard_controller.dart';
import '../../domain/entities/complaint.dart';

class ComplaintDetailsArgs {
  const ComplaintDetailsArgs({required this.complaint, this.isAdmin = false});

  final Complaint complaint;
  final bool isAdmin;
}

/// Detailed complaint view for both villager and admin role.
class ComplaintDetailsPage extends StatefulWidget {
  const ComplaintDetailsPage({super.key, required this.args});

  final ComplaintDetailsArgs args;

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  late Complaint _complaint;
  final AdminDashboardController _adminController = AdminDashboardController(sl());

  @override
  void initState() {
    super.initState();
    _complaint = widget.args.complaint;
  }

  Future<void> _updateStatus(ComplaintStatus status) async {
    await _adminController.updateComplaintStatus(
      complaintId: _complaint.id,
      status: status,
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _complaint = Complaint(
        id: _complaint.id,
        userId: _complaint.userId,
        issueType: _complaint.issueType,
        description: _complaint.description,
        status: status,
        createdAt: _complaint.createdAt,
        latitude: _complaint.latitude,
        longitude: _complaint.longitude,
        imageUrl: _complaint.imageUrl,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint status updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
      body: ResponsivePage(
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_complaint.issueType, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(_complaint.description),
                    if ((_complaint.imageUrl ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _complaint.imageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140,
                            alignment: Alignment.center,
                            color: Colors.grey.shade200,
                            child: const Text('Unable to load complaint image'),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    StatusChip(status: _complaint.status),
                    const SizedBox(height: 12),
                    Text('Complaint ID: ${_complaint.id}'),
                    Text('Latitude: ${_complaint.latitude.toStringAsFixed(5)}'),
                    Text('Longitude: ${_complaint.longitude.toStringAsFixed(5)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.mapLocation,
                arguments: _complaint,
              ),
              icon: const Icon(Icons.map_outlined),
              label: const Text('View location on map'),
            ),
            const SizedBox(height: 12),
            if (widget.args.isAdmin) ...[
              // Admin can set any status directly from details page.
              DropdownButtonFormField<ComplaintStatus>(
                initialValue: _complaint.status,
                decoration: const InputDecoration(labelText: 'Update complaint status'),
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
                    _updateStatus(value);
                  }
                },
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Mark Resolved',
                onPressed: () => _updateStatus(ComplaintStatus.resolved),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
