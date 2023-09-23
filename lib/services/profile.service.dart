import 'dart:developer';
import 'dart:io';
import 'package:campus_connect_plus/models/success.model.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect_plus/models/profile.model.dart';
import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileAPIService {
  Future<dynamic> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        InstructorProfile profile = instructorProfileFromJson(response.body);
        return profile;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> updateProfilePicture(File imageFile) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var request = http.MultipartRequest("PUT", url);
      String filename = imageFile.path.split("/").last;
      request.files.add(await http.MultipartFile.fromPath('profile_picture', imageFile.path, filename: filename),);
      request.headers["Authorization"] = "Bearer $accessToken";
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if(response.statusCode == 200){
        Success model = successFromJson(responseBody);
        return model;
      }else{
        Errors error = errorsFromJson(responseBody);
        return error;
      }
    }catch(e){
      rethrow;
    }
  }
}
