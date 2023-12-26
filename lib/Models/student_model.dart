import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'hostel_model.dart';

/// Represents a student in the hostel management application.
class Student {
  String name;
  int contact;
  String email;
  DocumentReference hostel;
  int room;
  String id;

  late int year = _parseYear();
  late int floor = _parseFloor();

  /// Constructs a new instance of the [Student] class.
  ///
  /// The [name], [contact], [email], [hostel], and [id] parameters are required.
  Student({
    required this.name,
    required this.contact,
    required this.email,
    required this.hostel,
    required this.room,
    required this.id,
  });

  /// Constructs a new instance of the [Student] class from a JSON object.
  ///
  /// The [json] parameter is a JSON object representing a student.
  factory Student.fromJson(json) {
    return Student(
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      hostel: json['hostel'],
      room: json['room'],
      id: json['id'],
    );
  }

  factory Student.empty() {
    return Student(
      name: '',
      contact: 0,
      email: '',
      hostel: FirebaseFirestore.instance.collection('Hostels').doc('Karakoram'),
      room: 0,
      id: '',
    );
  }

  /// Converts the [Student] object to a JSON object.
  ///
  /// Returns a JSON object representing the [Student] object.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
      'hostel': hostel,
      'room': room,
      'id': id,
    };
  }

  /// Gets the [Hostel] object from the [hostel] reference.
  /// 
  /// Returns a [Hostel] object.
  Future<Hostel> getHostel() async {
    final doc = await hostel.get();
    return Hostel.fromJson(doc.data()!);
  }

  /// Return a color representation of the [Hostel] object.
    Color toColor() {
      switch (hostel.id) {
        case 'Himalaya':
          return Colors.blue;
        case 'Karakoram':
          return Colors.green;
        case 'Purvanchal':
          return Colors.red;
        default:
          return Colors.black;
      }
    }

  /// parse the year of joining from the [id] of the student
  int _parseYear() {
    return 2000 + int.parse(id.substring(0,2));
  }

  /// parse the hostel floor from the [room] number of the student
  int _parseFloor() {
    return int.parse(room.toString().substring(0,1));
  }
}
