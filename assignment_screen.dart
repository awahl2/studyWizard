// assignment_screen.dart

import 'package:flutter/material.dart';
import 'assignment_model.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> with TickerProviderStateMixin {
  final List<Assignment> _assignments = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _newCourseController = TextEditingController();
  final GlobalKey _menuKey = GlobalKey();

  DateTime? _selectedDate;
  String? _selectedCourse;

  List<String> _courseOptions = ['Math', 'Science', 'English'];
  OverlayEntry? _dropdownEntry;
  AnimationController? _dropdownAnimationController;

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
    _newCourseController.clear();

    if (editIndex != null) {
      final assignment = _assignments[editIndex];
      _titleController.text = assignment.title;
      _selectedCourse = assignment.course;
      _selectedDate = assignment.date;
    } else {
      _selectedCourse = null;
      _selectedDate = null;
    }

    _closeDropdown(); // Ensure dropdown is closed before opening dialog

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
                      labelText: type == 'Test'
                          ? 'Test Name'
                          : type == 'Other'
                              ? 'Other Event Name'
                              : 'Assignment Name',
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
                      if (_titleController.text.isEmpty ||
                          _selectedCourse == null ||
                          _selectedDate == null) {
                        return;
                      }

                      final assignment = Assignment(
                        title: _titleController.text,
                        course: _selectedCourse!,
                        date: _selectedDate!,
                        isComplete: editIndex != null ? _assignments[editIndex].isComplete : false,
                      );

                      setState(() {
                        if (editIndex != null) {
                          _assignments[editIndex] = assignment;
                        } else {
                          _assignments.add(assignment);
                        }
                      });

                      _titleController.clear();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    editIndex != null
                        ? 'Edit ${type == 'Other' ? 'Other Event' : 'Assignment'}'
                        : type == 'Course'
                            ? 'Add Course'
                            : type == 'Other'
                                ? 'Add Other Event'
                                : 'Add Assignment',
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDropdownMenu() {
    final RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _dropdownAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    final Animation<double> scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _dropdownAnimationController!, curve: Curves.easeOut),
    );
    final Animation<double> opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dropdownAnimationController!, curve: Curves.easeOut),
    );

    _dropdownEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: FadeTransition(
            opacity: opacity,
            child: ScaleTransition(
              scale: scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPopupItem('Assignment'),
                  _buildPopupItem('Test'),
                  _buildPopupItem('Course'),
                  _buildPopupItem('Other'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_dropdownEntry!);
    _dropdownAnimationController!.forward();
  }

  void _closeDropdown() {
    if (_dropdownEntry != null && _dropdownAnimationController != null) {
      _dropdownAnimationController!.reverse().then((_) {
        _dropdownEntry?.remove();
        _dropdownEntry = null;
        _dropdownAnimationController?.dispose();
        _dropdownAnimationController = null;
      });
    }
  }

  Widget _buildPopupItem(String type) {
    return InkWell(
      onTap: () {
        _closeDropdown();
        _showAddDialog(type);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        width: 140,
        child: Text(type, style: TextStyle(color: Colors.black)),
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

  @override
  void dispose() {
    _titleController.dispose();
    _newCourseController.dispose();
    _dropdownAnimationController?.dispose();
    super.dispose();
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
                  key: _menuKey,
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
