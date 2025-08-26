import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_prapw/presentation/onboarding/onboarding_page.dart';
import 'presentation/splash/screen_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/login/controller/login_controller.dart';
import 'presentation/home/home_page.dart';
import 'presentation/scan barcode/scanbarcode_page.dart';
import 'presentation/cek_item/cek_item_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/history/history_pengembalian_page.dart';
import 'presentation/history/history_peminjaman_page.dart';
import 'presentation/report/report_page.dart';
import 'presentation/report/binding/report_binding.dart';
import 'routes/app_routes.dart';
import 'theme/error_page.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null);

    // Lock orientation ke portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
        AppRoutes.history: (context) {
          final token = ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return HistoryPengembalianPage(token: token);
        },
        AppRoutes.historyPeminjaman: (context) {
          final token = ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return HistoryPeminjamanPage(token: token);
        },
        AppRoutes.report: (context) {
          ReportBinding().dependencies();
          return ReportPage();
        },
      },
    );
  }
}
