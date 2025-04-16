// assignment_provider.dart

import 'package:flutter/material.dart';
import 'assignment_model.dart';
import 'assignment_storage.dart';

class AssignmentProvider extends ChangeNotifier {
  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    _assignments = await AssignmentStorage.loadAssignments();
    notifyListeners();
  }

  Future<void> saveAssignments() async {
    await AssignmentStorage.saveAssignments(_assignments);
  }

  void setAssignments(List<Assignment> list) {
    _assignments = list;
    saveAssignments();
    notifyListeners();
  }

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    saveAssignments();
    notifyListeners();
  }

  void updateAssignment(int index, Assignment updated) {
    _assignments[index] = updated;
    saveAssignments();
    notifyListeners();
  }

  void deleteAssignment(int index) {
    _assignments.removeAt(index);
    saveAssignments();
    notifyListeners();
  }

  void toggleCompletion(int index) {
    _assignments[index].isComplete = !_assignments[index].isComplete;
    saveAssignments();
    notifyListeners();
  }
}
