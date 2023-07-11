import 'package:campus_connect_plus/view/login.view.dart';
import 'package:campus_connect_plus/widgets/button.widget.dart';
import 'package:campus_connect_plus/widgets/textform.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/global.colors.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
              padding: const EdgeInsets.only(top: 120),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Register an account",
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormGlobal(
                      labelText: "Username",
                      controller: usernameController,
                      obscure: false,
                      text: 'Username',
                      textInputType: TextInputType.text,
                    ),
                    //// Password Field
                    const SizedBox(
                      height: 20,
                    ),
                    // Email Address
                    TextFormGlobal(
                      labelText: "Email",
                      controller: emailController,
                      obscure: false,
                      text: 'Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    //// Password Field
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormGlobal(
                      labelText: "Password",
                      controller: passwordController,
                      obscure: true,
                      text: 'Password',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonGlobal(text: "Register", onTap: () async {})
                  ]),
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
            const Text("Already have an account?"),
            InkWell(
              onTap: () {
                Get.off(() => const LoginView());
              },
              child: Text(
                "Login",
                style: TextStyle(color: GlobalColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
