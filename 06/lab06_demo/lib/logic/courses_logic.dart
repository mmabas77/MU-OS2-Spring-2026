// BUSINESS LOGIC LAYER — CoursesLogic
// Receives raw data from the Data layer and applies filtering/processing rules.
// The UI layer never imports CoursesData directly — it always goes through here.
// This separation means business rules can be changed without touching the UI.

import '../models/course_model.dart';

class CoursesLogic {
  // Returns only the courses matching the selected category.
  // 'All' is a special value that returns the full list.
  static List<CourseModel> filterByCategory(
    List<CourseModel> courses,
    String category,
  ) {
    if (category == 'All') return courses;
    return courses.where((c) => c.category == category).toList();
  }
}
