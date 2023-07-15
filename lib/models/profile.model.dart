// To parse this JSON data, do
//
//     final instructorProfile = instructorProfileFromJson(jsonString);

import 'dart:convert';

InstructorProfile instructorProfileFromJson(String str) =>
    InstructorProfile.fromJson(json.decode(str));

String instructorProfileToJson(InstructorProfile data) =>
    json.encode(data.toJson());

class InstructorProfile {
  bool success;
  InstructorData data;
  String message;

  InstructorProfile({
    required this.success,
    required this.data,
    required this.message,
  });

  factory InstructorProfile.fromJson(Map<String, dynamic> json) =>
      InstructorProfile(
        success: json["success"],
        data: InstructorData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class InstructorData {
  int id;
  String fullName;
  String profilePicture;
  String firstName;
  String lastName;
  String phoneNumber;
  String faculty;
  String address;
  String gender;
  String education;

  InstructorData({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.faculty,
    required this.address,
    required this.gender,
    required this.education,
  });

  factory InstructorData.fromJson(Map<String, dynamic> json) => InstructorData(
        id: json["id"],
        fullName: json["full_name"],
        profilePicture: json["profile_picture"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        faculty: json["faculty"],
        address: json["address"],
        gender: json["gender"],
        education: json["education"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "profile_picture": profilePicture,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "faculty": faculty,
        "address": address,
        "gender": gender,
        "education": education,
      };
}
