import 'package:get/get.dart';
import '../controller/navbar_bottom_controller.dart';

class NavbarBottomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarBottomController>(() => NavbarBottomController());
  }
}
