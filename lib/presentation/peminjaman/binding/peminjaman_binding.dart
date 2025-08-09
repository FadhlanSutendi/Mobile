import 'package:get/get.dart';
import '../controller/peminjaman_controller.dart';

class PeminjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeminjamanController>(() => PeminjamanController());
  }
}
