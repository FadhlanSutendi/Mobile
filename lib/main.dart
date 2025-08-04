import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_prapw/presentation/onboarding/onboarding_page.dart';
import 'presentation/splash/screen_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/login/controller/login_controller.dart';
import 'presentation/home/home_page.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(LoginController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Splash Screen App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.onboarding: (context) => OnboardingPage(),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.home: (context) => HomePage(),
      },
    );
  }
}
