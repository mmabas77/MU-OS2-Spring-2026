import 'package:flutter/material.dart';
import 'screens/courses_screen.dart';
import 'screens/debug_demo_screen.dart';
import 'screens/posts_screen.dart';

void main() {
  runApp(const Lab07App());
}

class Lab07App extends StatelessWidget {
  const Lab07App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 07 Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Home screen — links to each lesson's demo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 07 — Web Services & APIs'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoTile(
            lesson: 'Lesson 31',
            title: 'ListView.builder',
            subtitle:
                'itemBuilder, itemCount, CourseCard widget, local static list',
            icon: Icons.list,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => CoursesScreen(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _DemoTile(
            lesson: 'Lesson 32',
            title: 'Debugging Null Crash',
            subtitle:
                'user.points null from API, breakpoints, Variables panel',
            icon: Icons.bug_report,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DebugDemoScreen(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _DemoTile(
            lesson: 'Lessons 33 & 34',
            title: 'Fetching Posts via HTTP',
            subtitle:
                'http package, GET request, fromJson, 3 UI states (loading/error/success)',
            icon: Icons.cloud_download,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const PostsScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final String lesson;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoTile({
    required this.lesson,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          '$lesson — $title',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
