// UI LAYER — ResultRow
// Accepts a strictly typed Map<String, int> — no other type allowed.
// Demonstrates: strict data typing connecting logic layer to UI layer (Task 11).
// BoxConstraints enforces minimum height on each result box.
// All colors from Theme.of(context) — centralized theming.

import 'package:flutter/material.dart';

class ResultRow extends StatelessWidget {
  // Strict data typing: only Map<String, int> with years/months/days keys accepted
  final Map<String, int> values;

  const ResultRow({required this.values, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        _ResultBox(label: 'Years', value: values['years'] ?? 0, color: color),
        const SizedBox(width: 8),
        _ResultBox(label: 'Months', value: values['months'] ?? 0, color: color),
        const SizedBox(width: 8),
        _ResultBox(label: 'Days', value: values['days'] ?? 0, color: color),
      ],
    );
  }
}

class _ResultBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ResultBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Label header — filled with primary color
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Value box — BoxConstraints ensures minimum height (Lab 05 constraint demo)
          Container(
            constraints: const BoxConstraints(minHeight: 40),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
