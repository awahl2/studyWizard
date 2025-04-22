import 'package:flutter/material.dart';
import '../services/assignment_storage.dart';

class HomeController extends ChangeNotifier {
  int completed = 0;
  int total = 0;

  Future<void> updateStats() async {
    final assignments = await AssignmentStorage.loadAssignments();
    total = assignments.length;
    completed = assignments.where((a) => a.isCompleted).length;
    notifyListeners();
  }
}
