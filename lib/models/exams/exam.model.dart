// To parse this JSON data, do
//
//     final exam = examFromJson(jsonString);

import 'dart:convert';

Exam examFromJson(String str) => Exam.fromJson(json.decode(str));

String examToJson(Exam data) => json.encode(data.toJson());

class Exam {
    bool success;
    ExamData data;
    String message;

    Exam({
        required this.success,
        required this.data,
        required this.message,
    });

    factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        success: json["success"],
        data: ExamData.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
    };
}

class ExamData {
    String examType;
    String date;
    String time;
    int courseSession;

    ExamData({
        required this.examType,
        required this.date,
        required this.time,
        required this.courseSession,
    });

    factory ExamData.fromJson(Map<String, dynamic> json) => ExamData(
        examType: json["exam_type"],
        date: json["date"],
        time: json["time"],
        courseSession: json["course_session"],
    );

    Map<String, dynamic> toJson() => {
        "exam_type": examType,
        "date": date,
        "time": time,
        "course_session": courseSession,
    };
}
