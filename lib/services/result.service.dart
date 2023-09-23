import 'package:campus_connect_plus/view/login.view.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect_plus/models/exams/result.model.dart';
import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResultsAPIService {
  Future<dynamic> getResults(String symbolNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.resultsEndpoint}$symbolNumber/");
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Result results = resultFromJson(response.body);
        return results;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }
}
