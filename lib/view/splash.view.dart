import 'dart:async';

import 'package:campus_connect_plus/utils/global.colors.dart';
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
  Widget build(BuildContext context) {
    Timer(
        const Duration(
          seconds: 2,
        ), () {
      Get.off(() => const LoginView());
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
