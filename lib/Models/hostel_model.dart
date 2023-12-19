import 'package:flutter/material.dart';

/// Represents a hostel in the hostel management application.
class Hostel {
    String name;
    String imageUrl;
    int studentCount;
    String warden;
    
    /// Constructs a [Hostel] object with the given parameters.
    Hostel({
      required this.name,
      required this.imageUrl,
      required this.studentCount,
      required this.warden
    });

    /// Constructs a [Hostel] object from a JSON object.
    factory Hostel.fromJson(json) {
      return Hostel(
        name: json['Name'],
        imageUrl: json['ImageUrl'],
        studentCount: json['StudentCount'],
        warden: json['Warden'],
      );
    }

    /// Constructs an empty [Hostel] object.
    factory Hostel.empty() {
      return Hostel(
        name: '',
        imageUrl: '',
        studentCount: 0,
        warden: '',
      );
    }

    /// Converts the [Hostel] object to a JSON object.
    Map<String, dynamic> toJson() {
        return {
          'Name': name,
          'ImageUrl': imageUrl,
          'StudentCount': studentCount,
          'Warden': warden,
        };
    }

    /// Return a color representation of the [Hostel] object.
    Color toColor() {
      switch (name) {
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
}
