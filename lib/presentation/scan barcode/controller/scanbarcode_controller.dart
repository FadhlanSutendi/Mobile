import '../../../core/api/app_api.dart';
import '../../cek_item/models/cek_item_models.dart';

class ScanBarcodeController {
  Future<UnitItem?> fetchUnitItem(
    String barcode, {
    required String token,
  }) async {
    final response = await AppApi.fetchUnitLoanCheck(barcode, token: token);
    print('API response: $response');

    if (response != null &&
        response['status'] == 200 &&
        response['data'] != null) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        return UnitItem.fromJson(data);
      }
    }

    return null;
  }
}
