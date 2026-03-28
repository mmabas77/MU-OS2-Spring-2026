// UI LAYER — CoursesScreen (StatefulWidget)
// Main screen of the DevSchool app.
// Demonstrates Lab 06 concepts:
//   - StatefulWidget + setState(): category filter changes rebuild only what's needed
//   - Three-layer architecture: UI → Logic → Data
//   - ListView.builder: dynamic list of CourseCard widgets
//   - Widget class composition: CoursesHeader, CategoryFilter, CourseCard
//   - Screen never talks to CoursesData directly — always through CoursesLogic

import 'package:flutter/material.dart';
import '../data/courses_data.dart';
import '../logic/courses_logic.dart';
import '../models/course_model.dart';
import '../widgets/category_filter.dart';
import '../widgets/course_card.dart';
import '../widgets/courses_header.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  // STATE — the two variables that drive the UI
  // Changing either one with setState() causes a rebuild
  final List<CourseModel> _allCourses = CoursesData.getAllCourses();
  String _selectedCategory = 'All';

  // Computed value — derived from state, not stored separately
  // BUSINESS LOGIC LAYER call: never filter in the UI directly
  List<CourseModel> get _filteredCourses =>
      CoursesLogic.filterByCategory(_allCourses, _selectedCategory);

  // Called when the user taps a category chip
  void _onCategorySelected(String category) {
    setState(() {
      // Changing _selectedCategory triggers a rebuild.
      // _filteredCourses is recalculated on the next build() call.
      _selectedCategory = category;
    });
    debugPrint('[STATE] Category changed to: $category '
        '(${_filteredCourses.length} courses)');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = _filteredCourses; // evaluated once per build

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text(
          'DevSchool',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // WIDGET CLASS: CoursesHeader — extracted, has its own lifecycle
          // Rebuilds only when courseCount or selectedCategory changes
          CoursesHeader(
            courseCount: courses.length,
            selectedCategory: _selectedCategory,
          ),

          // WIDGET CLASS: CategoryFilter — horizontal ListView
          // Receives the current selection and a callback to update state
          CategoryFilter(
            categories: CoursesData.getCategories(),
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),

          // Divider between filter bar and list
          const Divider(height: 1),

          // ListView.builder — dynamic list from data
          // Only builds the cards currently visible on screen (lazy)
          Expanded(
            child: courses.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      // WIDGET CLASS: CourseCard — each card is its own widget
                      // Receives a typed CourseModel (strict data typing)
                      return CourseCard(course: courses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Helper function (not widget class): small, tightly coupled to this screen,
  // no independent state, no reuse needed — a function is appropriate here.
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 56,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            'No courses in this category',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
