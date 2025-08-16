import '../../../core/api/app_api.dart';
import '../../cek_item/models/cek_item_models.dart' as cek_item;
import '../../pengembalian/models/pengembalian_models.dart';
import '../../pengembalian/models/unit_loan.dart' as unit_loan; // Ensure this file defines UnitLoan

class ScanBarcodeController {
  /// Returns a map: {'unitItem': UnitItem, 'loan': UnitLoan}
  Future<Map<String, dynamic>?> fetchUnitItemOrLoan(
    String unitCode, {
    required String token,
  }) async {
    final sanitizedUnitCode = unitCode.trim();
    if (sanitizedUnitCode.isEmpty) {
      print('unit_code kosong, tidak bisa request ke API');
      return null;
    }

    // Pastikan key yang dikirim ke API adalah 'code_unit'
    final response = await AppApi.fetchUnitLoanCheck(sanitizedUnitCode, token: token);
    print('API response: $response');

    if (response != null && response['status'] == 200 && response['data'] != null) {
      final data = response['data'];
      // If data contains 'unit_item', it's a loan object
      if (data is Map<String, dynamic> && data.containsKey('unit_item')) {
        final loan = unit_loan.UnitLoan.fromJson(data);
        return {'loan': loan, 'unitItem': loan.unitItem};
      }
      // If data contains 'code_unit', it's a unit item object
      if (data is Map<String, dynamic> && data.containsKey('code_unit')) {
        final unitItem = cek_item.UnitItem.fromJson(data);
        return {'unitItem': unitItem};
      }
    }

    return null;
  }
}
