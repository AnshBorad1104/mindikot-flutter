import 'package:flutter/material.dart';

void main() {
  runApp(const MindiKotApp());
}

class MindiKotApp extends StatelessWidget {
  const MindiKotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('MindiKot'),
        ),
      ),
    );
  }
}