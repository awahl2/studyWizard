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

  void _showAddDialog(String type) {
    _titleController.clear();
    _selectedCourse = null;
    _selectedDate = null;

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
                        .map((course) => DropdownMenuItem<String>(
                              value: course,
                              child: Text(course),
                            ))
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
                              : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
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
                      setState(() {
                        _assignments.add(
                          Assignment(
                            title: _titleController.text,
                            course: _selectedCourse!,
                            date: _selectedDate!,
                          ),
                        );
                      });
                      _titleController.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Add $type'),
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          value: assignment.isComplete,
          onChanged: (_) => _toggleCompletion(index),
        ),
        title: Text(assignment.title),
        subtitle: Text(assignment.course),
        trailing: Text(
          '${assignment.date.toLocal()}'.split(' ')[0],
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _showAddDialog,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Assignment', child: Text('New Assignment')),
              PopupMenuItem(value: 'Test', child: Text('New Test')),
              PopupMenuItem(value: 'Course', child: Text('New Course')),
            ],
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _assignments.isEmpty
            ? Center(child: Text("No assignments or tests yet."))
            : ListView.builder(
                itemCount: _assignments.length,
                itemBuilder: (context, index) =>
                    _buildAssignmentTile(_assignments[index], index),
              ),
      ),
    );
  }
}
