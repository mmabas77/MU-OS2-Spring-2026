import 'package:flutter/material.dart';
import '../models/location.dart';
import '../widgets/image_section.dart';
import '../widgets/title_section.dart';
import '../widgets/actions_section.dart';
import '../widgets/description_section.dart';

class LocationScreen extends StatelessWidget {
  final Location location;

  const LocationScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Flex: 7 — image takes 70% of screen height
          Flexible(
            flex: 7,
            child: ImageSection(imageUrl: location.imageUrl),
          ),

          // Flex: 3 — content takes 30% of screen height
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSection(
                    name: location.name,
                    city: location.city,
                    rating: location.rating,
                  ),
                  const ActionsSection(),
                  DescriptionSection(text: location.description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
