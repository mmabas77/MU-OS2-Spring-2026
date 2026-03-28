// DATA LAYER — CoursesData
// Provides mock course data (simulates a Web API response).
// In a real app this class would call an HTTP endpoint and return parsed JSON.
// The screen never talks to the data source directly — it goes through the Logic layer.

import '../models/course_model.dart';

class CoursesData {
  // Returns all courses (mock — no network call yet)
  static List<CourseModel> getAllCourses() {
    return [
      CourseModel(
        id: '1',
        title: 'Flutter for Beginners',
        category: 'Mobile',
        description:
            'Learn how to build beautiful cross-platform apps with Flutter and Dart from scratch.',
        lastUpdated: DateTime(2025, 2, 10),
        lessonCount: 24,
      ),
      CourseModel(
        id: '2',
        title: 'State Management in Flutter',
        category: 'Mobile',
        description:
            'Master setState, Provider, and Cubit to manage app state correctly.',
        lastUpdated: DateTime(2025, 3, 1),
        lessonCount: 18,
      ),
      CourseModel(
        id: '3',
        title: 'React JS — Complete Guide',
        category: 'Web',
        description:
            'Build dynamic web interfaces with React, hooks, and component-based architecture.',
        lastUpdated: DateTime(2025, 1, 20),
        lessonCount: 32,
      ),
      CourseModel(
        id: '4',
        title: 'Node.js REST APIs',
        category: 'Backend',
        description:
            'Design and build RESTful APIs using Node.js, Express, and MongoDB.',
        lastUpdated: DateTime(2024, 12, 15),
        lessonCount: 20,
      ),
      CourseModel(
        id: '5',
        title: 'UI/UX Design Fundamentals',
        category: 'Design',
        description:
            'Understand user experience principles, wireframing, and Figma prototyping.',
        lastUpdated: DateTime(2025, 2, 28),
        lessonCount: 15,
      ),
      CourseModel(
        id: '6',
        title: 'Dart Programming Language',
        category: 'Mobile',
        description:
            'Deep dive into Dart: variables, functions, classes, generics, and async programming.',
        lastUpdated: DateTime(2025, 1, 5),
        lessonCount: 14,
      ),
      CourseModel(
        id: '7',
        title: 'Next.js Full Stack',
        category: 'Web',
        description:
            'Build server-rendered React applications with Next.js, Prisma, and PostgreSQL.',
        lastUpdated: DateTime(2025, 3, 5),
        lessonCount: 28,
      ),
      CourseModel(
        id: '8',
        title: 'Docker & Containerization',
        category: 'Backend',
        description:
            'Package and deploy applications reliably using Docker, Docker Compose, and CI/CD.',
        lastUpdated: DateTime(2025, 2, 18),
        lessonCount: 22,
      ),
    ];
  }

  // Returns the list of category names for the filter bar
  static List<String> getCategories() {
    return ['All', 'Mobile', 'Web', 'Backend', 'Design'];
  }
}
