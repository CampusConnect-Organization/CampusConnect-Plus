import 'dart:async';

import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/models/profile.model.dart';
import 'package:campus_connect_plus/services/profile.service.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:campus_connect_plus/view/profile.view.dart';
import 'package:campus_connect_plus/widgets/dialog.widget.dart';
import 'package:campus_connect_plus/widgets/profile.widget.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  InstructorProfile? profile;
  Errors? errors;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), fetchProfile);
  }

  Future<void> fetchProfile() async {
    dynamic data = await ProfileAPIService().getProfile();

    if (data is InstructorProfile) {
      setState(() {
        profile = data;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        generateErrorSnackbar("Error", errors!.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences pref = await prefs;
                showConfirmationDialog("Are you sure you want to logout?", () {
                  pref.remove("accessToken");
                  Get.offAll(() => const LoginView());
                  generateSuccessSnackbar(
                      "Success", "Logged out successfully!");
                });
              })
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
      ),
      body: WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: profile != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 140,
                      color: Colors.transparent,
                      child: ProfileWidget(
                        firstName: profile!.data.firstName,
                        profilePicture: profile!.data.profilePicture,
                      ),
                    ),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        getExpanded("profile", "Profile", "View Profile",
                            () => Get.to(() => const ProfileView())),
                        getExpanded("courses", "Courses",
                            "View Assigned Courses", () => null)
                      ],
                    )),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        getExpanded("attendance", "Attendance",
                            "Take Attendance", () => null),
                        getExpanded(
                            "exam", "Exam", "Schedule Exams", () => null)
                      ],
                    )),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        getExpanded("results", "Results",
                            "View Student Results", () => null),
                      ],
                    ))
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: GlobalColors.mainColor,
                ),
              ),
      ),
    );
  }

  _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("Do you want to close the app?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  "Yes",
                ),
              ),
            ],
          );
        });

    return exitApp;
  }
}
