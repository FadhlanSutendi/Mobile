import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login/controller/login_controller.dart';
import '../../core/api/app_api.dart';
import 'controller/navbar_bottom_controller.dart';

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
                _navItem(context, Icons.logout, 'log Out', 3, token: token, navbarController: navbarController),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (onItemSelected != null) onItemSelected!(4);
                // Navigate to scan barcode page
                Get.toNamed('/scan');
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
                  child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index, {String? token, NavbarBottomController? navbarController}) {
    Color iconColor = Colors.grey[500]!;
    if (label == 'log Out') iconColor = Colors.black;
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        if (onItemSelected != null) onItemSelected!(index);
        switch (label) {
          case 'Home':
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 'Reports':
            Navigator.pushReplacementNamed(context, '/reports');
            break;
          case 'History':
            Navigator.pushReplacementNamed(context, '/history', arguments: token);
            break;
          case 'log Out':
            final result = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Konfirmasi'),
                content: Text('Apakah Anda yakin ingin keluar?'),
                actions: [
                  TextButton(
                    child: Text('Tidak'),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: Text('Ya'),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
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
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
          Icon(icon, color: isSelected ? Color(0xFF1565C0) : iconColor, size: 28),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Color(0xFF1565C0) : iconColor)),
        ],
      ),
    );
  }
}
