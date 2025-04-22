class Assignment {
  String title;
  bool isCompleted;

  Assignment({required this.title, this.isCompleted = false});

  List<String> toCsvRow() => [title, isCompleted.toString()];

  factory Assignment.fromCsvRow(List<dynamic> row) {
    return Assignment(
      title: row[0],
      isCompleted: row[1].toLowerCase() == 'true',
    );
  }
}
