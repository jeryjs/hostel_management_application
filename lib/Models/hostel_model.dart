class Hostel {
    String name;
    String imageUrl;
    int studentCount;
    String warden;

    Hostel({
      required this.name,
      required this.imageUrl,
      required this.studentCount,
      required this.warden
    });

    factory Hostel.fromJson(json) {
      return Hostel(
        name: json['Name'],
        imageUrl: json['ImageUrl'],
        studentCount: json['StudentCount'],
        warden: json['Warden'],
      );
    }

    Map<String, dynamic> toJson() {
        return {
          'Name': name,
          'ImageUrl': imageUrl,
          'StudentCount': studentCount,
          'Warden': warden,
        };
    }
}
