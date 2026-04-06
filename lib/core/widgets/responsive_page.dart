import 'package:flutter/material.dart';

/// A reusable responsive container that keeps content centered on large screens.
class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth > maxWidth ? maxWidth : constraints.maxWidth;
          return Center(
            child: SizedBox(
              width: width,
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
