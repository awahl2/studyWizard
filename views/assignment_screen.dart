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
                return CheckboxListTile(
                  title: Text(assignment.title),
                  value: assignment.isCompleted,
                  onChanged: (_) => controller.toggleAssignmentCompletion(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
