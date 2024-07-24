import "dart:convert";

import "package:campus_connect_plus/models/courses/courseStudents.model.dart";
import "package:campus_connect_plus/models/error.model.dart";
import "package:campus_connect_plus/models/courses/instructorCourses.model.dart";
import "package:campus_connect_plus/utils/constants.dart";
import "package:campus_connect_plus/view/login.view.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class ICourseAPIService {
  Future<dynamic> getCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.instructorCoursesEndpoint}");
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        InstructorCourses courses = instructorCoursesFromJson(response.body);
        return courses;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getCourseStudents(int courseSessionId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.instructorCourseStudentsEndpoint}$courseSessionId");
      Object? accessToken = prefs.get("accessToken");

      if (accessToken == null) {
        Get.off(() => const LoginView());
      }

      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        CourseStudents students = courseStudentsFromJson(response.body);
        return students;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<http.Response> markAttendance(
      int courseSessionId, int studentId, String endpoint) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Object? accessToken = prefs.get("accessToken");

      if (accessToken == null) {
        Get.off(() => const LoginView());
      }

      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
            {"course_session": courseSessionId, "student": studentId}),
      );

      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getCourseAttendances(int courseSessionId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}api/attendance/attendances/$courseSessionId'),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        return Errors.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      rethrow;
    }
  }
}
