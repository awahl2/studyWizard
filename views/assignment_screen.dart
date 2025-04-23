import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/assignment_controller.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AssignmentController>(context, listen: false).loadAssignments();
  }

  void _showEditDialog(BuildContext context, int index, String currentTitle) {
    final controller = Provider.of<AssignmentController>(context, listen: false);
    final TextEditingController editController = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Assignment'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Edit title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isNotEmpty) {
                controller.updateAssignment(index, newText);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AssignmentController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'New assignment'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      controller.addAssignment(text);
                      _textController.clear();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.assignments.length,
              itemBuilder: (context, index) {
                final assignment = controller.assignments[index];
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey), // Updated to gray
                    onPressed: () => controller.deleteAssignment(index),
                  ),
                  title: GestureDetector(
                    onTap: () => _showEditDialog(context, index, assignment.title),
                    child: Text(
                      assignment.title,
                      style: TextStyle(
                        decoration: assignment.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  trailing: Checkbox(
                    value: assignment.isCompleted,
                    onChanged: (_) => controller.toggleAssignmentCompletion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
