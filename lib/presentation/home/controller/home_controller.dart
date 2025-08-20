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
    print('Dashboard Card Response: $result'); // log response
    cardData.value = result?['data'] ?? {};
    isLoadingCard.value = false;
  }

  Future<void> fetchLatestActivity() async {
    isLoadingActivity.value = true;
    final result = await AppApi.fetchDashboardLatestActivity();
    print('Dashboard Latest Activity Response: $result'); // log response
    activityList.value = result?['data'] ?? [];
    isLoadingActivity.value = false;
  }
}