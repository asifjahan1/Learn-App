// ignore_for_file: library_private_types_in_public_api

import 'package:course_details_app/Screen/course_details_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CourseDetailsScreen(),
    );
  }
}
