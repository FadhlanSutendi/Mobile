import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ untuk chart
import '../navbar_bottom/navbar_bottom_page.dart';
import '../navbar_bottom/controller/navbar_bottom_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(NavbarBottomController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Banner + Profile
            Stack(
              children: [
                // Gambar Banner
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
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
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF003087)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
              ],
            ),

            // 🔹 Spacer biar Chart turun
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ],
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(
                          icon: Icons.refresh, label: "Reuse", value: "300"),
                      _SummaryItem(
                          icon: Icons.check_circle, label: "Used", value: "65"),
                      _SummaryItem(
                          icon: Icons.thumb_up, label: "Good", value: "80"),
                      _SummaryItem(
                          icon: Icons.thumb_down, label: "Down", value: "20"),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _SummaryData(label: "Monthly Data", value: "120"),
                      _SummaryData(label: "Daily Data", value: "12"),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Chart Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overview Statistics",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 10,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 28),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  "Mon",
                                  "Tue",
                                  "Wed",
                                  "Thu",
                                  "Fri",
                                  "Sat"
                                ];
                                return Text(days[value.toInt()],
                                    style: const TextStyle(fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _makeGroupData(0, 5.5),
                          _makeGroupData(1, 3.7),
                          _makeGroupData(2, 7.8),
                          _makeGroupData(3, 6.2),
                          _makeGroupData(4, 6.0),
                          _makeGroupData(5, 2.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Latest Activity
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Latest Activity",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("See All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _ActivityItem(
                    name: "Andiko Sartio Nurcahyo",
                    date: "21 July 2023 - 08:23 AM",
                  ),
                  const _ActivityItem(
                    name: "Nayla Qoriza Afifa",
                    date: "21 July 2023 - 08:20 AM",
                  ),
                  const _ActivityItem(
                    name: "Muhammad Rizqy Al Sultana Putra",
                    date: "21 July 2023 - 08:15 AM",
                  ),
                  const _ActivityItem(
                    name: "Muhammad Rafif",
                    date: "21 July 2023 - 08:05 AM",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // biar tidak ketutup navbar
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottom(selectedIndex: 0),
    );
  }
}

// 🔹 Helper Widget untuk Summary Item
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// 🔹 Helper Widget untuk Summary Data
class _SummaryData extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryData({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

// 🔹 Helper Widget Activity Item
class _ActivityItem extends StatelessWidget {
  final String name;
  final String date;

  const _ActivityItem({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Helper function untuk Bar Chart
BarChartGroupData _makeGroupData(int x, double y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: Colors.blue,
        width: 18,
        borderRadius: BorderRadius.circular(4),
      ),
    ],
  );
}
