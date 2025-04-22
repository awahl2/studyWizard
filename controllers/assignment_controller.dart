import 'package:flutter/material.dart';
import '../models/assignment_model.dart';
import '../services/assignment_storage.dart';

class AssignmentController extends ChangeNotifier {
  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    _assignments = await AssignmentStorage.loadAssignments();
    notifyListeners();
  }

  Future<void> addAssignment(String title) async {
    _assignments.add(Assignment(title: title));
    await AssignmentStorage.saveAssignments(_assignments);
    notifyListeners();
  }

  Future<void> toggleAssignmentCompletion(int index) async {
    _assignments[index].isCompleted = !_assignments[index].isCompleted;
    await AssignmentStorage.saveAssignments(_assignments);
    notifyListeners();
  }
}
