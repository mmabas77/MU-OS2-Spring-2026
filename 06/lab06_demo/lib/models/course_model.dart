// DATA MODEL — CourseModel
// Represents a single course in the DevSchool platform.
// The UI and Logic layers receive this object; they never handle raw fields directly.
// Demonstrates: typed data model connecting all three layers.

class CourseModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime lastUpdated;
  final int lessonCount;

  const CourseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.lastUpdated,
    required this.lessonCount,
  });
}
