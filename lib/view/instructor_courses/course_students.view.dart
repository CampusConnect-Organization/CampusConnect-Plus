import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_connect_plus/models/courses/courseStudents.model.dart';
import 'package:campus_connect_plus/services/instructorCourse.service.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';

class CourseStudentsView extends StatefulWidget {
  final int courseSessionId;

  const CourseStudentsView({Key? key, required this.courseSessionId}) : super(key: key);

  @override
  State<CourseStudentsView> createState() => _CourseStudentsViewState();
}

class _CourseStudentsViewState extends State<CourseStudentsView> {
  CourseStudents? courseStudents;
  bool isRefreshing = false;
  late Errors errors;

  @override
  void initState() {
    super.initState();
    fetchCourseStudents();
  }

  Future<dynamic> fetchCourseStudents() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      dynamic data = await ICourseAPIService().getCourseStudents(widget.courseSessionId);
      if (data is CourseStudents) {
        setState(() {
          courseStudents = data;
          isRefreshing = false;
        });
      } else if (data is Errors) {
        setState(() {
          errors = data;
          isRefreshing = false;
        });
      }
    } catch (error) {
      generateErrorSnackbar("Error", "An unspecified error occurred!");
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Course Students",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchCourseStudents,
        child: courseStudents != null
            ? ListView.builder(
                itemCount: courseStudents?.data.length,
                itemBuilder: (context, index) {
                  List<CourseStudentsData>? students = courseStudents?.data;
                  var currentItem = students?[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(ApiConstants.baseUrl +
                                    currentItem!.profile_picture),
                      ),
                      title: Text(
                        currentItem.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              )
            : isRefreshing
                ? Center(child: ModernSpinner(color: GlobalColors.mainColor))
                : const Center(
                    child: Text("No students found for this course!"),
                  ),
      ),
    );
  }
}
