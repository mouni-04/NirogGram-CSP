import 'package:flutter/material.dart';

import '../app/router.dart';
import '../core/di/injection_container.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(sl());
    _checkSession();
  }

  Future<void> _checkSession() async {
    await _authController.restoreSession();
    if (!mounted) {
      return;
    }

    final user = _authController.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
      return;
    }

    if (user.role.name == 'admin') {
      Navigator.pushReplacementNamed(context, AppRouter.adminDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.userHome, arguments: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
