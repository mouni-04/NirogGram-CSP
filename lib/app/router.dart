import 'package:flutter/material.dart';

import '../features/admin/presentation/pages/admin_complaints_map_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/admin_login_page.dart';
import '../features/auth/domain/entities/app_user.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/complaints/domain/entities/complaint.dart';
import '../features/complaints/presentation/pages/camera_upload_page.dart';
import '../features/complaints/presentation/pages/complaint_details_page.dart';
import '../features/complaints/presentation/pages/complaint_history_page.dart';
import '../features/complaints/presentation/pages/complaint_status_page.dart';
import '../features/complaints/presentation/pages/complaint_map_page.dart';
import '../features/complaints/presentation/pages/report_issue_page.dart';
import '../features/splash_page.dart';
import '../features/user_dashboard/presentation/pages/user_home_page.dart';

class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const userHome = '/user-home';
  static const reportIssue = '/report-issue';
  static const cameraUpload = '/camera-upload';
  static const complaintHistory = '/complaint-history';
  static const complaintStatus = '/complaint-status';
  static const adminLogin = '/admin-login';
  static const adminDashboard = '/admin-dashboard';
  static const adminComplaintsMap = '/admin-complaints-map';
  static const mapLocation = '/map-location';
  static const complaintMap = mapLocation;
  static const complaintDetails = '/complaint-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case userHome:
        final user = settings.arguments as AppUser;
        return MaterialPageRoute(builder: (_) => UserHomePage(user: user));
      case reportIssue:
        final user = settings.arguments as AppUser;
        return MaterialPageRoute(builder: (_) => ReportIssuePage(user: user));
      case cameraUpload:
        return MaterialPageRoute(builder: (_) => const CameraUploadPage());
      case complaintHistory:
        final user = settings.arguments as AppUser;
        return MaterialPageRoute(builder: (_) => ComplaintHistoryPage(user: user));
      case complaintStatus:
        final user = settings.arguments as AppUser;
        return MaterialPageRoute(builder: (_) => ComplaintStatusPage(user: user));
      case adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());
      case adminComplaintsMap:
        return MaterialPageRoute(builder: (_) => const AdminComplaintsMapPage());
      case mapLocation:
        final complaint = settings.arguments as Complaint;
        return MaterialPageRoute(builder: (_) => ComplaintMapPage(complaint: complaint));
      case complaintDetails:
        final args = settings.arguments;
        if (args is ComplaintDetailsArgs) {
          return MaterialPageRoute(builder: (_) => ComplaintDetailsPage(args: args));
        }
        if (args is Complaint) {
          return MaterialPageRoute(
            builder: (_) => ComplaintDetailsPage(args: ComplaintDetailsArgs(complaint: args)),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Invalid complaint details arguments')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
