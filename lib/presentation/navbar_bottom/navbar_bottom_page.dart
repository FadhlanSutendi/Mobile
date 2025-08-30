import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login/controller/login_controller.dart';
import '../../core/api/app_api.dart';
import 'controller/navbar_bottom_controller.dart';
import '../../routes/app_routes.dart'; // sudah ada

class NavbarBottom extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemSelected;

  NavbarBottom({this.selectedIndex = 0, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final token = Get.find<LoginController>().token.value;
    final navbarController = Get.find<NavbarBottomController>();
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, Icons.home, 'Home', 0),
                _navItem(context, Icons.bar_chart, 'Reports', 1),
                SizedBox(width: 64),
                _navItem(context, Icons.history, 'History', 2),
                _navItem(context, Icons.logout, 'log Out', 3,
                    token: token, navbarController: navbarController),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (onItemSelected != null) onItemSelected!(4);
                // Navigasi ke halaman scan barcode
                Get.toNamed(AppRoutes.scanBarcode);
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Color(0xFF1565C0),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(Icons.qr_code_scanner,
                      color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index,
      {String? token, NavbarBottomController? navbarController}) {
    Color iconColor = Colors.grey[500]!;
    if (label == 'log Out') iconColor = Colors.black;
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        if (onItemSelected != null) onItemSelected!(index);
        switch (label) {
          case 'Home':
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            break;
          case 'Reports':
            Navigator.pushReplacementNamed(context, AppRoutes.report);
            break;
          case 'History':
            // Tampilkan popup pilihan history
            final selected = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent, // biar bisa kasih rounded di dalam
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
                        /// Indicator bar atas
                        Container(
                          width: 48,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        /// Icon
                        Image.asset(
                          'assets/select_page.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),

                        /// Title
                        const Text(
                          'Select Page',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose which kind of page\nyou want to show',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 28),

                        /// Radio pilihan
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
                                title: const Text('Borrowed Page'),
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
                                title: const Text('History Page'),
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

                        /// Tombol Continue
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF0D47A1), // biru gelap
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Continue',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                    borderRadius: BorderRadius.circular(10), // border bulet
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bagian atas abu-abu
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // abu-abu background
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Are you sure want to\nlog out?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      // Bagian tombol
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
                                child: const Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
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
                                // aksi confirm logout
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
                                child: const Center(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
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
                // Bersihkan data login agar tidak auto save
                final loginController = Get.find<LoginController>();
                loginController.token.value = '';
                loginController.usernameController.clear();
                loginController.passwordController.clear();
                // ...jika ada data lain yang perlu dibersihkan, tambahkan di sini...
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout gagal')),
                );
              }
            }
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isSelected ? Color(0xFF1565C0) : iconColor, size: 28),
          SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Color(0xFF1565C0) : iconColor)),
        ],
      ),
    );
  }
}
