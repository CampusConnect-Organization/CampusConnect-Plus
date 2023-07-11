import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/widgets/button.widget.dart';
import 'package:campus_connect_plus/widgets/textform.widget.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage("images/logo.png"),
                      height: 100,
                      width: 100,
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
                  ButtonGlobal(text: "Login", onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            InkWell(
              onTap: () {},
              child: Text(
                "Signup",
                style: TextStyle(color: GlobalColors.mainColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
