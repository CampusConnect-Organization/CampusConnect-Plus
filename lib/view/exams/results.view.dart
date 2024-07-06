import 'package:campus_connect_plus/models/error.model.dart';
import 'package:campus_connect_plus/models/exams/result.model.dart';
import 'package:campus_connect_plus/services/result.service.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultView extends StatefulWidget {
  final String symbolNumber;
  const ResultView({required this.symbolNumber, Key? key}) : super(key: key);

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  Errors? errors;
  Result? results;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await ResultsAPIService().getResults(widget.symbolNumber);

    if (data is Result) {
      setState(() {
        results = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshData() async {
    await fetchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PU Results",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.off(() => const HomeView());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: results != null
            ? RefreshIndicator(
                onRefresh: refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: results!.data.map((currentItem) {
                      // Filter out subjects with "-" grade
                      final filteredSubjects = currentItem.result.entries
                          .where((entry) => entry.value != "-")
                          .map((entry) {
                        final subject = entry.key
                            .replaceAll('_', ' ')
                            .split(' ')
                            .map((word) => capitalizeSubjectWord(word))
                            .join(' ');

                        final grade = entry.value;

                        return MapEntry(subject, grade);
                      });

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currentItem.year} ${currentItem.season}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: filteredSubjects.map((entry) {
                                  final subject = entry.key;
                                  final grade = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            subject,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 60.0, // Fixed width for grade
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: gradeColor(grade),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            grade,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            : Center(
                child: isRefreshing
                    ? ModernSpinner(
                        color: GlobalColors.mainColor,
                        size: 50,
                      )
                    : const Text("Failed to fetch exams."),
              ),
      ),
    );
  }

  Color gradeColor(String grade) {
    switch (grade) {
      case "A":
      case "A-":
        return Colors.green;
      case "B+":
      case "B":
      case "B-":
        return Colors.blue;
      case "C+":
      case "C":
      case "C-":
        return Colors.orange;
      case "D+":
      case "D":
      case "D-":
      case "F":
      case "Expelled":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String capitalizeSubjectWord(String word) {
    if (word == "iii" || word == "i" || word == "iv" || word == "sgpa") {
      return word.toUpperCase();
    }
    return word[0].toUpperCase() + word.substring(1);
  }
}
