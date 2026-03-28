// UI LAYER — CoursesHeader (Widget Class)
// Extracted as a separate StatelessWidget — not a helper function.
// Demonstrates: Widget class extraction for an independent, reusable section.
// Has its own build lifecycle → rebuilds only when its own props change.

import 'package:flutter/material.dart';

class CoursesHeader extends StatelessWidget {
  final int courseCount;
  final String selectedCategory;

  const CoursesHeader({
    required this.courseCount,
    required this.selectedCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label =
        selectedCategory == 'All' ? 'All Courses' : '$selectedCategory Courses';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      color: theme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Badge showing how many courses match the selected filter
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$courseCount courses',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
