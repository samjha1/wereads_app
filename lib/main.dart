import 'package:flutter/material.dart';
import 'package:wereads/dashboard.dart';
import 'package:wereads/dashboards.dart';

void main() {
  runApp(const MyApp()); // Start the app with MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Login App', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // App theme color
      ),
      // Define routes for navigation
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => HomeScreen(), // Default route (login page)
        '/Front_Page': (context) =>
            const ReceptionDashboard(), // Admin dashboard
        '/FrontPage': (context) => HomeScreen(), // Reception dashboard
      },
    );
  }
}
