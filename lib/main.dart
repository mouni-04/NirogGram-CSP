import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const NirogGramApp());
}
