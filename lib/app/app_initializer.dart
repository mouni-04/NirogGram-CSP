import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/di/injection_container.dart';
import '../firebase_options.dart';

class AppInitializer {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Firebase init skipped: $error');
      }
    }

    await setupDependencies();
  }
}
