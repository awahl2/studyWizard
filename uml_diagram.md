# :bookmark_tabs: UML Diagram
```mermaid
classDiagram
  class Assignment {
    - String title
    - String course
    - DateTime date
    - bool isComplete
    + Assignment(String title, String course, DateTime date, bool isComplete = false)
  }
