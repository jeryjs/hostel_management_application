import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Models/hostel_model.dart';
import 'Models/student_model.dart';

class DatabaseService {
  final FirebaseFirestore fsInstance = FirebaseFirestore.instance;

  Future<List<Hostel>> getHostels() async {
    QuerySnapshot querySnapshot = await fsInstance.collection('Hostels').get();
    debugPrint('Fetched Hostels: ${querySnapshot.docs.length}');
    List<Hostel> hostelList = querySnapshot.docs.map((e) => Hostel.fromJson(e.data())).toList();
    return hostelList;
  }

  Future<void> addHostel(Hostel hostel) async {
    try {
      await fsInstance.collection('Hostels').add(hostel.toJson());
    } catch (e) {
      throw Exception('Failed to add hostel: $e');
    }
  }

  Future<void> removeHostel(String hostelId) async {
    try {
      await fsInstance.collection('Hostels').doc(hostelId).delete();
    } catch (e) {
      throw Exception('Failed to remove hostel: $e');
    }
  }

  Future<List<Student>> getStudents() async {
    QuerySnapshot querySnapshot = await fsInstance.collection('Students').get();
    debugPrint('Fetched Students: ${querySnapshot.docs.length}');
    List<Student> studentList = querySnapshot.docs.map((e) => Student.fromJson(e.data())).toList();
    return studentList;
  }
}