import 'package:get/get.dart';
import 'package:project_prapw/core/api/app_api.dart';
import '../models/navbar_bottom_models.dart';

class NavbarBottomController extends GetxController {
  var isLoading = false.obs;
  var logoutResponse = Rxn<LogoutResponse>();

  Future<void> logout(String token) async {
    isLoading.value = true;
    final res = await AppApi.logout(token: token);
    if (res != null) {
      logoutResponse.value = LogoutResponse.fromJson(res);
    } else {
      logoutResponse.value = null;
    }
    isLoading.value = false;
  }
}
