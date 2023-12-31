// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:hostel_management_application/Components/contact_card.dart';
import 'package:hostel_management_application/Components/random_person_icon.dart';

import '../Components/edit_student_dialog.dart';
import '../Models/hostel_model.dart';
import '../Models/student_model.dart';
import '../database.dart';

class StudentsPage extends StatefulWidget {
  final Hostel? hostel;

  const StudentsPage({this.hostel, super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final DatabaseService dbService = DatabaseService();
  late var students = refreshStudents();

  refreshStudents() {
    if (widget.hostel != null) {
      return dbService.getStudentsByHostel(widget.hostel!);
    } else {
      return dbService.getStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMainPage = widget.hostel == null;

    return Scaffold(
      body: Center(
        child: RefreshIndicator.adaptive(
          onRefresh: () async => setState(() {
            students = refreshStudents();
          }),
          child: Column(
            children: [
              Image.asset('assets/images/students_banner.webp',
                  height: 200, fit: BoxFit.cover),
              const SizedBox(height: 48),
              Expanded(
                child: isMainPage ? _buildDefaultView() : _buildHostelView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isMainPage
          ? FloatingActionButton(
              onPressed: () => showEditStudentDialog(context),
              child: const Icon(Icons.format_list_bulleted_add),
            )
          : null,
    );
  }

  // ignore: unused_element
  Widget _buildDefaultView() {
    return FutureBuilder<List<Student>>(
      future: students,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return CardLoading(
                  height: 120, child: linearStudentCard(Student.empty()));
            },
          );
        } else if (snapshot.hasError) {
          debugPrintStack();
          return Text('Error: ${snapshot.error}');
        } else {
          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              return linearStudentCard(students[index]);
            },
          );
        }
      },
    );
  }

  // ignore: unused_element
  Widget _buildHostelView() {
    return FutureBuilder<List<Student>>(
      future: students,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 160),
            itemCount: 30,
            itemBuilder: (context, index) {
              return CardLoading(
                  height: 120, child: verticalStudentCard(Student.empty()));
            },
          );
        } else if (snapshot.hasError) {
          debugPrintStack();
          return Text('Error: ${snapshot.error}');
        } else {
          final students = snapshot.data!;

          // Group students by room number
          final studentsMap = <int, List<Student>>{};
          for (var student in students) {
            if (studentsMap.containsKey(student.room)) {
              studentsMap[student.room]!.add(student);
            } else {
              studentsMap[student.room] = [student];
            }
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 160),
            itemCount: students.length,
            itemBuilder: (context, index) {
              return verticalStudentCard(students[index]);
            },
          );
        }
      },
    );
  }

  Widget linearStudentCard(Student s) {
    final clr = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ContactCardDialog(student: s);
            },
          );
        },
        child: Card(
          surfaceTintColor: s.toColor(),
          shadowColor: s.toColor(),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RandomPersonIcon(size: 72, color: Colors.black,)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name,
                        style: TextStyle(fontSize: 18, color: clr.primary)),
                    Text(s.id, style: TextStyle(color: clr.secondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 8),
                    child: Row(children: [
                      Icon(Icons.bed_outlined, size: 24),
                      Text(s.room.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  IconButton(
                    onPressed: () => showEditStudentDialog(context, s),
                    icon: Icon(Icons.edit_outlined, size: 32),
                    tooltip: 'Edit',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalStudentCard(Student s) {
    final clr = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ContactCardDialog(student: s);
            },
          );
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;

            return Card(
              surfaceTintColor: s.toColor(),
              shadowColor: s.toColor(),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(children: [
                RandomPersonIcon(size: h, color: clr.surface),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: clr.surface, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            color: clr.onPrimary),
                        child: Row(children: [
                          Icon(Icons.bed_outlined, size: w * 0.11),
                          Text(s.room.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.09)),
                        ]),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showEditStudentDialog(context, s),
                      icon: Icon(Icons.edit_outlined, size: h * 0.15),
                      tooltip: 'Edit',
                    ),
                  ],
                ),
                Positioned(
                  top: h * 0.45,
                  child: Container(
                    height: h * 0.5,
                    width: w * 0.95,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withAlpha(1),
                            Colors.black.withAlpha(120)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(s.name,
                            style: TextStyle(
                                fontSize: w * 0.1, color: clr.primary)),
                        Text(s.id,
                            style: TextStyle(color: clr.primaryContainer)),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  Widget buildRoomCard(List<Student> l) {
    return Card(
      child: Container(
        color: Colors.amber[200],
        child: Row(
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Text(
                  l[0].room.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: l.length,
                  itemBuilder: (context, i) {
                    return verticalStudentCard(l[i]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
