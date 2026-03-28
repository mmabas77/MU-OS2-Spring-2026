// UTILITY — DateFormatter
// Wraps the intl DateFormat class in a single static method.
// Centralises the date format string so changing it affects the whole app.
// Demonstrates: intl package + clean code utility extraction.

import 'package:intl/intl.dart';

class DateFormatter {
  // Returns a human-readable date string, e.g. "5 Mar 2025"
  static String format(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}
