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

    /// Converts the [Hostel] object to a JSON object.
    Map<String, dynamic> toJson() {
        return {
          'Name': name,
          'ImageUrl': imageUrl,
          'StudentCount': studentCount,
          'Warden': warden,
        };
    }
}
