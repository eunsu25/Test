import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(OnnoonApp());
}

class OnnoonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onnoon',
      home: HomeScreen(),
    );
  }
}
