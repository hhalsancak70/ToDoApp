// Model class representing a single task item
class Task {
  String id; // Unique identifier for the task
  String title; // Title or description of the task
  bool isCompleted; // Status indicating if the task is completed or not
  DateTime date; // Date associated with the task (e.g., creation or due date)

  // Constructor with required fields and default value for isCompleted
  Task({
    required this.id, // id must be provided when creating a Task
    required this.title, // title must be provided
    this.isCompleted = false, // isCompleted defaults to false if not specified
    required this.date, // date must be provided
  });
}
