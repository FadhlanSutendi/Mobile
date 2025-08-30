import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Add this import for ChangeNotifierProvider
import 'controller/history_controller.dart';
import 'models/history_models.dart';
import 'detail_history_page.dart'; // Import the detail page
import '../../routes/app_routes.dart'; // Tambahkan import ini
import 'package:get/get.dart'; // Tambahkan import ini
import '../navbar_bottom/navbar_bottom_page.dart'; // Add this import

class HistoryPengembalianPage extends StatelessWidget {
  final String token;
  HistoryPengembalianPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryController(token: token)..fetchHistory(),
      child: DefaultTabController(
        length: 6, // All, Laptop, Mouse, Keyboard, Monitor, Terminal
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'History Page',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start, // tab rapat ke kiri
              indicatorColor: Colors.black,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "All"),
                Tab(text: "Laptop"),
                Tab(text: "Mouse"),
                Tab(text: "Keyboard"),
                Tab(text: "Monitor"),
                Tab(text: "Terminal"),
              ],
            ),
          ),
          body: Consumer<HistoryController>(
            builder: (context, controller, _) {
              final returnedItems = controller.filteredItems
                  .where((item) => item.status == true)
                  .toList();

              if (controller.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (returnedItems.isEmpty) {
                return Center(child: Text("No returned items found"));
              }

              return TabBarView(
                children: [
                  _buildList(returnedItems, context), // All
                  _buildList(returnedItems.where((e) => e.itemType == "Laptop").toList(), context),
                  _buildList(returnedItems.where((e) => e.itemType == "Mouse").toList(), context),
                  _buildList(returnedItems.where((e) => e.itemType == "Keyboard").toList(), context),
                  _buildList(returnedItems.where((e) => e.itemType == "Monitor").toList(), context),
                  _buildList(returnedItems.where((e) => e.itemType == "Terminal").toList(), context),
                ],
              );
            },
          ),
          bottomNavigationBar: NavbarBottom(selectedIndex: 2),
        ),
      ),
    );
  }

  Widget _buildList(List<HistoryItem> items, BuildContext context) {
    // urutkan dari terbaru ke lama
    items.sort((a, b) => b.borrowedAt.compareTo(a.borrowedAt));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Today",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 4),
        ...items.map((e) => _HistoryCard(item: e)).toList(),
      ],
    );
  }
}
  class _HistoryCard extends StatelessWidget {
  final HistoryItem item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailHistoryPage(item: item)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: const Border(
            left: BorderSide(
              color: Color(0xFF1565C0), // warna biru
              width: 8, // tebal garis kiri
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (dot + kode)
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF1565C0),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${item.itemType.toUpperCase()} | ${item.codeUnit}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _getTimeAgo(item.borrowedAt),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            // Purpose
            Text(
              item.purpose,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            // Borrower
            Text(
              'For ${item.studentName ?? item.teacherName ?? item.borrowedBy}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      );
  }

  String _getTimeAgo(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays} days';
    } catch (_) {
      return '';
    }
  }
}
  String _getTimeAgo(String dateTimeStr) {
    // Simple time ago logic
    try {
      final dt = DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    } catch (_) {
      return '';
    }
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
        // Navigasi ke halaman scan barcode
        Get.toNamed(AppRoutes.scanBarcode);
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
