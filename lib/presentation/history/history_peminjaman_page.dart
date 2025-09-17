import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'controller/history_controller.dart';
import 'models/history_models.dart';
import 'detail_history_page.dart';
import '../navbar_bottom/navbar_bottom_page.dart';

class HistoryPeminjamanPage extends StatelessWidget {
  final String token;
  HistoryPeminjamanPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryController(token: token)..fetchHistory(),
      child: Consumer<HistoryController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.availableCategories.length <= 1) {
            return Center(child: CircularProgressIndicator());
          }

          final borrowedItems = controller.filteredItems
              .where((item) => item.status == false)
              .toList();

          final categories = controller.availableCategories;

          return DefaultTabController(
            length: categories.length,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text(
                  'Borrowed Page',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              body: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.black,
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: categories.map((cat) => Tab(text: cat)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: categories.map((cat) {
                        final filtered = cat == 'All'
                            ? borrowedItems
                            : borrowedItems.where((e) => e.itemType.toLowerCase() == cat.toLowerCase()).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              "No items found in $cat category",
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }

                        return _buildRefreshableList(filtered, controller, context);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: NavbarBottom(selectedIndex: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRefreshableList(List<HistoryItem> items,
      HistoryController controller, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return controller.refreshHistory();
      },
      child: _buildList(items, context),
    );
  }

  Widget _buildList(List<HistoryItem> items, BuildContext context) {
    // urutkan dari terbaru ke lama
    items.sort((a, b) => b.borrowedAt.compareTo(a.borrowedAt));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      children: [
        // Label "Today" sekali di atas
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
              color: Color(0xFF1565C0),
              width: 8,
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
      // Parse as UTC, lalu konversi ke WIB/Jakarta (UTC+7)
      final dt = DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      final dtJakarta = dt.isUtc ? dt.add(const Duration(hours: 7)) : dt.toUtc().add(const Duration(hours: 7));
      final nowJakarta = DateTime.now().toUtc().add(const Duration(hours: 7));
      final diff = nowJakarta.difference(dtJakarta);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays} days';
    } catch (_) {
      return '';
    }
  }
}