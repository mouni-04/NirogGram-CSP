import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/router.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/complaint.dart';
import 'complaint_details_page.dart';

class ComplaintMapPage extends StatelessWidget {
  const ComplaintMapPage({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(complaint.latitude, complaint.longitude);

    void showMarkerDetails() {
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
                  Text(complaint.issueType, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(complaint.description),
                  const SizedBox(height: 10),
                  StatusChip(status: complaint.status),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AppRouter.complaintDetails,
                        arguments: ComplaintDetailsArgs(complaint: complaint),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Location')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: point, zoom: 15),
        markers: {
          Marker(
            markerId: MarkerId(complaint.id),
            position: point,
            infoWindow: InfoWindow(
              title: complaint.issueType,
              snippet: complaint.description,
              onTap: showMarkerDetails,
            ),
            onTap: showMarkerDetails,
          ),
        },
      ),
    );
  }
}
