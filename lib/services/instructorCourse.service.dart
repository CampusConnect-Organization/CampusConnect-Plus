import "package:campus_connect_plus/models/error.model.dart";
import "package:campus_connect_plus/models/instructorCourses.model.dart";
import "package:campus_connect_plus/utils/constants.dart";
import "package:campus_connect_plus/view/login.view.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class ICourseAPIService{
  Future<dynamic> getCourses() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url  = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.instructorCoursesEndpoint}");
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
    }catch(error){
      rethrow;
    }
  }
}