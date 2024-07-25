import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:campus_connect_plus/view/attendance/student_attendance_detail.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_connect_plus/models/courses/courseStudents.model.dart';
import 'package:campus_connect_plus/services/instructorCourse.service.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';
import 'package:intl/intl.dart';

class MarkAttendanceView extends StatefulWidget {
  final int courseSessionId;

  const MarkAttendanceView({Key? key, required this.courseSessionId})
      : super(key: key);

  @override
  State<MarkAttendanceView> createState() => _MarkAttendanceViewState();
}

class _MarkAttendanceViewState extends State<MarkAttendanceView> {
  CourseStudents? courseStudents;
  List<dynamic>? attendances;
  bool isRefreshing = false;
  late Errors errors;

  @override
  void initState() {
    super.initState();
    fetchCourseStudents();
  }

  Future<void> fetchCourseStudents() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      dynamic data =
          await ICourseAPIService().getCourseStudents(widget.courseSessionId);
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
      fetchAttendances();
    } catch (error) {
      generateErrorSnackbar("Error", "An unspecified error occurred!");
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  Future<void> fetchAttendances() async {
    try {
      dynamic data = await ICourseAPIService()
          .getCourseAttendances(widget.courseSessionId);
      if (data is List) {
        setState(() {
          attendances = data;
        });
      } else if (data is Errors) {
        setState(() {
          errors = data;
        });
      }
    } catch (error) {
      generateErrorSnackbar("Error", "An unspecified error occurred!");
    }
  }

  Future<void> markAttendance(int studentId, bool isPresent) async {
    String endpoint = isPresent
        ? "api/attendance/mark-present/"
        : "api/attendance/mark-absent/";
    try {
      var response = await ICourseAPIService()
          .markAttendance(widget.courseSessionId, studentId, endpoint);
      if (response.statusCode == 200) {
        generateSuccessSnackbar("Success", "Attendance marked successfully!");
        fetchAttendances(); // Refresh attendances after marking attendance
      } else {
        generateErrorSnackbar("Error", "Failed to mark attendance!");
      }
    } catch (error) {
      generateErrorSnackbar("Error", "An unspecified error occurred!");
    }
  }

  DateTime convertToNepalTime(DateTime utcDateTime) {
    Duration offset = const Duration(hours: 5, minutes: 45);
    return utcDateTime.add(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mark Attendance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  DateTime now = DateTime.now();
                  DateTime today = DateTime(now.year, now.month, now.day);

                  var todaysAttendance = attendances?.where((attendance) {
                    DateTime attendanceDate =
                        convertToNepalTime(DateTime.parse(attendance['date']));
                    return attendance['student'] == currentItem!.student &&
                        DateTime(attendanceDate.year, attendanceDate.month,
                                attendanceDate.day) ==
                            today;
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 6.0,
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: GlobalColors.mainColor.withOpacity(0.8),
                              backgroundImage: CachedNetworkImageProvider(
                                  "${ApiConstants.baseUrl}${currentItem!.profile_picture}"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                currentItem.studentName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () {
                                    markAttendance(currentItem.student, true);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                  onPressed: () {
                                    markAttendance(currentItem.student, false);
                                  },
                                ),
                              ],
                            ),
                          ),
                          todaysAttendance != null &&
                                  todaysAttendance.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: todaysAttendance.length,
                                  itemBuilder: (context, attIndex) {
                                    var attendanceItem =
                                        todaysAttendance[attIndex];
                                    return ListTile(
                                      leading: const Icon(Icons.calendar_today),
                                      title: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            convertToNepalTime(DateTime.parse(
                                                attendanceItem['date']))),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Text(
                                        'Status: ${titleCase(attendanceItem['status'])}',
                                        style: TextStyle(
                                          color: attendanceItem['status'] ==
                                                  'present'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      'No attendance records found for today'),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GlobalColors.mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                Get.to(() => StudentAttendanceDetailView(
                                    studentId: currentItem.student,
                                    courseSessionId: widget.courseSessionId));
                              },
                              child: const Text(
                                "View All Attendances",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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
