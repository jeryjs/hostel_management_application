import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Models/hostel_model.dart';
import 'Models/student_model.dart';

/// A class that provides database operations for hostels and students.
class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late final hostels = db.collection('Hostels');
  late final students = db.collection('Students');

  /// Retrieves a list of all hostels from the database.
  ///
  /// Returns a list of [Hostel] objects.
  Future<List<Hostel>> getHostels() async {
    QuerySnapshot querySnapshot = await hostels.get();
    debugPrint('Fetched Hostels: ${querySnapshot.docs.length} [isFromCache: ${querySnapshot.metadata.isFromCache}]');
    List<Hostel> hostelList = querySnapshot.docs.map((e) => Hostel.fromJson(e.data())).toList();
    return hostelList;
  }

  /// Adds a new hostel to the database.
  ///
  /// [hostel] - The [Hostel] object to be added.
  Future<void> addHostel(Hostel hostel) {
    return hostels
      .doc(hostel.name).set(hostel.toJson())
      .then((_) => debugPrint('Hostel Added!'))
      .catchError((e) => throw Exception('Failed to add hostel: $e'));
  }

  /// Updates an existing hostel in the database.
  ///
  /// [h] - The updated [Hostel] object.
  Future<void> updateHostel(Hostel h) {
    return hostels
      .doc(h.name).update(h.toJson())
      .then((_) => debugPrint('Hostel Updated!'))
      .catchError((e) => throw Exception('Failed to update hostel: $e'));
  }

  /// Retrieves a list of all students from the database.
  ///
  /// Returns a list of [Student] objects.
  Future<List<Student>> getStudents() async {
    QuerySnapshot querySnapshot = await students.get();
    debugPrint('Fetched Students: ${querySnapshot.docs.length} [isFromCache: ${querySnapshot.metadata.isFromCache}]');
    List<Student> studentList = querySnapshot.docs.map((e) => Student.fromJson(e.data())).toList();
    return studentList;
  }

  /// Retrieves a list of all students from specific [Hostel].
  ///
  /// Returns a list of [Student] objects.
  Future<List<Student>> getStudentsByHostel(Hostel hostel) async {
    QuerySnapshot querySnapshot = await students.where('hostel', isEqualTo: hostels.doc(hostel.name)).get();
    debugPrint('Fetched Students: ${querySnapshot.docs.length}');
    List<Student> studentList = querySnapshot.docs.map((e) => Student.fromJson(e.data())).toList();
    return studentList;
  }

  /// Adds a new student to the database.
  ///
  /// [s] - The [Student] object to be added.
  Future<void> addStudent(Student s) {
    return students
      .doc(s.id).set(s.toJson())
      .then((_) => debugPrint('Student Added!'))
      .catchError((e) => throw Exception('Failed to add student: $e'));
  }

  /// Updates an existing student in the database.
  ///
  /// [s] - The updated [Student] object.
  Future<void> updateStudent(Student s) {
    return students
      .doc(s.id).update(s.toJson())
      .then((_) => debugPrint('Student Updated!'))
      .catchError((e) => throw Exception('Failed to update student: $e'));
  }

  /// Retrieves a [DocumentReference] for the given path.
  ///
  /// [path] - The path of the document.
  ///
  /// Returns a [DocumentReference] object.
  Future<DocumentReference> getDocRef(String path) async {
    return db.doc(path);
  }
}