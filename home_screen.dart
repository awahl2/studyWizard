import 'package:flutter/material.dart';
import 'assignment_model.dart';
import 'assignment_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWeekSelected = true;
  List<Assignment> allAssignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() async {
    final loaded = await AssignmentStorage.loadAssignments();
    setState(() {
      allAssignments = loaded;
    });
  }

  List<Assignment> get filteredAssignments {
    if (isWeekSelected) {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return allAssignments.where((a) => a.date.isAfter(startOfWeek)).toList();
    } else {
      return allAssignments;
    }
  }

  int countByStatus(String status) {
    switch (status) {
      case "incomplete":
        return filteredAssignments.where((a) => !a.isComplete).length;
      case "complete":
        return filteredAssignments.where((a) => a.isComplete).length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              color: const Color(0xFFD2BAA4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'HOME',
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFC8B7A6),
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(20),
                    isSelected: [isWeekSelected, !isWeekSelected],
                    onPressed: (index) {
                      setState(() {
                        isWeekSelected = index == 0;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Week"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Total"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Counters
            ...["incomplete", "complete"].map(
              (status) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFC8B7A6),
                      radius: 14,
                      child: Text(
                        countByStatus(status).toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      status,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // "This Week" Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4D3C1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "This Week:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Assignments List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: filteredAssignments.length,
                  itemBuilder: (context, index) {
                    final assignment = filteredAssignments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Checkbox(
                          value: assignment.isComplete,
                          onChanged: (val) {
                            setState(() {
                              assignment.isComplete = val ?? false;
                            });
                            AssignmentStorage.saveAssignments(allAssignments);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        title: Text(assignment.title),
                        subtitle: Text(
                            "${assignment.course} • ${assignment.isComplete ? 'Completed' : 'Incomplete'}"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tileColor: const Color(0xFFEAE8E4),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
