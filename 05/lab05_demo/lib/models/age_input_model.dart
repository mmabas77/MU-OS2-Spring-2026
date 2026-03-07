// DATA LAYER — AgeInputModel
// Pure Dart class: no Flutter imports, no widgets.
// Groups the two date inputs together as structured data.
// Demonstrates: data model class from Lab 05 (Task 9)

class AgeInputModel {
  final DateTime birthDate;
  final DateTime todayDate;

  const AgeInputModel({
    required this.birthDate,
    required this.todayDate,
  });
}
