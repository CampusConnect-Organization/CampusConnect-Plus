import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/models/exams/exam.model.dart';
import 'package:campus_connect_plus/models/instructorCourses.model.dart';
import 'package:campus_connect_plus/services/exam.service.dart'; // Import your exam service file here
import 'package:campus_connect_plus/services/instructorCourse.service.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/exams/exam.view.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExamView extends StatefulWidget {
  const CreateExamView({Key? key}) : super(key: key);

  @override
  State<CreateExamView> createState() => _CreateExamViewState();
}

class _CreateExamViewState extends State<CreateExamView> {
  Errors? errors;
  InstructorCourses? courses;
  bool isRefreshing = false;
  Exam? exam;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Exam types
  String _selectedExamType = 'Internal';
  int _selectedCourseSessionId = 0;

  // Total Marks and Pass Marks
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _passMarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> fetchCourses() async {
    setState(() {
      isRefreshing = true;
    });
    dynamic data = await ICourseAPIService().getCourses();
    if (data is InstructorCourses) {
      setState(() {
        courses = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      errors = data;
      isRefreshing = false;
      generateErrorSnackbar("Error", errors!.message);
    }
  }

  Future<void> refreshData() async {
    await fetchCourses();
  }

  Future<void> createExam() async {
    if (_selectedCourseSessionId == 0) {
      generateErrorSnackbar("Error", "Please select a course");
      return;
    }

    final String? date = _selectedDate != null
        ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
        : null;
    final String? time = _selectedTime != null
        ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
        : null;

    if (_selectedExamType.isEmpty || date == null || time == null) {
      generateErrorSnackbar("Error", "Please fill in all fields");
      return;
    }

    // Convert the selected exam type to lowercase
    final String examTypeLowerCase = _selectedExamType.toLowerCase();

    // Parse totalMarks and passMarks from text controllers
    final int totalMarks = int.tryParse(_totalMarksController.text) ?? 0;
    final int passMarks = int.tryParse(_passMarksController.text) ?? 0;

    setState(() {
      isRefreshing = true;
    });
    dynamic result = await ExamAPIService().createExam(
      examTypeLowerCase, // Pass the lowercase exam type to the backend
      date,
      time,
      _selectedCourseSessionId,
      totalMarks,
      passMarks,
    );

    if (result is Exam) {
      setState(() {
        exam = result;
        isRefreshing = false;
      });
      generateSuccessSnackbar("Success", "Exam created successfully!");

      Get.off(() => const ExamView());
    } else if (result is Errors) {
      setState(() {
        errors = result;
        isRefreshing = false;
      });

      generateErrorSnackbar("Error", errors!.message);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
  final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
  final minute = tod.minute.toString().padLeft(2, '0');
  final period = tod.period == DayPeriod.am ? 'AM' : 'PM';

  return '$hour:$minute $period';
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exam', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor, // Set AppBar color
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => {Get.off(() => const ExamView())},
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: isRefreshing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Exam Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedExamType,
                        onChanged: (value) {
                          setState(() {
                            _selectedExamType = value!;
                          });
                        },
                        items: [
                          'Internal',
                          'Final',
                          'Practical',
                        ].map((examType) {
                          return DropdownMenuItem<String>(
                            value: examType,
                            child: Text(
                              examType,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Select Exam Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Course Dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedCourseSessionId,
                        onChanged: (value) {
                          setState(() {
                            _selectedCourseSessionId = value!;
                          });
                        },
                        items: [
                          // Placeholder item with value 0
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Text(
                              'Select a Course',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          // Actual course items
                          ...(courses?.data.map((course) {
                                return DropdownMenuItem<int>(
                                  value:
                                      course.id, // Ensure each value is unique
                                  child: Text(
                                    course.course,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }) ??
                              []),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Select Course',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'Please select a course';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Date Picker
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _selectedDate != null
                                ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                : 'Select Date',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Time Picker
                      InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _selectedTime != null
                                  ? formatTimeOfDay(_selectedTime!)
                                  : 'Select Time',
                            )),
                      ),
                      const SizedBox(height: 16.0),

                      // Total Marks Field
                      TextFormField(
                        controller: _totalMarksController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Marks',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Pass Marks Field
                      TextFormField(
                        controller: _passMarksController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pass Marks',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Create Exam Button
                      ElevatedButton(
                        onPressed: createExam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              GlobalColors.mainColor, // Set button color
                        ),
                        child: const Text(
                          'Create Exam',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
