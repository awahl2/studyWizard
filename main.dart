import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/assignment_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/pomodoro_controller.dart';
import 'views/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssignmentController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => PomodoroController()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Study Wizard',
        home: MainNavigation(),
      ),
    );
  }
}
