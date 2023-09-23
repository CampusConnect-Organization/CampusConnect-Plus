// To parse this JSON data, do
//
//     final instructorCourses = instructorCoursesFromJson(jsonString);

import 'dart:convert';

InstructorCourses instructorCoursesFromJson(String str) => InstructorCourses.fromJson(json.decode(str));

String instructorCoursesToJson(InstructorCourses data) => json.encode(data.toJson());

class InstructorCourses {
    bool success;
    List<InstructorCourseData> data;
    String message;

    InstructorCourses({
        required this.success,
        required this.data,
        required this.message,
    });

    factory InstructorCourses.fromJson(Map<String, dynamic> json) => InstructorCourses(
        success: json["success"],
        data: List<InstructorCourseData>.from(json["data"].map((x) => InstructorCourseData.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class InstructorCourseData {
    int id;
    String course;
    String instructor;
    String start;
    String end;

    InstructorCourseData({
        required this.id,
        required this.course,
        required this.instructor,
        required this.start,
        required this.end,
    });

    factory InstructorCourseData.fromJson(Map<String, dynamic> json) => InstructorCourseData(
        id: json["id"],
        course: json["course"],
        instructor: json["instructor"],
        start: json["start"],
        end: json["end"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "instructor": instructor,
        "start": start,
        "end": end,
    };
}
