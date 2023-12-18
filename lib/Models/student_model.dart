/// Represents a student in the hostel management application.
class Student {
  String name;
  List<int> contact;
  List<String> email;
  dynamic hostel;
  String id;

  /// Constructs a new instance of the [Student] class.
  ///
  /// The [name], [contact], [email], [hostel], and [id] parameters are required.
  Student({
    required this.name,
    required this.contact,
    required this.email,
    required this.hostel,
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
      id: json['id'],
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
      'id': id,
    };
  }
}
