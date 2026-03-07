// BUSINESS LOGIC LAYER — DaysCalculator
// Pure logic class. No widgets, no BuildContext, no UI code.
// Receives a DateTime and performs calculations only.

class DaysCalculator {
  final DateTime birthDate;

  DaysCalculator(this.birthDate);

  // Returns the number of full days elapsed since birthDate
  int calculateDaysAlive() {
    return DateTime.now().difference(birthDate).inDays;
  }

  // Returns true when the person has been alive for more than 1000 days
  bool isOver1000DaysOld() {
    return calculateDaysAlive() > 1000;
  }

  // Returns a human-readable summary of the calculation
  String summary() {
    final days = calculateDaysAlive();
    final milestone = isOver1000DaysOld() ? 'over 1,000' : 'under 1,000';
    return '$days days alive ($milestone days milestone)';
  }
}
