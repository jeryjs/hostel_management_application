// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../Models/student_model.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/students_banner.webp',
                height: 200, fit: BoxFit.cover),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget studentCard(Student s) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(s.name),
          Text(s.email.join(', ')),
          Text(s.contact.join(', ')),
          Text(s.hostel),
          Text(s.id),
        ],
      ),
    );
  }
}
