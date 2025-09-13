import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/controller/login_controller.dart';
import '../../core/api/app_api.dart';
import 'controller/navbar_bottom_controller.dart';
import '../../routes/app_routes.dart';

class NavbarBottom extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemSelected;

  NavbarBottom({this.selectedIndex = 0, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final token = Get.find<LoginController>().token.value;
    final navbarController = Get.find<NavbarBottomController>();

    return Obx(() {
      int currentIndex = navbarController.selectedIndex.value;

      return SizedBox(
        height: 100, // lebih tinggi supaya tombol QR tidak terpotong
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(context, 'assets/home.png', 'Home', 0),
                    _navItem(context, 'assets/report.png', 'Reports', 1),
                    const SizedBox(width: 64), // space untuk QR Code
                    _navItem(context, 'assets/invent.png', 'History', 2),
                    _navItem(context, 'assets/logout.png', 'log Out', 3,
                        token: token, navbarController: navbarController),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40, // posisinya naik ke atas navbar
              child: GestureDetector(
                onTap: () {
                  if (onItemSelected != null) onItemSelected!(4);
                  Get.toNamed(AppRoutes.scanBarcode);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1565C0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/qr.png',
                      width: 32,
                      height: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _navItem(
    BuildContext context,
    String imagePath,
    String label,
    int index, {
    String? token,
    NavbarBottomController? navbarController,
  }) {
    final navController = Get.find<NavbarBottomController>();
    bool isSelected = navController.selectedIndex.value == index;

    Color iconColor = Colors.grey[500]!;
    if (label == 'log Out') iconColor = Colors.black;

    return GestureDetector(
      onTap: () async {
        if (onItemSelected != null) onItemSelected!(index);
        navController.setIndex(index); // ✅ update index aktif

        switch (label) {
          case 'Home':
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            break;

          case 'Reports':
            Navigator.pushReplacementNamed(context, AppRoutes.report);
            break;

          case 'History':
            final selected = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) {
                String choice = 'history'; // default
                return StatefulBuilder(
                  builder: (context, setState) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Image.asset(
                          'assets/select_page.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Select Page',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose which kind of page\nyou want to show',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: choice == 'borrow'
                                      ? const Color(0xFF1565C0)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: RadioListTile<String>(
                                value: 'borrow',
                                groupValue: choice,
                                title: Text(
                                  'Borrowed Page',
                                  style: GoogleFonts.poppins(),
                                ),
                                activeColor: const Color(0xFF1565C0),
                                onChanged: (val) {
                                  setState(() {
                                    choice = val!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: choice == 'history'
                                      ? const Color(0xFF1565C0)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: RadioListTile<String>(
                                value: 'history',
                                groupValue: choice,
                                title: Text(
                                  'History Page',
                                  style: GoogleFonts.poppins(),
                                ),
                                activeColor: const Color(0xFF1565C0),
                                onChanged: (val) {
                                  setState(() {
                                    choice = val!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Continue',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(choice),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            if (selected == 'borrow') {
              Get.toNamed(AppRoutes.historyPeminjaman, arguments: token);
            } else if (selected == 'history') {
              Get.toNamed(AppRoutes.history, arguments: token);
            }
            break;

          case 'log Out':
            final result = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Are you sure want to\nlog out?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                    right: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.login);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Confirm",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
            if (result == true && navbarController != null) {
              await navbarController.logout(token ?? '');
              if (navbarController.logoutResponse.value != null &&
                  navbarController.logoutResponse.value!.status == 200) {
                final loginController = Get.find<LoginController>();
                loginController.token.value = '';
                loginController.usernameController.clear();
                loginController.passwordController.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout gagal', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 28,
            height: 28,
            color: isSelected ? const Color(0xFF1565C0) : iconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isSelected ? const Color(0xFF1565C0) : iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
