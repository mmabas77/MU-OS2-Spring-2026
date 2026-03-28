// UI LAYER — CourseCard (Widget Class)
// Represents a single course row in the ListView.
// Extracted as a StatelessWidget — each card has its own build context and lifecycle.
// Demonstrates:
//   - Widget class extraction (vs helper function)
//   - DateFormatter utility for the intl package
//   - Receives a typed CourseModel — strict data typing

import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../utils/date_formatter.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chip + lesson count row
            Row(
              children: [
                _CategoryBadge(category: course.category),
                const Spacer(),
                Icon(Icons.play_circle_outline,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  '${course.lessonCount} lessons',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Course title
            Text(
              course.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Course description
            Text(
              course.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            // Last updated — uses DateFormatter (intl package)
            Row(
              children: [
                Icon(Icons.update,
                    size: 14,
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  'Updated: ${DateFormatter.format(course.lastUpdated)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Private widget class — _CategoryBadge
// Demonstrates extracting a small, self-contained UI piece into its own widget.
// Because it's a separate Widget, it has its own build lifecycle.
class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  // Maps category name to a color
  Color _colorForCategory(String cat) {
    switch (cat) {
      case 'Mobile':
        return const Color(0xFF1565C0);
      case 'Web':
        return const Color(0xFF2E7D32);
      case 'Backend':
        return const Color(0xFF6A1B9A);
      case 'Design':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF37474F);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForCategory(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
