import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(color: Colors.red,
              height: 500,
              width: 500,
              child: HomeScreen()),
        ),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.blue,
          child: Text("Iam T1"),
        ),Container(
          color: Colors.greenAccent,
          child: Text("Iam T2"),
        ),Container(
          color: Colors.yellow,
          child: Text("Iam T3"),
        ),Container(
          color: Colors.teal,
          child: Text("Iam T4"),
        ),
      ],
    );
  }
}
