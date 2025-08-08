import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_prapw/presentation/onboarding/onboarding_page.dart';
import 'presentation/splash/screen_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/login/controller/login_controller.dart';
import 'presentation/home/home_page.dart';
import 'presentation/scan barcode/scanbarcode_page.dart';
import 'presentation/cek_item/cek_item_page.dart';
import 'routes/app_routes.dart';
import 'theme/error_page.dart';

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
        AppRoutes.error: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          int errorCode = 500;
          if (args is int) {
            errorCode = args;
          } else if (args != null) {
            errorCode = int.tryParse(args.toString()) ?? 500;
          }
          return ErrorPage(errorCode: errorCode);
        },
        AppRoutes.scanBarcode: (context) => ScanBarcodePage(),
        AppRoutes.cekItem: (context) => Scaffold(
              body: Center(child: Text('No item data provided')),
            ),
      },
    );
  }
}
