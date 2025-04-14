import 'package:flutter/material.dart';
import 'assignment_model.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  AssignmentScreenState createState() => AssignmentScreenState();
}

class AssignmentScreenState extends State<AssignmentScreen> {
  final List<Assignment> _assignments = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _newCourseController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCourse;

  List<String> _courseOptions = ['Math', 'Science', 'English'];

  void _toggleCompletion(int index) {
    setState(() {
      _assignments[index].isComplete = !_assignments[index].isComplete;
    });
  }

  void _pickDate(Function(DateTime) onDatePicked) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDatePicked(picked);
  }

  void _showAddDialog(String type, {int? editIndex}) {
    _titleController.clear();
    _selectedCourse = null;
    _selectedDate = null;

    // Pre-fill the fields if editing
    if (editIndex != null) {
      final assignment = _assignments[editIndex];
      _titleController.text = assignment.title;
      _selectedCourse = assignment.course;
      _selectedDate = assignment.date;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (type == 'Course')
                  TextField(
                    controller: _newCourseController,
                    decoration: InputDecoration(labelText: 'Course Name'),
                  )
                else ...[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: type == 'Test' ? 'Test Name' : 'Assignment Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedCourse,
                    items: _courseOptions
                        .map((course) => DropdownMenuItem<String>(value: course, child: Text(course)))
                        .toList(),
                    onChanged: (val) => setModalState(() => _selectedCourse = val),
                    decoration: InputDecoration(labelText: 'Course'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',

                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _pickDate((picked) {
                            setModalState(() => _selectedDate = picked);
                          });
                        },
                        child: Text('Pick Date'),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (type == 'Course') {
                      if (_newCourseController.text.isEmpty) return;
                      setState(() {
                        _courseOptions.add(_newCourseController.text);
                      });
                      _newCourseController.clear();
                    } else {
                      if (_titleController.text.isEmpty || _selectedCourse == null || _selectedDate == null) return;
                      if (editIndex != null) {
                        // Edit the existing assignment, keep the completion status
                        setState(() {
                          _assignments[editIndex] = Assignment(
                            title: _titleController.text,
                            course: _selectedCourse!,
                            date: _selectedDate!,
                            isComplete: _assignments[editIndex].isComplete, // Keep the old completion status
                          );
                        });
                      } else {
                        // Add a new assignment
                        setState(() {
                          _assignments.add(
                            Assignment(
                              title: _titleController.text,
                              course: _selectedCourse!,
                              date: _selectedDate!,
                              isComplete: false, // New assignment starts as incomplete
                            ),
                          );
                        });
                      }
                      _titleController.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(editIndex != null ? 'Edit Assignment' : 'Add Assignment'),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAssignmentTile(Assignment assignment, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: assignment.isComplete ? Colors.green.shade100 : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            decoration: assignment.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${assignment.course} • ${assignment.date.toLocal().toString().split(' ')[0]}',
          style: TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(
            assignment.isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            color: assignment.isComplete ? Colors.green : Colors.grey,
          ),
          onPressed: () => _toggleCompletion(index),
        ),
        onTap: () => _showAssignmentDetailDialog(assignment, index),
      ),
    );
  }

  void _showAssignmentDetailDialog(Assignment assignment, int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Assignment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ${assignment.title}'),
              Text('Course: ${assignment.course}'),
              Text('Date: ${assignment.date.toLocal().toString().split(' ')[0]}'),
              Text('Completed: ${assignment.isComplete ? 'Yes' : 'No'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddDialog('Assignment', editIndex: index);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _assignments.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog('Assignment'),
            tooltip: 'Add Assignment',
          ),
          IconButton(
            icon: Icon(Icons.school),
            onPressed: () => _showAddDialog('Course'),
            tooltip: 'Add Course',
          ),
        ],
      ),
      body: _assignments.isEmpty
          ? Center(child: Text('No assignments yet.'))
          : ListView.builder(
              itemCount: _assignments.length,
              itemBuilder: (ctx, index) => _buildAssignmentTile(_assignments[index], index),
            ),
    );
  }
}
