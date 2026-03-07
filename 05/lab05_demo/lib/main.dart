// Entry point — centralized ThemeData
// Demonstrates:
//   - All colors defined once in ThemeData (DRY principle)
//   - Both light and dark themes available
//   - Theme.of(context) used throughout the app — zero hardcoded colors

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Lab05App());
}

class Lab05App extends StatelessWidget {
  const Lab05App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,

      // LIGHT THEME — all design values defined in one central location
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB), // indigo — matches screenshot
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      // DARK THEME — to apply, change themeMode to ThemeMode.dark
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Switch between ThemeMode.light, ThemeMode.dark, or ThemeMode.system
      themeMode: ThemeMode.light,

      home: const HomeScreen(),
    );
  }
}
