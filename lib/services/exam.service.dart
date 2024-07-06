
import 'dart:convert';
import 'dart:developer';
import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/models/exams/exam.model.dart';
import 'package:campus_connect_plus/models/exams/getExam.model.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExamAPIService {
  Future<dynamic> createExam(String examType, String date, String time, int courseSessionId, int totalMarks, int passMarks) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.createExamEndpoint);
    Object? accessToken = prefs.get("accessToken");
    if (accessToken == null) {
      Get.off(() => const LoginView());
    }

    // Create a Map with the expected format
    var requestData = {
      "exam_type": examType,
      "date": date,
      "time": time,
      "course_session": courseSessionId,
      "total_marks": totalMarks,
      "pass_marks": passMarks
    };

    // Convert the Map to JSON
    var requestBody = jsonEncode(requestData);

    // Send the JSON data in the request body
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json", // Specify JSON content type
      },
      body: requestBody,
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      Exam exam = examFromJson(responseBody);
      return exam;
    } else {
      Errors errors = errorsFromJson(responseBody);
      return errors;
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<dynamic> getExams() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.examsEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});


      if (response.statusCode == 200) {
        Exams exams = examsFromJson(response.body);
        return exams;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }

}
