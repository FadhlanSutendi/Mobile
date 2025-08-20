import 'package:flutter/material.dart';
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('History Page', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<HistoryController>(
          builder: (context, controller, _) {
            // Filter hanya data yang sudah dikembalikan (status == true)
            final returnedItems = controller.filteredItems.where((item) => item.status == true).toList();
            return Column(
              children: [
                // Category Tabs
                Container(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = controller.categories[idx];
                      final selected = cat == controller.selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          controller.setCategory(cat);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? Color(0xFF1565C0) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black54,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                // List
                Expanded(
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : returnedItems.isEmpty
                        ? Center(child: Text('No returned items found'))
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemCount: returnedItems.length,
                            itemBuilder: (context, idx) {
                              final item = returnedItems[idx];
                              return _HistoryCard(context: context, item: item, token: token); // Pass context and token to _HistoryCard
                            },
                          ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: NavbarBottom(selectedIndex: 2), // Use NavbarBottom
      ),
    );
  }

  Widget _HistoryCard({required BuildContext context, required HistoryItem item, required String token}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailHistoryPage(id: item.id, token: token),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 8,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1565C0),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
            ),
          ),
          title: Text(
            '${item.itemType.toUpperCase()} | ${item.codeUnit}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.purpose,
                style: TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                'For ${item.studentName ?? item.teacherName ?? item.borrowedBy}',
                style: TextStyle(fontSize: 12, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Text(
            _getTimeAgo(item.borrowedAt),
            style: TextStyle(fontSize: 11, color: Colors.black45),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
      ),
    );
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

