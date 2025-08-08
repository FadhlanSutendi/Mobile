import '../../../core/api/app_api.dart';
import '../models/scanbarcode_models.dart';

class ScanBarcodeController {
  Future<UnitItem?> fetchUnitItem(String barcode) async {
    final response = await AppApi.fetchUnitItem(barcode);
    if (response != null &&
        response['status'] == 200 &&
        response['data'] != null &&
        response['data'].isNotEmpty) {
      return UnitItem.fromJson(response['data'][0]);
    }
    return null;
  }
}
