// UI LAYER — DateInputField
// Reusable widget: handles BOTH Date of Birth and Today Date inputs.
// Demonstrates DRY principle — one widget, zero code duplication.
// GestureDetector triggers the date picker (user interaction pattern).
// All colors from Theme.of(context) — zero hardcoded values.

import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateInputField({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  // Formats a DateTime as dd-MM-yyyy (e.g., 01-01-2000)
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d-$m-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = selectedDate != null ? _formatDate(selectedDate!) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          // BoxConstraints: minimum height regardless of content (Lab 05 constraint demo)
          constraints: const BoxConstraints(minHeight: 50),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(display, style: theme.textTheme.bodyLarge),
                ),
              ),
              // GestureDetector — user interaction: tap opens date picker
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) onDateSelected(picked);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.calendar_today,
                    // Color from theme — not hardcoded (DRY / centralized theming)
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
