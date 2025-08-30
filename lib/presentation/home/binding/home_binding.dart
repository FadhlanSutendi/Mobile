import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../login/controller/login_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}