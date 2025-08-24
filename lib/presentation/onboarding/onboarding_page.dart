import 'package:flutter/material.dart';
import 'package:project_prapw/routes/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas biru dengan sudut bawah melengkung
            ClipPath(
              clipper: _BottomCurveClipper(),
              child: Container(
                height: 300,
                color: Color(0xFF0A3D91), // warna biru
                child: Center(
                  child: SizedBox(), // kosong, hanya background
                ),
              ),
            ),
            // Logo di tengah lingkaran putih
            Container(
              transform: Matrix4.translationValues(0.0, -70.0, 0.0),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 65, // 🔥 perbesar radius (misalnya 80)
                backgroundColor: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/logo1.png',
                    fit: BoxFit.contain,
                    width: 200, // opsional, bisa disesuaikan
                    height: 200,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Judul
            Text(
              'WiKVENTORY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Subjudul
            Text(
              'Smart Inventory for Smart School',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            // Tombol Get Started
            Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: SizedBox(
                width: 220,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A3D91),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper untuk sudut bawah melengkung
class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
