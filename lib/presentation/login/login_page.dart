import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginController>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  SizedBox(height: 40),
                  Image.asset('assets/logo1.png',
                      height: 80), // Replace with your logo asset
                  SizedBox(height: 40),
                  Text('Welcome Back!',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Please enter your details',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Username',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: c.usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 8),
                  Obx(() => TextField(
                        controller: c.passwordController,
                        obscureText: c.isPasswordHidden.value,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              c.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: c.togglePasswordVisibility,
                          ),
                        ),
                      )),
                  SizedBox(height: 24),
                  Obx(() => c.errorMessage.value.isNotEmpty
                      ? Text(c.errorMessage.value,
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink()),
                  SizedBox(height: 8),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF003087),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: c.isLoading.value
                              ? null
                              : () async {
                                  await c.login();
                                  if (c.token.value != null &&
                                      c.token.value!.isNotEmpty) {
                                    // Ganti dengan navigasi ke halaman berikutnya, misal HomePage
                                    // dan kirim tokennya
                                    // Contoh:
                                    // Get.offAll(() => HomePage(token: c.token.value!));
                                  }
                                },
                          child: c.isLoading.value
                              ? CircularProgressIndicator(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255))
                              : const Text('LOGIN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      )),
                  SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text('© PPLG XII-V 2025. All Rights Reserved. ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
