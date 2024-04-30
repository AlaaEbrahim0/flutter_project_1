import 'package:world_time_app/pages/enums/gender.dart';

class Student {
  int id;
  String name;
  String gender;
  String email;
  int level;
  String password;
  String image;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.gender = 'male', // Optional field, default value is an empty string
    this.level = 1, // Optional field, default value is 0
    this.image =
        "", // Additional field for student image, default value is an empty string
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'] ?? 'male',
      level: json['level'] ?? 1,
      image: json['image'] ?? '',
    );
  }
}
