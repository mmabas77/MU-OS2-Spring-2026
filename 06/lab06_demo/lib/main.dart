// Entry point — DevSchool Online Courses App
// Demonstrates Lab 06 concepts:
//   - Centralized ThemeData (DRY principle)
//   - App navigates to CoursesScreen

import 'package:flutter/material.dart';
import 'screens/courses_screen.dart';

void main() {
  runApp(const Lab06App());
}

class Lab06App extends StatelessWidget {
  const Lab06App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevSchool',
      debugShowCheckedModeBanner: false,
      // All colors defined once — zero hardcoded colors in the rest of the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // deep blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CoursesScreen(),
    );
  }
}
