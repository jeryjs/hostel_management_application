import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore fsInstance = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getHostels() async {
    QuerySnapshot querySnapshot = await fsInstance.collection('Hostels').get();
    debugPrint('Fetched Hostels: ${querySnapshot.docs.length}');
    return querySnapshot.docs;
  }
}