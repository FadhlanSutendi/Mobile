import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../models/cek_item_models.dart'; // gunakan model yang benar

class CekItemController extends GetxController {
  var isLoading = false.obs;
  var unitItem = Rxn<UnitItem>();
  var errorMessage = ''.obs;

  Future<void> searchUnitItem(String codeUnit, {required String token}) async {
    isLoading.value = true;
    errorMessage.value = '';
    unitItem.value = null;
    print('searchUnitItem called with codeUnit=$codeUnit, token=$token'); // log
    try {
      final response = await AppApi.fetchUnitItem(codeUnit, token: token);
      print('searchUnitItem response: $response'); // log
      if (response != null &&
          response['status'] == 200 &&
          response['data'] != null) {
        unitItem.value = UnitItem.fromJson(response['data']);
      } else {
        errorMessage.value = 'Data tidak ditemukan';
      }
    } catch (e) {
      print('searchUnitItem error: $e'); // log
      errorMessage.value = 'Terjadi kesalahan';
    }
    isLoading.value = false;
  }
}
