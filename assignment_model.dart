// assignment_model.dart
class Assignment {
  String title;
  String course;
  DateTime date;
  bool isComplete;

  Assignment({
    required this.title,
    required this.course,
    required this.date,
    this.isComplete = false,
  });
}
