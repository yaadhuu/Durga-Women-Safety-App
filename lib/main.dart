import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/navigation/bottom_nav.dart';

void main() {
  runApp(const DurgaApp());
}

class DurgaApp extends StatelessWidget {
  const DurgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const BottomNav(),
    );
  }
}