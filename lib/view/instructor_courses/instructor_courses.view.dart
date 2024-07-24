import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/view/instructor_courses/course_students.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_connect_plus/models/courses/instructorCourses.model.dart';
import 'package:campus_connect_plus/services/instructorCourse.service.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/widgets/grayText.widget.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';

class InstructorCoursesView extends StatefulWidget {
  const InstructorCoursesView({Key? key}) : super(key: key);

  @override
  State<InstructorCoursesView> createState() => _InstructorCoursesViewState();
}

class _InstructorCoursesViewState extends State<InstructorCoursesView> {
  InstructorCourses? instructorCourses;
  bool isRefreshing = false;
  late Errors errors;

  @override
  void initState() {
    super.initState();
    fetchInstructorCourses();
  }

  Future<dynamic> fetchInstructorCourses() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      dynamic data = await ICourseAPIService().getCourses();
      if (data is InstructorCourses) {
        setState(() {
          instructorCourses = data;
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
          "Assigned Courses",
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
            Get.off(() => const HomeView());
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchInstructorCourses,
        child: instructorCourses != null
            ? ListView.builder(
                itemCount: instructorCourses?.data.length,
                itemBuilder: (context, index) {
                  List<InstructorCourseData>? enrolls = instructorCourses?.data;
                  var currentItem = enrolls?[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CourseStudentsView(
                          courseSessionId: currentItem.id));
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentItem!.course,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: GlobalColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                              text: "Duration: ${currentItem.start} - ${currentItem.end}",
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                              text: "Instructor: ${currentItem.instructor}",
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                              text: "Semester: ${currentItem.semester}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : isRefreshing
                ? Center(child: ModernSpinner(color: GlobalColors.mainColor))
                : const Center(
                    child: Text("You don't have any assigned courses!"),
                  ),
      ),
    );
  }
}
