import '../../../core/api/app_api.dart';
import '../../cek_item/models/cek_item_models.dart';

class ScanBarcodeController {
  Future<UnitItem?> fetchUnitItem(
    String unitCode, {
    required String token,
  }) async {
    final sanitizedUnitCode = unitCode.trim();
    // Validate unitCode before API call
    if (sanitizedUnitCode.isEmpty) {
      print('unit_code kosong, tidak bisa request ke API');
      return null;
    }

    final response = await AppApi.fetchUnitLoanCheck(sanitizedUnitCode, token: token);
    print('API response: $response');

    if (response != null &&
        response['status'] == 200 &&
        response['data'] != null) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        // Sesuaikan parsing UnitItem dengan struktur baru
        final unitItem = UnitItem.fromJson(data);
        return unitItem;
      }
    }

    return null;
  }
}
