import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../models/pengembalian_models.dart';

class PengembalianController extends GetxController {
  var isLoading = false.obs;

  Future<UnitLoan?> fetchLoanDetail(String loanId, String token) async {
    isLoading.value = true;
    final result = await AppApi.returnUnitLoan(loanId, '', token: token);
    isLoading.value = false;
    if (result != null && result['data'] != null) {
      return UnitLoan.fromJson(result['data']);
    }
    return null;
  }

  Future<Map<String, dynamic>?> returnLoan(String loanId, String returnedAt, String token) async {
    isLoading.value = true;
    final data = {
      'returned_at': returnedAt,
    };
    final result = await AppApi.returnUnitLoan(loanId, returnedAt, token: token);
    isLoading.value = false;
    return result;
  }
}