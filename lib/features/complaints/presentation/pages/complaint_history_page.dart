import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../controllers/complaint_history_controller.dart';

class ComplaintHistoryPage extends StatefulWidget {
  const ComplaintHistoryPage({super.key, required this.user});

  final AppUser user;

  @override
  State<ComplaintHistoryPage> createState() => _ComplaintHistoryPageState();
}

class _ComplaintHistoryPageState extends State<ComplaintHistoryPage> {
  late final ComplaintHistoryController _controller;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint History')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.complaints.isEmpty) {
            return const Center(child: Text('No complaints yet.'));
          }

          return ListView.builder(
            itemCount: _controller.complaints.length,
            itemBuilder: (context, index) {
              final item = _controller.complaints[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item.issueType),
                  subtitle: Text(item.description),
                  trailing: Text(statusLabel(item.status)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
