import 'dart:async';

import 'package:campus_connect_plus/models/profile.model.dart';
import 'package:campus_connect_plus/services/profile.service.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> checkAccessToken() async {
    var data = await ProfileAPIService().getProfile();
    if (data is InstructorProfile) {
      Get.off(() => const HomeView());
    } else {
      Get.off(() => const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () async {
      await checkAccessToken();
    });
    return Center(
      child: Scaffold(
        backgroundColor: GlobalColors.mainColor,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("images/logo.png"),
                height: 150,
                width: 150,
              ),
              Text(
                "CampusConnect+",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
