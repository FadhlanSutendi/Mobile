import 'package:get/get.dart';
import '../controller/scanbarcode_controller.dart';

class ScanBarcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanBarcodeController>(() => ScanBarcodeController());
  }
}
