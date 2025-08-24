import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../models/report_models.dart';
import '../../login/controller/login_controller.dart';

class ReportController extends GetxController {
  var token = ''.obs;

  // PieChart data
  var isLoadingPie = true.obs;
  var pieData = <ItemPercentage>[].obs;

  // Legend data
  var isLoadingLegend = true.obs;
  var legendData = <ItemCount>[].obs;

  // Activity Statistics (BarChart)
  var isLoadingLoanReport = true.obs;
  var loanReportData = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchToken();
    fetchPieData();
    fetchLegendData();
    fetchLoanReport();
  }

  void fetchToken() async {
    // Ambil token dari LoginController
    final loginController = Get.find<LoginController>();
    token.value = loginController.token.value;
    print('ReportController token: ${token.value}');
  }

  void fetchPieData() async {
    isLoadingPie.value = true;
    final res = await AppApi.fetchPieChart(token: token.value);
    print('PieChart API response: $res');
    if (res != null && res['data'] != null) {
      pieData.value = List<ItemPercentage>.from(
        res['data'].map((e) => ItemPercentage.fromJson(e)),
      );
    }
    isLoadingPie.value = false;
  }

  void fetchLegendData() async {
    isLoadingLegend.value = true;
    final res = await AppApi.fetchLegend(token: token.value);
    print('Legend API response: $res');
    if (res != null && res['data'] != null) {
      legendData.value = List<ItemCount>.from(
        res['data'].map((e) => ItemCount.fromJson(e)),
      );
    }
    isLoadingLegend.value = false;
  }

  void fetchLoanReport() async {
    isLoadingLoanReport.value = true;
    // Contoh: ambil data dari Januari sampai Desember tahun ini
    final now = DateTime.now();
    final from = '${now.year}-01-01';
    final to = '${now.year}-12-31';
    final res = await AppApi.fetchLoanReport(from: from, to: to, token: token.value);
    print('LoanReport API response: $res');
    if (res != null && res['data'] != null) {
      // data: { "Jan": 10, "Feb": 5, ... }
      loanReportData.value = Map<String, int>.from(res['data']);
    }
    isLoadingLoanReport.value = false;
  }
}