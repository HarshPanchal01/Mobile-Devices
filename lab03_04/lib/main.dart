import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lab 03_04',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 10, 98, 170)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}