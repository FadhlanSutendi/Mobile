import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../../peminjaman/models/peminjaman_models.dart';

class PengembalianController extends GetxController {
  var isLoading = false.obs;

  Future<Loan?> fetchLoanDetail(String loanId, String token) async {
    isLoading.value = true;
    final result = await AppApi.getUnitLoanDetail(loanId, token: token);
    isLoading.value = false;
    if (result != null && result['data'] != null) {
      return Loan.fromJson(result['data']);
    }
    return null;
  }

  Future<Map<String, dynamic>?> returnLoan(String loanId, String returnedAt, String token) async {
    isLoading.value = true;
    final data = {
      'returned_at': returnedAt,
    };
    final result = await AppApi.putUnitLoan(loanId, data, token: token);
    isLoading.value = false;
    return result;
  }
}
