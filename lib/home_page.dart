import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:intl/intl.dart'; // For formatting dates
import 'task.dart'; // Task model class

// Main screen of the app as a StatefulWidget to manage dynamic data
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState(); // Create mutable state
}

// State class for MyHomePage widget
class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = []; // List to store tasks
  final TextEditingController _taskController = TextEditingController(); // Controller for the task input field

  // Function to add a new task
  void _addTask(String taskTitle) {
    // Check if input is empty or only spaces
    if (taskTitle.trim().isEmpty) {
      // Show error message if empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task title cannot be empty!'), // Message text
          backgroundColor: Colors.red, // Red background for error
          duration: Duration(seconds: 2), // Duration to show the snackbar
        ),
      );
      return; // Exit function early
    }

    // Add task to list and update UI
    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(), // Unique ID based on current time
          title: taskTitle, // Task title from input
          date: DateTime.now(), // Current date/time
        ),
      );
    });

    _taskController.clear(); // Clear input field after adding
  }

  // Toggle completion status of task at given index
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted; // Switch true/false
    });
  }

  // Delete task at given index
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index); // Remove task from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the app bar for full background effect
      appBar: AppBar(
        title: const Text('📝 To-Do List'), // App bar title with emoji
        centerTitle: true, // Center the title text
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Background gradient from top to bottom
          gradient: LinearGradient(
            colors: [Color(0xFFBBD2C5), Color(0xFF536976)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 24), // Spacer for app bar height + extra padding

            // Card widget containing the input field and add button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Rounded corners
                elevation: 12, // Shadow depth
                shadowColor: Colors.black38, // Shadow color
                child: Padding(
                  padding: const EdgeInsets.all(16), // Inner padding
                  child: Row(
                    children: [
                      Expanded(
                        // Text input expands to fill remaining space
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Add a new task...', // Placeholder text
                            prefixIcon: Icon(Icons.edit_note_rounded, color: Colors.deepPurple), // Icon on left
                          ),
                          controller: _taskController, // Connects text field to controller
                          onSubmitted: (_) => _addTask(_taskController.text), // Add task on keyboard submit
                        ),
                      ),
                      const SizedBox(width: 8), // Space between input and button
                      ElevatedButton(
                        onPressed: () => _addTask(_taskController.text), // Add task on button press
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple, // Button color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded corners
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding inside button
                        ),
                        child: const Icon(Icons.add, color: Colors.white), // Plus icon on button
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12), // Spacing between input card and task list

            // Expanded widget to fill remaining space for the task list
            Expanded(
              child: _tasks.isEmpty
              // Show placeholder UI when no tasks exist
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hourglass_empty_rounded, size: 80, color: Colors.white70), // Empty icon
                  const SizedBox(height: 12),
                  const Text(
                    'No tasks yet!',
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Add something to get started 💡',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              )
              // Otherwise, show a scrollable list of tasks
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // List padding
                itemCount: _tasks.length, // Number of items in list
                itemBuilder: (ctx, index) {
                  final task = _tasks[index]; // Current task

                  return Dismissible(
                    key: Key(task.id), // Unique key to identify each dismissible item
                    direction: DismissDirection.endToStart, // Swipe from right to left to delete
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.shade200, // Red background when swiping
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28), // Delete icon
                    ),
                    onDismissed: (_) => _deleteTask(index), // Delete task on swipe
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), // Smooth animation duration
                      curve: Curves.easeInOut, // Animation curve
                      margin: const EdgeInsets.symmetric(vertical: 6), // Vertical margin between items
                      decoration: BoxDecoration(
                        color: task.isCompleted ? Colors.greenAccent.shade100 : Colors.white, // Background color based on completion
                        borderRadius: BorderRadius.circular(16), // Rounded corners
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding inside each list item
                        leading: GestureDetector(
                          onTap: () => _toggleTaskCompletion(index), // Toggle completion on tap
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300), // Animation for box color change
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: task.isCompleted ? Colors.deepPurple : Colors.transparent, // Filled if completed
                              border: Border.all(color: Colors.deepPurple, width: 2), // Border for the box
                              borderRadius: BorderRadius.circular(6), // Rounded corners
                            ),
                            child: task.isCompleted
                                ? const Icon(Icons.check, size: 16, color: Colors.white) // Check icon when completed
                                : null,
                          ),
                        ),
                        title: Text(
                          task.title, // Task title text
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null, // Strike-through if completed
                            color: task.isCompleted ? Colors.deepPurple : Colors.black87, // Color changes on completion
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple.shade200), // Calendar icon for date
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy').format(task.date), // Formatted task date
                              style: TextStyle(fontSize: 13, color: Colors.deepPurple.shade200),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400), // Delete button icon
                          onPressed: () => _deleteTask(index), // Delete task on button press
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
