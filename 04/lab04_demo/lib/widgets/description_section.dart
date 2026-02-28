import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final String text;

  const DescriptionSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.5),
      ),
    );
  }
}
