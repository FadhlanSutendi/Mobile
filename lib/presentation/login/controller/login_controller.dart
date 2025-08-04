import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import '../models/login_models.dart';

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
      final loginResponse = LoginResponse.fromJson(data);
      if (loginResponse.token != null) {
        // Success: Navigate to home page
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = loginResponse.message ?? 'Login failed';
        Get.snackbar(
          'Login Gagal',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Login error';
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
