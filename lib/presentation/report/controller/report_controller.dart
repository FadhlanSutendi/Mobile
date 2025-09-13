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
  var selectedYear = RxnInt();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  /// 🔹 Inisialisasi data: pastikan token siap sebelum fetch data
  void initData() async {
    await fetchToken(); // tunggu token selesai
    await Future.wait([
      fetchPieData(),
      fetchLegendData(),
      fetchLoanReport(),
    ]);
  }

  /// 🔹 Refresh semua data
  Future<void> refreshData() async {
    // pastikan token sudah ada
    if (token.value.isEmpty) {
      await fetchToken();
    }

    await Future.wait([
      fetchPieData(),
      fetchLegendData(),
      fetchLoanReport(),
    ]);
  }

  /// 🔹 Ambil token dari LoginController
  Future<void> fetchToken() async {
    final loginController = Get.find<LoginController>();
    token.value = loginController.token.value;
    print('ReportController token: ${token.value}');
  }

  /// 🔹 Fetch PieChart
  Future<void> fetchPieData() async {
    isLoadingPie.value = true;

    // jangan panggil jika token kosong
    if (token.value.isEmpty) {
      print("fetchPieData: token kosong, batalkan request");
      isLoadingPie.value = false;
      return;
    }

    final res = await AppApi.fetchPieChart(token: token.value);
    print('PieChart API response: $res');

    if (res != null && res['data'] != null) {
      pieData.value = List<ItemPercentage>.from(
        res['data'].map((e) => ItemPercentage.fromJson(e)),
      );
    } else {
      pieData.clear();
    }

    isLoadingPie.value = false;
  }

  /// 🔹 Fetch Legend
  Future<void> fetchLegendData() async {
    isLoadingLegend.value = true;

    if (token.value.isEmpty) {
      print("fetchLegendData: token kosong, batalkan request");
      isLoadingLegend.value = false;
      return;
    }

    final res = await AppApi.fetchLegend(token: token.value);
    print('Legend API response: $res');

    if (res != null && res['data'] != null) {
      legendData.value = List<ItemCount>.from(
        res['data'].map((e) => ItemCount.fromJson(e)),
      );
    } else {
      legendData.clear();
    }

    isLoadingLegend.value = false;
  }

  /// 🔹 Fetch Loan Report
  Future<void> fetchLoanReport() async {
    isLoadingLoanReport.value = true;

    if (token.value.isEmpty) {
      print("fetchLoanReport: token kosong, batalkan request");
      isLoadingLoanReport.value = false;
      return;
    }

    final now = DateTime.now();
    final from = '${now.year}-01-01';
    final to = '${now.year}-12-31';

    final res = await AppApi.fetchLoanReport(
      from: from,
      to: to,
      token: token.value,
    );

    print('LoanReport API response: $res');

    if (res != null && res['data'] != null) {
      loanReportData.value = Map<String, int>.from(res['data']);
    } else {
      loanReportData.clear();
    }

    isLoadingLoanReport.value = false;
  }

  /// 🔹 Fetch Loan Report per Tahun
  Future<void> fetchLoanReportByYear(int year) async {
    isLoadingLoanReport.value = true;

    if (token.value.isEmpty) {
      print("fetchLoanReportByYear: token kosong, batalkan request");
      isLoadingLoanReport.value = false;
      return;
    }

    final from = '$year-01-01';
    final to = '$year-12-31';

    final res = await AppApi.fetchLoanReport(
      from: from,
      to: to,
      token: token.value,
    );

    print('LoanReport API response for year $year: $res');

    if (res != null && res['data'] != null) {
      loanReportData.value = Map<String, int>.from(res['data']);
    } else {
      loanReportData.clear();
    }

    selectedYear.value = year;
    isLoadingLoanReport.value = false;
  }
}
