// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'assignment_model.dart';
import 'assignment_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWeekSelected = true;

  List<Assignment> _filterAssignments(List<Assignment> allAssignments) {
    if (isWeekSelected) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return allAssignments.where((a) => a.date.isAfter(startOfWeek)).toList();
    } else {
      return allAssignments;
    }
  }

  int countByStatus(List<Assignment> list, String status) {
    return status == "complete"
        ? list.where((a) => a.isComplete).length
        : list.where((a) => !a.isComplete).length;
  }

  @override
  Widget build(BuildContext context) {
    final assignments = context.watch<AssignmentProvider>().assignments;
    final filteredAssignments = _filterAssignments(assignments);

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
                        countByStatus(filteredAssignments, status).toString(),
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
                    final realIndex = assignments.indexOf(assignment);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Checkbox(
                          value: assignment.isComplete,
                          onChanged: (_) {
                            context.read<AssignmentProvider>().toggleCompletion(realIndex);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Text(assignment.title),
                        subtitle: Text("${assignment.course} • ${assignment.isComplete ? 'Completed' : 'Incomplete'}"),
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
