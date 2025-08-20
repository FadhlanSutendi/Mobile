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
    // You must provide the token from your auth/session management
    final token = ''; // TODO: Replace with actual token
    fetchCardData(token: token);
    fetchLatestActivity(token: token);
    fetchLoanReport(from: '2024', to: '2025', token: token);
  }

  Future<void> fetchCardData({required String token}) async {
    isLoadingCard.value = true;
    final result = await AppApi.fetchDashboardCard(token: token);
    print('fetchCardData result: $result');
    cardData.value = result?['data'] ?? {};
    isLoadingCard.value = false;
  }

  Future<void> fetchLatestActivity({required String token}) async {
    isLoadingActivity.value = true;
    final result = await AppApi.fetchDashboardLatestActivity(token: token);
    print('fetchLatestActivity result: $result');
    activityList.value = result?['data'] ?? [];
    isLoadingActivity.value = false;
  }

  Future<void> fetchLoanReport({required String from, required String to, required String token}) async {
    isLoadingLoanReport.value = true;
    final result = await AppApi.fetchLoanReport(from: from, to: to, token: token);
    print('fetchLoanReport result: $result');
    loanReportData.value = Map<String, int>.from(result?['data'] ?? {});
    isLoadingLoanReport.value = false;
  }
}

