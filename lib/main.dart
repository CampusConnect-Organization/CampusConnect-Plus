import 'package:campus_connect_plus/utils/constants.dart';
import 'package:campus_connect_plus/view/splash.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConstants.loadBaseUrl();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      theme: ThemeData(
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            fontSize: 12.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
          titleLarge: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashView(),
    );
  }
}
