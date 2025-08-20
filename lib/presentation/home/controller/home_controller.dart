import 'package:get/get.dart';
import 'package:project_prapw/core/api/app_api.dart';

class HomeController extends GetxController {
  var cardData = {}.obs;
  var isLoadingCard = false.obs;
  var activityList = [].obs;
  var isLoadingActivity = false.obs;
  var loanReportData = <String, int>{}.obs;
  var isLoadingLoanReport = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCardData();
    fetchLatestActivity();
    fetchLoanReport(from: '2024', to: '2025');
  }

  Future<void> fetchCardData() async {
    isLoadingCard.value = true;
    final result = await AppApi.fetchDashboardCard();
    print('fetchCardData result: $result');
    cardData.value = result?['data'] ?? {};
    isLoadingCard.value = false;
  }

  Future<void> fetchLatestActivity() async {
    isLoadingActivity.value = true;
    final result = await AppApi.fetchDashboardLatestActivity();
    print('fetchLatestActivity result: $result');
    activityList.value = result?['data'] ?? [];
    isLoadingActivity.value = false;
  }

  Future<void> fetchLoanReport({required String from, required String to}) async {
    isLoadingLoanReport.value = true;
    final result = await AppApi.fetchLoanReport(from: from, to: to);
    print('fetchLoanReport result: $result');
    loanReportData.value = Map<String, int>.from(result?['data'] ?? {});
    isLoadingLoanReport.value = false;
  }
}

