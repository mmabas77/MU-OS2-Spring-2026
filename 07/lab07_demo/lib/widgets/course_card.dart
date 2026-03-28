import 'package:flutter/material.dart';
import '../models/course_model.dart';

/// A single row widget used in CoursesScreen's ListView.builder.
/// Extracted into its own StatelessWidget so it has its own rebuild
/// lifecycle and can be reused across screens.
class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Network image — demonstrates Image.network with an HTTPS URL
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                course.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 28),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                course.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
