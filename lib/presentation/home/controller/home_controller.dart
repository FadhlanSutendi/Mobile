import 'package:get/get.dart';
import 'package:project_prapw/core/api/app_api.dart';
import '../../login/controller/login_controller.dart';

class HomeController extends GetxController {
  var cardData = {}.obs;
  var isLoadingCard = false.obs;
  var activityList = [].obs;
  var isLoadingActivity = false.obs;
  var loanReportData = <String, int>{}.obs;
  var isLoadingLoanReport = false.obs;
  var userName = ''.obs; // Tambahkan ini

  @override
  void onInit() {
    super.onInit();
    // Ambil token dari LoginController
    final loginController = Get.find<LoginController>();
    final token = loginController.token.value;
    if (token.isEmpty) {
      print('Token kosong, tidak bisa fetch data!');
      return;
    }
    fetchCardData(token: token);
    fetchLatestActivity(token: token);
    fetchLoanReport(from: '2024', to: '2025', token: token);
    fetchUserName(token: token); // Tambahkan ini
  }

  Future<void> fetchCardData({required String token}) async {
    isLoadingCard.value = true;
    final result = await AppApi.fetchDashboardCard(token: token);
    print('fetchCardData result: $result');
    if (result == null || result['data'] == null) {
      print('Card data kosong!');
      cardData.value = {};
    } else {
      cardData.value = result['data'];
    }
    isLoadingCard.value = false;
  }

  Future<void> fetchLatestActivity({required String token}) async {
    isLoadingActivity.value = true;
    final result = await AppApi.fetchDashboardLatestActivity(token: token);
    print('fetchLatestActivity result: $result');
    if (result == null || result['data'] == null) {
      print('Activity data kosong!');
      activityList.value = [];
    } else {
      activityList.value = result['data'];
    }
    isLoadingActivity.value = false;
  }

  Future<void> fetchLoanReport({required String from, required String to, required String token}) async {
    isLoadingLoanReport.value = true;
    final result = await AppApi.fetchLoanReport(from: from, to: to, token: token);
    print('fetchLoanReport result: $result');
    if (result == null || result['data'] == null) {
      print('Loan report data kosong!');
      loanReportData.value = {};
    } else {
      loanReportData.value = Map<String, int>.from(result['data']);
    }
    isLoadingLoanReport.value = false;
  }

  Future<void> fetchUserName({required String token}) async {
    final result = await AppApi.fetchUser(token: token);
    print('fetchUserName response: $result');
    userName.value = result?['data']?['name'] ?? '';
  }
}