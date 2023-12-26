// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

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
    final bool isFromHostel = widget.hostel == null;

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
                child: isFromHostel ? _buildDefaultView() : _buildHostelView(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditDialog(),
        child: const Icon(Icons.format_list_bulleted_add),
      ),
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
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 5,
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
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
        onTap: () => debugPrint(s.name),
        // Navigator.push(context, transitionPageRoute(const StudentsPage())),
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
                child: Icon(
                    // Show a random icon for student image
                    [
                      Icons.person,
                      Icons.person_2,
                      Icons.person_3,
                      Icons.person_4
                    ][Random().nextInt(4)],
                    size: 72),
              ),
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
                    onPressed: () => showEditDialog(s),
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
        onTap: () => debugPrint(s.name),
        child: Card(
          surfaceTintColor: s.toColor(),
          shadowColor: s.toColor(),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                child: Center(
                    child: Icon(
                        // Show a random icon for student image
                        [
                          Icons.person,
                          Icons.person_2,
                          Icons.person_3,
                          Icons.person_4
                        ][Random().nextInt(4)],
                        size: 150)),
              ),
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
                        Icon(Icons.bed_outlined, size: 18),
                        Text(s.room.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showEditDialog(s),
                    icon: Icon(Icons.edit_outlined, size: 28),
                    tooltip: 'Edit',
                  ),
                ],
              ),
              Positioned(
                top: 125,
                child: Column(
                  children: [
                    Text(s.name,
                        style: TextStyle(fontSize: 16, color: clr.primary)),
                    Text(s.id, style: TextStyle(color: clr.secondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showEditDialog([Student? student]) async {
    Student s = student ?? Student.empty();

    final id = s.id.isEmpty
        ? await (() async {
            int maxId = 1;
            for (Student student in await students) {
              if (student.id.startsWith('23')) {
                int currentId = int.tryParse(student.id.substring(2)) ?? 0;
                if (currentId > maxId) maxId = currentId;
              }
            }
            return '23xxx${(maxId + 1).toString().padLeft(2, '0')}';
          })()
        : s.id;

    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: s.name);
    final contactCtrl = TextEditingController(text: s.contact.toString());
    final emailCtrl = TextEditingController(text: s.email);
    final hostelCtrl = TextEditingController(text: s.hostel.id);
    final roomCtrl = TextEditingController(text: s.room.toString());

    // ignore: use_build_context_synchronously
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text.rich(
            TextSpan(
              text: s.id.isEmpty ? 'Add Student ' : 'Edit Student ',
              children: [
                TextSpan(
                    text: id,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (v) => v!.isEmpty ? 'Enter a name' : null,
                ),
                TextFormField(
                  controller: contactCtrl,
                  decoration: InputDecoration(labelText: 'Contact'),
                  validator: (v) =>
                      v!.isEmpty || v == '0' ? 'Enter a contact' : null,
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.isEmpty ? 'Enter an email' : null,
                ),
                DropdownButtonFormField(
                  value: hostelCtrl.text,
                  items: ['Himalaya', 'Karakoram', 'Purvanchal']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => hostelCtrl.text = v!,
                  decoration: InputDecoration(labelText: 'Hostel'),
                  validator: (v) =>
                      v!.isEmpty ? 'Please select a hostel' : null,
                ),
                TextFormField(
                  controller: roomCtrl,
                  decoration: InputDecoration(labelText: 'Room'),
                  validator: (v) =>
                      v!.isEmpty || v == '0' ? 'Enter Room Number' : null,
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newStudent = Student(
                    name: nameCtrl.text,
                    contact: int.parse(contactCtrl.text),
                    email: emailCtrl.text,
                    hostel:
                        await dbService.getDocRef('Hostels/${hostelCtrl.text}'),
                    room: int.parse(roomCtrl.text),
                    id: id,
                  );
                  dbService.updateStudent(newStudent);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
