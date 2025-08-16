// If using GetX, you can do:
import 'package:get/get.dart';
import '../controller/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    final token = Get.arguments as String? ?? '';
    Get.lazyPut<HistoryController>(() => HistoryController(token: token));
  }
}