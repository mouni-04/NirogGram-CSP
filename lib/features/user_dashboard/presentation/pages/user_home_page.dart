import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../core/widgets/action_card.dart';
import '../../../auth/domain/entities/app_user.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key, required this.user});

  final AppUser user;

  Future<void> _seedDemoComplaints(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final complaints = [
      {
        'complaintId': 'demo-001',
        'userId': user.uid,
        'issueType': 'Garbage',
        'description': 'Large pile of garbage near the main road junction. Foul smell affecting residents.',
        'status': 'pending',
        'latitude': 13.5607,
        'longitude': 80.0229,
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
      },
      {
        'complaintId': 'demo-002',
        'userId': user.uid,
        'issueType': 'Drainage',
        'description': 'Blocked drainage causing water logging in front of school. Children unable to walk safely.',
        'status': 'inProgress',
        'latitude': 13.5621,
        'longitude': 80.0245,
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
      },
      {
        'complaintId': 'demo-003',
        'userId': user.uid,
        'issueType': 'Water problem',
        'description': 'No water supply for the past 2 days in ward 4. Residents are struggling.',
        'status': 'resolved',
        'latitude': 13.5598,
        'longitude': 80.0210,
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7))),
      },
      {
        'complaintId': 'demo-004',
        'userId': user.uid,
        'issueType': 'Road damage',
        'description': 'Deep potholes on the village road causing accidents. Urgent repair needed.',
        'status': 'pending',
        'latitude': 13.5615,
        'longitude': 80.0238,
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'complaintId': 'demo-005',
        'userId': user.uid,
        'issueType': 'Sanitation',
        'description': 'Public toilet near the market is not cleaned for weeks. Health hazard for villagers.',
        'status': 'inProgress',
        'latitude': 13.5630,
        'longitude': 80.0255,
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
      },
    ];

    final batch = firestore.batch();
    for (final c in complaints) {
      batch.set(firestore.collection('complaints').doc(c['complaintId'] as String), c);
    }
    await batch.commit();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('5 demo complaints added!'),
          backgroundColor: kPrimary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimary, kSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome back,',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: 13)),
                                Text(user.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Report health & sanitation issues easily',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('NirogGram',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                const Text('What would you like to do?',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 14),
                ActionCard(
                  icon: Icons.report_problem_outlined,
                  title: 'Report an Issue',
                  subtitle: 'Garbage, dirty water, blocked drainage',
                  color: kAccent,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.reportIssue,
                    arguments: user,
                  ),
                ),
                ActionCard(
                  icon: Icons.track_changes_outlined,
                  title: 'Track Complaint Status',
                  subtitle: 'Pending, in progress, resolved',
                  color: kPrimary,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.complaintStatus,
                    arguments: user,
                  ),
                ),
                ActionCard(
                  icon: Icons.history_rounded,
                  title: 'Complaint History',
                  subtitle: 'Review all submitted complaints',
                  color: kSecondary,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.complaintHistory,
                    arguments: user,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
