import 'package:flutter/material.dart';
import '../scan barcode/scanbarcode_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gambar Banner
          SizedBox(
            height: 260,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.asset(
                'assets/banner.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Header profil
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF003087)),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Iqbal Fajar Syahbana, S. T.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Kepala Lab. PIKO',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Card bulat & grid
          Positioned(
            top: 180, // card atas menonjol ke atas
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Card bulat atas (4 bulat, rata tengah, menonjol ke atas)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 16),
                // Card grid bawah
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Baris 1: 4 bulat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 16),
                      // Baris 2: 4 bulat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 16),
                      // Baris 3: garis horizontal
                      Divider(thickness: 1, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      // Baris 4: 2 bulat dengan garis vertikal di tengah
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: Colors.grey[300],
                            margin: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 70,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', active: true),
            _buildNavItem(Icons.inventory_2, 'Invent'),
            _buildQRScannerButton(context),
            _buildNavItem(Icons.history, 'History'),
            _buildNavItem(Icons.bar_chart, 'Reports'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool active = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? Colors.black54 : Colors.black26,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.black54 : Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _buildQRScannerButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanBarcodePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1565C0),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(12),
        child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
    );
  }
}
