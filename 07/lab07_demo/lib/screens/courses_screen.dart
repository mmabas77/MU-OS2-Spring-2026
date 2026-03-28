import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../widgets/course_card.dart';

/// Lesson 31 demo — ListView.builder driven by a local static list.
///
/// Key concepts shown:
///   - itemCount is always tied to courses.length (never a hard-coded number)
///   - itemBuilder receives (BuildContext context, int index)
///   - Flutter calls itemBuilder lazily for each visible item
///   - Each row is extracted into a CourseCard StatelessWidget
class CoursesScreen extends StatelessWidget {
  CoursesScreen({super.key});

  // Step 1: a plain List<String> to start — matches what the video showed first
  final List<String> courseNames = [
    'Course 1',
    'Course 2',
    'Course 3',
    'Course 4',
    'Course 5',
  ];

  // Step 2: evolved to a List<CourseModel> with imageUrl — matches the video's
  // progression from a raw string list to a proper model object list
  final List<CourseModel> courses = [
    CourseModel(
      name: 'Course 1',
      imageUrl: 'https://picsum.photos/seed/c1/60/60',
    ),
    CourseModel(
      name: 'Course 2',
      imageUrl: 'https://picsum.photos/seed/c2/60/60',
    ),
    CourseModel(
      name: 'Course 3',
      imageUrl: 'https://picsum.photos/seed/c3/60/60',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Part A: string-only list (first version shown in video) ──────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Text(
              'A) String list — itemCount: courseNames.length',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey[700]),
            ),
          ),
          SizedBox(
            height: 180,
            // itemCount is always tied to the list length — never hardcoded
            child: ListView.builder(
              itemCount: courseNames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(courseNames[index]),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // ── Part B: model-object list with network images ─────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Text(
              'B) CourseModel list with images',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseCard(course: courses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
