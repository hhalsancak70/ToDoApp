import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the home page widget from another file

// Entry point of the application using arrow function shorthand
void main() => runApp(MyApp());

// Root widget of the app which is stateless since it doesn’t hold any state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List', // Title of the application
      debugShowCheckedModeBanner: false, // Disable the debug banner on the top right
      theme: ThemeData(
        // Defines the color scheme seeded from deep purple
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Enables Material Design 3 styling
        scaffoldBackgroundColor: const Color(0xFFF6F6F6), // Sets a light gray background color for all scaffolds
      ),
      home: MyHomePage(), // Sets the home screen widget to MyHomePage (imported from home_page.dart)
    );
  }
}
