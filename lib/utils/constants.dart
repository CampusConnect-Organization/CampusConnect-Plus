import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  static String baseUrl = 'http://192.168.1.230:8000/';
  static String loginEndpoint = 'api/auth/instructor-login/';
  static String registerEndpoint = 'api/auth/register/';
  static String profileEndpoint = 'api/instructor/me/';
  static String resultsEndpoint = 'api/results/result/';
  static String instructorCoursesEndpoint = 'api/courses/instructor-courses/';
  static String createExamEndpoint = 'api/grades/exam/';
  static String examsEndpoint = "api/grades/instructor-exams/";
  static String instructorCourseStudentsEndpoint = 'api/courses/instructor-courses/enrolls/';

  static Future<void> setBaseUrl(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('baseUrl', url);
    baseUrl = url;
  }

  static Future<void> loadBaseUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('baseUrl') ?? baseUrl;
  }
}

String titleCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.toLowerCase().split(' ');

  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }

  return words.join(' ');
}

Expanded getExpanded(
    String image, String mainText, String subText, Function()? onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                "images/$image.png",
                height: 70.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              mainText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              subText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
