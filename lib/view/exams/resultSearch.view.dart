import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/exams/results.view.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/widgets/button.widget.dart';
import 'package:campus_connect_plus/widgets/snackbar.widget.dart';
import 'package:campus_connect_plus/widgets/textform.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ResultSearchView extends StatefulWidget {
  const ResultSearchView({super.key});

  @override
  State<ResultSearchView> createState() => _ResultSearchViewState();
}

class _ResultSearchViewState extends State<ResultSearchView> {
  final TextEditingController symbolNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Get.off(() => const HomeView()),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormGlobal(
              controller: symbolNumberController,
              labelText: "Symbol Number",
              text: "Enter your symbol number",
              obscure: false,
              textInputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonGlobal(
              text: "Search",
              onTap: () {
                final symbolNumber = symbolNumberController.text;
                if (symbolNumber.isNotEmpty) {
                  Get.to(() => ResultView(symbolNumber: symbolNumber));
                } else {
                  generateErrorSnackbar("Error", "Symbol number is required!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
