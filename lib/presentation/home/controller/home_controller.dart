import 'package:get/get.dart';
import 'package:project_prapw/core/api/app_api.dart';

class HomeController extends GetxController {
  var cardData = {}.obs;
  var isLoadingCard = false.obs;
  var activityList = [].obs;
  var isLoadingActivity = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCardData();
    fetchLatestActivity();
  }

  Future<void> fetchCardData() async {
    isLoadingCard.value = true;
    final result = await AppApi.fetchDashboardCard();
    cardData.value = result?['data'] ?? {};
    isLoadingCard.value = false;
  }

  Future<void> fetchLatestActivity() async {
    isLoadingActivity.value = true;
    final result = await AppApi.fetchDashboardLatestActivity();
    activityList.value = result?['data'] ?? [];
    isLoadingActivity.value = false;
  }
}

