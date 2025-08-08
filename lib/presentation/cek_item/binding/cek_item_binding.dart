import 'package:get/get.dart';
import '../controller/cek_item_controller.dart';

class CekItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekItemController>(() => CekItemController());
  }
}
