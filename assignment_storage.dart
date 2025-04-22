// assignment_storage.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'assignment_model.dart';

class AssignmentStorage {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/assignments.csv';
  }

  static Future<void> saveAssignments(List<Assignment> assignments) async {
    final filePath = await _getFilePath();
    final file = File(filePath);
    final rows = assignments.map((a) => [
      a.title,
      a.course,
      a.date.toIso8601String(),
      a.isComplete ? '1' : '0',
    ]).toList();

    final csvData = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csvData);
  }

  static Future<List<Assignment>> loadAssignments() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!await file.exists()) return [];

    final csvContent = await file.readAsString();
    final rows = const CsvToListConverter().convert(csvContent);

    return rows.where((row) {
      // Make sure each row has exactly 4 elements
      if (row.length != 4) {
        print('Skipping malformed row: $row');
        return false;
      }
      return true;
    }).map((row) {
      try {
        return Assignment(
          title: row[0],
          course: row[1],
          date: DateTime.parse(row[2]),
          isComplete: row[3] == '1',
        );
      } catch (e) {
        // print('Error parsing row: $row');
        return null;
      }
    }).whereType<Assignment>().toList(); // Filter out any nulls
  }
}
