import 'package:flutter/material.dart';
import 'package:vricalc/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalConv',
      theme: ThemeData.dark(),
      home: const CalcBotNavBar(),
    );
  }
}
