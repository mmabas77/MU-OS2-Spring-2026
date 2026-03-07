// DATA LAYER — PersonModel
// Holds structured data for a person.
// The UI and Logic layers receive this object; they never handle raw fields directly.

class PersonModel {
  final String name;
  final int age;
  final DateTime birthDate;
  final String major;

  const PersonModel({
    required this.name,
    required this.age,
    required this.birthDate,
    required this.major,
  });
}
