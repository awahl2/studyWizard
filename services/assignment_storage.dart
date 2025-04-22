import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../models/assignment_model.dart';

class AssignmentStorage {
  static Future<String> get _filePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/assignments.csv';
  }

  static Future<List<Assignment>> loadAssignments() async {
    final path = await _filePath;
    final file = File(path);

    if (!file.existsSync()) return [];

    final csvString = await file.readAsString();
    final csvList = const CsvToListConverter().convert(csvString);

    return csvList.map((row) => Assignment.fromCsvRow(row)).toList();
  }

  static Future<void> saveAssignments(List<Assignment> assignments) async {
    final path = await _filePath;
    final file = File(path);
    final rows = assignments.map((a) => a.toCsvRow()).toList();
    final csvString = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csvString);
  }
}
