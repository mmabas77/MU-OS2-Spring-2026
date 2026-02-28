import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String name;
  final String city;
  final double rating;

  const TitleSection({
    super.key,
    required this.name,
    required this.city,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + city stacked on the left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Rating on the right
          Row(
            children: [
              const Icon(Icons.star, color: Colors.red, size: 20),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
