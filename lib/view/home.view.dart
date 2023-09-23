import 'dart:async';

import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/models/profile.model.dart';
import 'package:campus_connect_plus/services/profile.service.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/exams/exam.view.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:campus_connect_plus/view/profile.view.dart';
import 'package:campus_connect_plus/view/exams/resultSearch.view.dart';
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
              showConfirmationDialog(
                "Are you sure you want to logout?",
                () {
                  pref.remove("accessToken");
                  Get.offAll(() => const LoginView());
                  generateSuccessSnackbar(
                      "Success", "Logged out successfully!");
                },
              );
            },
          )
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
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
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
                          getExpanded(
                            "profile",
                            "Profile",
                            "View Profile",
                            () => Get.to(() => const ProfileView()),
                            Colors.indigo,
                            Icons.person,
                          ),
                          getExpanded(
                            "courses",
                            "Courses",
                            "View Assigned Courses",
                            () => null,
                            Colors.orange,
                            Icons.book,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          getExpanded(
                            "attendance",
                            "Attendance",
                            "Take Attendance",
                            () => null,
                            Colors.green,
                            Icons.assignment,
                          ),
                          getExpanded(
                            "exam",
                            "Exam",
                            "Schedule Exams",
                            () => Get.to(() => const ExamView()),
                            Colors.red,
                            Icons.event,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          getExpanded(
                            "results",
                            "Results",
                            "View Student Results",
                            () => Get.to(() => const ResultSearchView()),
                            Colors.purple,
                            Icons.poll,
                          ),
                        ],
                      ),
                    ),
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
              ),
            ),
            TextButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    return exitApp;
  }

  Widget getExpanded(
    String tag,
    String title,
    String subtitle,
    Function()? onPressed,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
