import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../../scan barcode/models/scanbarcode_models.dart';

class CekItemController extends GetxController {
  var isLoading = false.obs;
  var unitItem = Rxn<UnitItem>();
  var errorMessage = ''.obs;

  Future<void> searchUnitItem(String codeUnit) async {
    isLoading.value = true;
    errorMessage.value = '';
    unitItem.value = null;
    try {
      final response = await AppApi.fetchUnitItemByCode(codeUnit);
      if (response != null &&
          response['status'] == 200 &&
          response['data'] != null) {
        unitItem.value = UnitItem.fromJson(response['data']);
      } else {
        errorMessage.value = 'Data tidak ditemukan';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';
    }
    isLoading.value = false;
  }
}
