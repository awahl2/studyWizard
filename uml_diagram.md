## :bookmark_tabs: UML Diagram

```mermaid
classDiagram
    direction TB

    class Assignment {
        - String title
        - String course
        - DateTime date
        - bool isComplete
        + Assignment(String title, String course, DateTime date, bool isComplete = false)
    }

    class AssignmentProvider {
        - List~Assignment~ _assignments
        + List~Assignment~ get assignments
        + void addAssignment(Assignment assignment)
        + void toggleCompletion(Assignment assignment)
        + Future~void~ loadAssignments()
        + Future~void~ saveAssignments()
    }

    class AssignmentStorage {
        + static Future~void~ saveAssignments(List~Assignment~ assignments)
        + static Future~List~Assignment~~ loadAssignments()
    }

    class AssignmentScreen {
        + Widget build(BuildContext context)
        + UI for adding and listing assignments
    }

    class HomeScreen {
        + Widget build(BuildContext context)
        + UI for weekly overview and completion stats
    }

    class PomodoroScreen {
        + Widget build(BuildContext context)
        + Pomodoro timer UI and controls
    }

    class main.dart {
        + void main()
        + Uses MultiProvider
        + Sets HomeScreen as default route
    }

    AssignmentProvider --> Assignment
    AssignmentProvider --> AssignmentStorage
    AssignmentScreen --> AssignmentProvider
    HomeScreen --> AssignmentProvider
    PomodoroScreen --> HomeScreen : navigation
    main.dart --> AssignmentProvider
    main.dart --> HomeScreen
    main.dart --> AssignmentScreen
    main.dart --> PomodoroScreen
