import 'package:flutter/material.dart';
import 'package:hostel_management_application/database.dart';

import '../Models/student_model.dart';

Future<void> showEditStudentDialog(BuildContext context, [Student? student]) async {
    final dbService = DatabaseService();
    Student s = student ?? Student.empty();
    final bool isNew = s.id.isEmpty;

    final id = isNew
        ? await (() async {
            int newId = 1;
            for (Student student in await dbService.getStudents()) {
              if (student.id.startsWith('22')) {
                int currentId = int.parse(student.id.substring(5, 7));
                debugPrint(currentId.toString());
                if (currentId == newId) newId++;
              }
            }
            return '22xxx${(newId).toString().padLeft(2, '0')}';
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
              text: isNew ? 'Add Student ' : 'Edit Student ',
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator()),
                      );
                    },
                  );

                  final newStudent = Student(
                    name: nameCtrl.text,
                    contact: int.parse(contactCtrl.text),
                    email: emailCtrl.text.toLowerCase(),
                    hostel:
                        await dbService.getDocRef('Hostels/${hostelCtrl.text}'),
                    room: int.parse(roomCtrl.text),
                    id: id,
                  );

                  if (isNew) {
                    await dbService.addStudent(newStudent);
                  } else {
                    await dbService.updateStudent(newStudent);
                  }

                  Navigator.of(context).pop(); // pop the progress dialog
                  Navigator.of(context).pop(); // pop the edit dialog
                }
              },
            ),
          ],
        );
      },
    );
  }