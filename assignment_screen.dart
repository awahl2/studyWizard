import 'package:flutter/material.dart';
import 'assignment_model.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
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
                        setState(() {
                          _assignments[editIndex] = Assignment(
                            title: _titleController.text,
                            course: _selectedCourse!,
                            date: _selectedDate!,
                            isComplete: _assignments[editIndex].isComplete,
                          );
                        });
                      } else {
                        setState(() {
                          _assignments.add(
                            Assignment(
                              title: _titleController.text,
                              course: _selectedCourse!,
                              date: _selectedDate!,
                              isComplete: false,
                            ),
                          );
                        });
                      }
                      _titleController.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(editIndex != null
                      ? 'Edit Assignment'
                      : (type == 'Course' ? 'Add Course' : 'Add Assignment')),
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
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Checkbox(
          value: assignment.isComplete,
          onChanged: (_) => _toggleCompletion(index),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: assignment.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          assignment.course,
          style: TextStyle(fontSize: 14),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.brown[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${assignment.date.month}/${assignment.date.day}',
            style: TextStyle(fontSize: 12),
          ),
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDropdownMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 140, 20, 0),
      items: [
        PopupMenuItem(
          value: 'Assignment',
          child: Text('Assignment'),
        ),
        PopupMenuItem(
          value: 'Test',
          child: Text('Test'),
        ),
        PopupMenuItem(
          value: 'Course',
          child: Text('Course'),
        ),
        PopupMenuItem(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _showAddDialog(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xDDBDAA94),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ASSIGNMENTS',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xDDBDAA94),
                    shape: StadiumBorder(),
                    elevation: 2,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  onPressed: _showDropdownMenu,
                  child: Icon(Icons.add, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: _assignments.isEmpty
                  ? Center(child: Text('No assignments yet.'))
                  : ListView.builder(
                      itemCount: _assignments.length,
                      itemBuilder: (ctx, index) => _buildAssignmentTile(_assignments[index], index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
