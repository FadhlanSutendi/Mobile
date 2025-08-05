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
        // Ambil kode error, pastikan bertipe int, fallback ke 500 jika tidak ada
        int errorCode = 500;
        if (data['status'] is int) {
          errorCode = data['status'];
        } else if (data['status'] != null) {
          errorCode = int.tryParse(data['status'].toString()) ?? 500;
        }
        // Navigasi ke halaman error
        Get.toNamed('/error', arguments: errorCode);
      }
    } catch (e) {
      errorMessage.value = 'Login error';
      print('LOGIN ERROR:');
      print(e);
      // Navigasi ke halaman error dengan kode 500 jika terjadi exception
      Get.toNamed('/error', arguments: 500);
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
