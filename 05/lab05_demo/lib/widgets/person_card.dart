// UI LAYER — PersonCard widget
// Displays a PersonModel and uses the DaysCalculator logic class.
// Colors come from Theme.of(context) — no hardcoded color values anywhere.

import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../logic/days_calculator.dart';

class PersonCard extends StatelessWidget {
  // Strictly typed — only accepts a PersonModel, nothing else
  final PersonModel person;
  final VoidCallback? onTap;

  const PersonCard({
    required this.person,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Logic layer: instantiate the calculator with the person's birth date
    final calculator = DaysCalculator(person.birthDate);

    // Theme.of(context): all colors come from the centralized ThemeData
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row — name + milestone badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    person.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (calculator.isOver1000DaysOld())
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        // Using theme color — not hardcoded
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '1000+ days',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Major
              Row(
                children: [
                  Icon(Icons.school,
                      size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 6),
                  Text(
                    person.major,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Age
              Row(
                children: [
                  Icon(Icons.cake,
                      size: 16, color: theme.colorScheme.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'Age: ${person.age}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Days summary from the logic layer
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: theme.colorScheme.tertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      calculator.summary(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
