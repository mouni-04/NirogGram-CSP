import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class NirogGramApp extends StatelessWidget {
  const NirogGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NirogGram',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.splash,
    );
  }
}
