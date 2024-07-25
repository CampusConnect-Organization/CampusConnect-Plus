import 'package:campus_connect_plus/models/auth/authentication.model.dart';
import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/services/login.service.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/base_url.view.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/widgets/button.widget.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';
import 'package:campus_connect_plus/widgets/textform.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final Authentication model;
  late final Errors errors;
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Image(
                          image: AssetImage("images/logo-dark.png"),
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "CampusConnect+",
                          style: TextStyle(
                              color: GlobalColors.mainColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Login to your account",
                          style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormGlobal(
                        controller: usernameController,
                        obscure: false,
                        labelText: "Username",
                        text: "Username",
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormGlobal(
                        controller: passwordController,
                        obscure: true,
                        labelText: "Password",
                        text: "Password",
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonGlobal(
                        text: "Login",
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            dynamic result = await LoginAPIService().login(
                                usernameController.text,
                                passwordController.text);
                            if (result is Authentication) {
                              model = result;
                              if (model.success) {
                                SharedPreferences pref = await prefs;
                                await pref.setString(
                                    "accessToken", model.data.accessToken);
                                await pref.setString(
                                    "refreshToken", model.data.refreshToken);
                                Get.off(() => const HomeView());
                                generateSuccessSnackbar(
                                    "Success", model.message);
                              }
                            } else if (result is Errors) {
                              errors = result;
                              generateErrorSnackbar("Error", errors.message);
                              passwordController.text = "";
                            } else {
                              generateErrorSnackbar(
                                  "Error", "Something went wrong!");
                            }
                          } catch (e) {
                            generateErrorSnackbar(
                                "Error", "An unspecified error occurred!");
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const SetBaseUrlView());
                        },
                        child: const Text("Set Base URL"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: ModernSpinner(
                  color: GlobalColors.mainColor,
                ),
              ),
            )
        ],
      ),
    );
  }
}
