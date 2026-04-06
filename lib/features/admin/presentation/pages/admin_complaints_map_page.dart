import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/presentation/pages/complaint_details_page.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Admin map screen showing all complaint markers.
class AdminComplaintsMapPage extends StatefulWidget {
  const AdminComplaintsMapPage({super.key});

  @override
  State<AdminComplaintsMapPage> createState() => _AdminComplaintsMapPageState();
}

class _AdminComplaintsMapPageState extends State<AdminComplaintsMapPage> {
  late final AdminDashboardController _controller;

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

  Set<Marker> _buildMarkers(List<Complaint> complaints) {
    return complaints.map((complaint) {
      return Marker(
        markerId: MarkerId(complaint.id),
        position: LatLng(complaint.latitude, complaint.longitude),
        infoWindow: InfoWindow(
          title: complaint.issueType,
          snippet: complaint.description,
        ),
        onTap: () => _showComplaintPreview(complaint),
      );
    }).toSet();
  }

  void _showComplaintPreview(Complaint complaint) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint.issueType,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(complaint.description),
                const SizedBox(height: 10),
                StatusChip(status: complaint.status),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      this.context,
                      AppRouter.complaintDetails,
                      arguments: ComplaintDetailsArgs(
                        complaint: complaint,
                        isAdmin: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open complaint details'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Complaints Map')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final complaints = _controller.complaints;
          if (complaints.isEmpty) {
            return const Center(child: Text('No complaints available.'));
          }

          final first = complaints.first;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(first.latitude, first.longitude),
              zoom: 12,
            ),
            markers: _buildMarkers(complaints),
            myLocationButtonEnabled: false,
            mapToolbarEnabled: true,
          );
        },
      ),
    );
  }
}
