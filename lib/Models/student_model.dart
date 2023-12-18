
class Student {
  String name;
  List<int> contact;
  List<String> email;
  dynamic hostel;
  String id;

  Student({
    required this.name,
    required this.contact,
    required this.email,
    required this.hostel,
    required this.id
  });

  factory Student.fromJson(json) {
    return Student(
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      hostel: json['hostel'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
      'hostel': hostel,
      'id': id
    };
  }
}
