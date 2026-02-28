import 'package:flutter/material.dart';
import 'action_button.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          ActionButton(icon: Icons.call, label: 'CALL'),
          ActionButton(icon: Icons.location_on, label: 'LOCATION'),
          ActionButton(icon: Icons.share, label: 'SHARE'),
        ],
      ),
    );
  }
}
