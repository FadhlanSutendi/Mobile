import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api/app_api.dart';


class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isPasswordHidden = true.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await AppApi.login(
        usernameController.text,
        passwordController.text,
      );
      print('LOGIN RESPONSE:');
      print(data);
      if (data['status'] == 200 && data['token'] != null) {
        // Success: Navigate to home page
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
        Get.snackbar(
          'Login Gagal',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Login error';
      print('LOGIN ERROR:');
      print(e);
      Get.snackbar(
        'Login Gagal',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
