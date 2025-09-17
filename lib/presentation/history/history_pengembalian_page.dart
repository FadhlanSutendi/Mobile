import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'controller/history_controller.dart';
import 'models/history_models.dart';
import 'detail_history_page.dart';
import '../navbar_bottom/navbar_bottom_page.dart';

class HistoryPengembalianPage extends StatelessWidget {
  final String token;
  const HistoryPengembalianPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          HistoryController(token: token)..fetchHistory(data: 'returning'),
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'History Page',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: Consumer<HistoryController>(
            builder: (context, controller, _) {
              final returnedItems = controller.filteredItems
                  .where((item) => item.status == true)
                  .toList();

              // Group items by date
              final grouped = <String, List<HistoryItem>>{};
              for (var item in returnedItems) {
                final date = _formatDate(item.borrowedAt);
                grouped.putIfAbsent(date, () => []).add(item);
              }

              final sortedDates = grouped.keys.toList()
                ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

              final categories = controller.availableCategories;
              return controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DefaultTabController(
                      length: categories.length,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicatorColor: Colors.black,
                            indicatorWeight: 2.5,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            unselectedLabelStyle: GoogleFonts.poppins(),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: categories.map((cat) => Tab(text: cat)).toList(),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: categories.map((cat) {
                                final filteredGrouped = cat == 'All'
                                    ? grouped
                                    : _filterByType(grouped, sortedDates, cat);
                                return _buildGroupedList(filteredGrouped, sortedDates);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          bottomNavigationBar: NavbarBottom(selectedIndex: 2),
        ),
      ),
    );
  }

  // Helper untuk filter grouped items berdasarkan itemType
  Map<String, List<HistoryItem>> _filterByType(
      Map<String, List<HistoryItem>> grouped,
      List<String> sortedDates,
      String type) {
    final filtered = <String, List<HistoryItem>>{};
    for (var date in sortedDates) {
      final items = grouped[date]!.where((e) => e.itemType.toLowerCase() == type.toLowerCase()).toList();
      if (items.isNotEmpty) filtered[date] = items;
    }
    return filtered;
  }

  Widget _buildGroupedList(
      Map<String, List<HistoryItem>> grouped, List<String> sortedDates) {
    if (grouped.isEmpty)
      return const Center(child: Text("No returned items found"));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      children: sortedDates.where((d) => grouped[d] != null).map((date) {
        final items = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ...items.map((e) => _HistoryCard(item: e)),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  // format ke label: Today, Yesterday, atau tanggal
  static String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr.replaceFirst(' ', 'T'));
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day)
        return "Today";
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day - 1)
        return "Yesterday";
      return "${_weekday(dt)}, ${dt.day} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return dateStr;
    }
  }

  static DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr.replaceFirst(' ', 'T'));
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _weekday(DateTime dt) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[dt.weekday - 1];
  }

  static String _month(int m) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[m];
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
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
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
            const SizedBox(height: 6),
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
            const SizedBox(height: 2),
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
      final dt = DateTime.parse(dateTimeStr.replaceFirst(' ', 'T')).toUtc().add(const Duration(hours: 7)); // WIB/Jakarta
      final now = DateTime.now().toUtc().add(const Duration(hours: 7)); // WIB/Jakarta
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays} days';
    } catch (_) {
      return '';
    }
  }
}