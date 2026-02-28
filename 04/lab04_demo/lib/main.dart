import 'package:flutter/material.dart';
import 'models/location.dart';
import 'screens/location_screen.dart';

// Sample data — demonstrates Section 4: Integrating Data Models
const location = Location(
  name: 'Lake of Egypt',
  city: 'Cairo',
  rating: 54.0,
  imageUrl:
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
  description:
      'Lake of Egypt is a breathtaking natural destination located near Cairo. '
      'Known for its crystal-clear blue waters surrounded by golden mountains, '
      'it offers a stunning contrast of colors that attracts visitors from all over the world. '
      'The lake is perfect for hiking, photography, and enjoying the serene Egyptian landscape.',
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 04 Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LocationScreen(location: location),
    );
  }
}
