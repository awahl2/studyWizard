import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'assignment_provider.dart';
import 'assignment_storage.dart';
import 'home_screen.dart';
import 'assignment_screen.dart';
import 'pomodoro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final assignments = await AssignmentStorage.loadAssignments();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AssignmentProvider()..setAssignments(assignments),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Wizard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    AssignmentScreen(),
    const PomodoroScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
        ],
      ),
    );
  }
}
