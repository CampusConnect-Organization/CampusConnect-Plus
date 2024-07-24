// To parse this JSON data, do
//
//     final courseStudents = courseStudentsFromJson(jsonString);

import 'dart:convert';

CourseStudents courseStudentsFromJson(String str) =>
    CourseStudents.fromJson(json.decode(str));

String courseStudentsToJson(CourseStudents data) => json.encode(data.toJson());

class CourseStudents {
  bool success;
  List<CourseStudentsData> data;
  String message;

  CourseStudents({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourseStudents.fromJson(Map<String, dynamic> json) => CourseStudents(
        success: json["success"],
        data: List<CourseStudentsData>.from(
            json["data"].map((x) => CourseStudentsData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class CourseStudentsData {
  int id;
  int student;
  String studentName;
  String courseSessionName;
  int courseSessionId;
  // ignore: non_constant_identifier_names
  String profile_picture;

  CourseStudentsData({
    required this.id,
    required this.student,
    required this.studentName,
    required this.courseSessionName,
    required this.courseSessionId,
    // ignore: non_constant_identifier_names
    required this.profile_picture,
  });

  factory CourseStudentsData.fromJson(Map<String, dynamic> json) =>
      CourseStudentsData(
        id: json["id"],
        student: json["student"],
        studentName: json["student_name"],
        courseSessionName: json["course_session_name"],
        courseSessionId: json["course_session_id"],
        profile_picture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student": student,
        "student_name": studentName,
        "course_session_name": courseSessionName,
        "course_session_id": courseSessionId,
        "profile_picture": profile_picture,
      };
}
