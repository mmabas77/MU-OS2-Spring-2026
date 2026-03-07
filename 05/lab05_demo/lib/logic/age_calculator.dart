// BUSINESS LOGIC LAYER — AgeCalculator
// Pure logic class: no widgets, no BuildContext, no UI code.
// Strictly typed: accepts only AgeInputModel — no other type allowed.
// Demonstrates: isolated logic layer from Lab 05 (Task 13)

import 'package:flutter/foundation.dart';
import '../models/age_input_model.dart';

class AgeCalculator {
  final AgeInputModel input;

  AgeCalculator(this.input);

  // Calculates the full years, months, and days between birthDate and todayDate.
  // Prints results to terminal — no UI update needed.
  Map<String, int> calculateAge() {
    final birth = input.birthDate;
    final today = input.todayDate;

    int years = today.year - birth.year;
    int months = today.month - birth.month;
    int days = today.day - birth.day;

    if (days < 0) {
      months--;
      // Number of days in the month before today's month
      final daysInPrevMonth = DateTime(today.year, today.month, 0).day;
      days += daysInPrevMonth;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final result = {'years': years, 'months': months, 'days': days};
    debugPrint('[AGE] $result');
    return result;
  }

  // Calculates years, months, and days remaining until the next birthday.
  // Demonstrates: isOver1000DaysOld() pattern — boolean milestone extended to date difference.
  Map<String, int> calculateNextBirthday() {
    final birth = input.birthDate;
    final today = input.todayDate;

    // Compute this year's birthday; advance to next year if already passed
    DateTime next = DateTime(today.year, birth.month, birth.day);
    if (!next.isAfter(today)) {
      next = DateTime(today.year + 1, birth.month, birth.day);
    }

    int years = next.year - today.year;
    int months = next.month - today.month;
    int days = next.day - today.day;

    if (days < 0) {
      months--;
      final daysInPrevMonth = DateTime(next.year, next.month, 0).day;
      days += daysInPrevMonth;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final result = {'years': years, 'months': months, 'days': days};
    debugPrint('[NEXT BIRTHDAY] $result');
    return result;
  }
}
