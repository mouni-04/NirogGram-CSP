import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../controllers/report_issue_controller.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key, required this.user});

  final AppUser user;

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  late final ReportIssueController _controller;
  final _descriptionController = TextEditingController();

  static const _issueTypes = [
    'Garbage',
    'Drainage',
    'Water problem',
    'Road damage',
    'Sanitation',
  ];

  @override
  void initState() {
    super.initState();
    _controller = ReportIssueController(sl(), sl(), sl(), sl());
    _controller.selectedIssueType = _issueTypes.first;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.submitComplaint(
      userId: widget.user.uid,
      issueType: _controller.selectedIssueType!,
      description: _descriptionController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint submitted successfully.'),
          backgroundColor: kPrimary,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Submission failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(title: const Text('Report Issue')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Issue type
                const Text('Issue Type',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _controller.selectedIssueType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _issueTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => _controller.selectedIssueType = v,
                ),
                const SizedBox(height: 16),

                // Description
                const Text('Description',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe the issue...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.description_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Image
                const Text('Photo',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimary,
                          side: const BorderSide(color: kPrimary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _controller.capturePhoto,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(_controller.selectedImage == null
                            ? 'Capture'
                            : 'Retake'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimary,
                          side: const BorderSide(color: kPrimary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _controller.uploadPhoto,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                if (_controller.selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: kPrimary, size: 16),
                        SizedBox(width: 6),
                        Text('Image selected',
                            style: TextStyle(color: kPrimary, fontSize: 13)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Location
                const Text('Location',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimary,
                      side: const BorderSide(color: kPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _controller.detectLocation,
                    icon: const Icon(Icons.my_location),
                    label: Text(
                      _controller.latitude == null
                          ? 'Detect GPS Location'
                          : 'Location: ${_controller.latitude!.toStringAsFixed(4)}, ${_controller.longitude!.toStringAsFixed(4)}',
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Submit
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _controller.isSubmitting ? null : _submit,
                    child: _controller.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Submit Complaint',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
