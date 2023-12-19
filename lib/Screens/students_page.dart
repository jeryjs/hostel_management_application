// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

import '../Components/circle_reveal_clipper.dart';
import '../Models/student_model.dart';
import '../database.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final DatabaseService dbService = DatabaseService();
  late var students = dbService.getStudents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator.adaptive(
          onRefresh: () async => setState(() {
            students = dbService.getStudents();
          }),
          child: Column(
            children: [
              Image.asset('assets/images/students_banner.webp',
                  height: 200, fit: BoxFit.cover),
              const SizedBox(height: 48),
              Expanded(
                child: FutureBuilder<List<Student>>(
                  future: students,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return CardLoading(height: 120, child: studentCard(Student.empty()));
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
                          return studentCard(students[index]);
                        },
                      );
                    }
                  },
                ),
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

  Widget studentCard(Student s) {
    final clr = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () =>
            Navigator.push(context, transitionPageRoute(const StudentsPage())),
        child: Card(
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
              IconButton(
                onPressed: () => showEditDialog(s),
                icon: Icon(Icons.edit_outlined, size: 32),
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
            int maxId = 0;
            for (Student student in await students) {
              if (student.id.startsWith('23')) {
                int currentId = int.parse(student.id.substring(2));
                if (currentId > maxId) maxId = currentId;
              }
            }
            return '23xxx${(maxId + 1).toString().padLeft(3, '0')}';
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
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (v) => v!.isEmpty ? 'Enter a name' : null,
                  ),
                  TextFormField(
                    controller: contactCtrl,
                    decoration: InputDecoration(labelText: 'Contact'),
                    validator: (v) => v!.isEmpty ? 'Enter a contact' : null,
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
                ],
              ),
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
