import 'package:flutter/material.dart';
import 'assignment_screen.dart'; // Make sure the path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignments App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssignmentScreen(),
    );
  }
}
