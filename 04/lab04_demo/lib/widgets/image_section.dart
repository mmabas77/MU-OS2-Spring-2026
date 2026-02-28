import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final String imageUrl;

  const ImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
