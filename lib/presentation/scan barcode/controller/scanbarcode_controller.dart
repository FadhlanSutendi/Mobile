import '../../../core/api/app_api.dart';
import '../../cek_item/models/cek_item_models.dart';

class ScanBarcodeController {
  Future<UnitItem?> fetchUnitItem(
    String barcode, {
    required String token,
  }) async {
    // Validate barcode before API call
    if (barcode.isEmpty || barcode.trim().isEmpty) {
      print('Barcode/unit_code kosong, tidak bisa request ke API');
      return null;
    }

    final response = await AppApi.fetchUnitLoanCheck(barcode, token: token);
    print('API response: $response');

    if (response != null &&
        response['status'] == 200 &&
        response['data'] != null) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final unitItem = UnitItem.fromJson(data);
        print('UnitItem.loan: ${unitItem.loan}'); // debug loan
        return unitItem;
      }
    }

    return null;
  }
}
