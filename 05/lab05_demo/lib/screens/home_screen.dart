// UI LAYER — HomeScreen
// StatefulWidget: state management with setState().
// Demonstrates all Lab 05 concepts in one screen:
//   - SingleChildScrollView: prevents overflow on small devices
//   - DRY: all colors from Theme.of(context), zero hardcoded values
//   - GestureDetector: via DateInputField calendar icon tap
//   - BoxConstraints: enforced inside ResultRow and DateInputField
//   - Three-layer separation: UI → Business Logic → Data
//   - setState() triggers rebuild when dates or results change

import 'package:flutter/material.dart';
import '../models/age_input_model.dart';
import '../logic/age_calculator.dart';
import '../widgets/date_input_field.dart';
import '../widgets/result_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables — changing these calls setState() to rebuild the UI
  DateTime _birthDate = DateTime(2000, 1, 1);
  DateTime _todayDate = DateTime(2020, 1, 1);
  Map<String, int>? _age;
  Map<String, int>? _nextBirthday;

  void _calculate() {
    // DATA LAYER: build typed model from current state
    final model = AgeInputModel(
      birthDate: _birthDate,
      todayDate: _todayDate,
    );

    // BUSINESS LOGIC LAYER: strictly typed — only AgeInputModel accepted
    // calculateAge() and calculateNextBirthday() also print to terminal
    final calculator = AgeCalculator(model);

    // setState() triggers a rebuild so the UI reflects the new results
    setState(() {
      _age = calculator.calculateAge();
      _nextBirthday = calculator.calculateNextBirthday();
    });
  }

  void _clear() {
    setState(() {
      _birthDate = DateTime(2000, 1, 1);
      _todayDate = DateTime(2020, 1, 1);
      _age = null;
      _nextBirthday = null;
    });
    debugPrint('[CLEAR] Dates and results reset.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Color from centralized theme — not hardcoded
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text(
          'Age Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // SingleChildScrollView — fixes overflow on small screens (Lab 05 Task 7)
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date of Birth — reusable DateInputField widget (DRY principle)
            DateInputField(
              label: 'Date of Birth',
              selectedDate: _birthDate,
              onDateSelected: (date) => setState(() => _birthDate = date),
            ),

            const SizedBox(height: 20),

            // Today Date — same widget, different params (DRY principle)
            DateInputField(
              label: 'Today Date',
              selectedDate: _todayDate,
              onDateSelected: (date) => setState(() => _todayDate = date),
            ),

            const SizedBox(height: 28),

            // CLEAR and CALCULATE buttons in a Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Color from theme — centralized theming (Task 5)
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: _clear,
                    child: const Text(
                      'CLEAR',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: _calculate,
                    child: const Text(
                      'CALCULATE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Age result — ResultRow receives typed Map from logic layer
            Center(
              child: Text(
                'Age is',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ResultRow(
              values: _age ?? {'years': 0, 'months': 0, 'days': 0},
            ),

            const SizedBox(height: 28),

            // Next birthday — same ResultRow widget (DRY)
            Center(
              child: Text(
                'Next Birth Day in',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ResultRow(
              values: _nextBirthday ?? {'years': 0, 'months': 0, 'days': 0},
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
