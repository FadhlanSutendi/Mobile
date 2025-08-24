import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ untuk chart
import 'package:intl/intl.dart';
import '../navbar_bottom/navbar_bottom_page.dart';
import '../navbar_bottom/controller/navbar_bottom_controller.dart';
import '../home/controller/home_controller.dart';
import '../home/binding/home_binding.dart';

class HomePage extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  Get.put(NavbarBottomController());
  final controller = Get.put(HomeController());

  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Column(
        children: [
          // 🔹 Banner + Summary Card pakai Stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Banner
              SizedBox(
                height: 250,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.asset(
                    'assets/banner.jpg',
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
              Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Logo
                  Image.asset(
                    "assets/logo_putih.png",
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                ])),

              const Positioned(
                top: 175,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF003087)),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Iqbal Fajar Syah...',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5),
                        ),
                        Text(
                          'Wednesday, 31 July 2025  (08:30 AM)',
                          style: TextStyle(color: Colors.white70, fontSize: 7.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 Summary Card positioned biar naik ke banner
              Positioned(
                left: 16,
                right: 16,
                bottom: -120, // supaya card keluar ke bawah banner
                child: Obx(() {
                  if (controller.isLoadingCard.value) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  final card = controller.cardData;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(
                                icon: Icons.upload_outlined,
                                label: "Reuse",
                                value: "${card['reuse'] ?? 0}"),
                            _SummaryItem(
                                icon: Icons.download_outlined,
                                label: "Consum",
                                value: "${card['used'] ?? 0}"),
                            _SummaryItem(
                                icon: Icons.thumb_up_alt_outlined,
                                label: "Good",
                                value: "${card['good'] ?? 0}"),
                            _SummaryItem(
                                icon: Icons.thumb_down_alt_outlined,
                                label: "Down",
                                value: "${card['down'] ?? 0}"),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _SummaryData(
                              icon: Icons.calendar_today_outlined,
                                label: "Monthly Data: ",
                                value: "${card['monthly_data'] ?? 0}"),
                            Container(
                              height: 30, // tinggi garis (sesuaikan)
                              width: 1,   // ketebalan garis
                              color: Colors.grey.shade400,
                            ),
                            _SummaryData(
                                icon: Icons.calendar_today_outlined,
                                label: "Daily Data: ",
                                value: "${card['daily_data'] ?? 0}"),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 135), // spacer agar card tidak nutup section bawah

          // 🔹 Chart Section
          Obx(() {
            if (controller.isLoadingLoanReport.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final report = controller.loanReportData;
            final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                     Text("Overview Statistics",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (report.values.isNotEmpty
                                  ? (report.values.reduce((a, b) => a > b ? a : b) + 2)
                                  : 10)
                              .toDouble(),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
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
                                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        days[value.toInt()],
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF898989)),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(days.length, (i) {
                            final y = report[days[i]]?.toDouble() ?? 5.0;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: y,
                                  width: 28,
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFFD9D9D9), // <-- warna chart
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      // angka di atas bar
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final chartWidth = constraints.maxWidth;
                            final barSpacing = chartWidth / (days.length * 1.5);
                
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(days.length, (i) {
                                final y = report[days[i]]?.toDouble() ?? 5.0;
                                return Padding(
                                  padding: EdgeInsets.only(bottom: (100 - y * 10).clamp(0, 200)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF043D94), // warna biru
                                      borderRadius: BorderRadius.circular(12), // badge bulat
                                    ),
                                    child: Text(
                                      y.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // biar kontras di biru
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                ],
              ),
            );
          }),

          // 🔹 Latest Activity
          Obx(() {
            if (controller.isLoadingActivity.value) {
              return const Center(child: CircularProgressIndicator());
            }
            // final activities = controller.activityList;

            // Data Dummy 
            final activities = [
              {
                'borrower_name': 'Andi',
                'item': 'Laptop',
                'sub_item': 'Asus ROG',
                'borrowed_at': '2025-08-20 - 12:00:00'
              },
              {
                'borrower_name': 'Budi',
                'item': 'Proyektor',
                'sub_item': 'Epson X300',
                'borrowed_at': '2025-08-21 - 12:00:00'
              },
              {
                'borrower_name': 'Citra',
                'item': 'Kamera',
                'sub_item': 'Canon EOS',
                'borrowed_at': '2025-08-22 - 12:00:00'
              },
              {
                'borrower_name': 'Dewi',
                'item': 'Tripod',
                'sub_item': 'Takara ECO',
                'borrowed_at': '2025-08-23 - 12:00:00'
              },
            ];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
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
                  ...activities.map<Widget>((item) {
                    final name =
                        "${item['borrower_name'] ?? ''} ";
                    final date = formatDate(item['borrowed_at']) ?? '';
                    return _ActivityItem(
                      name: name,
                      date: date,
                    );
                  }).toList(),
                ],
              ),
            );
          }),

          const SizedBox(height: 80), // biar ga ketutup navbar
        ],
      ),
    ),
    bottomNavigationBar: NavbarBottom(selectedIndex: 0),
  );
}

  String formatDate(String? rawDate, {String pattern = "dd MMMM yyyy"}) {
    if (rawDate == null || rawDate.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat(pattern).format(parsedDate);
    } catch (e) {
      return rawDate; // fallback kalau gagal parsing
    }
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
          backgroundColor: const Color(0xFF1E60C5),
          child: Icon(icon, color: Colors.white, size: 20,),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF545454))),
            const SizedBox(width: 3),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF545454))),
          ],
        ),
      ],
    );
  }
}

// 🔹 Helper Widget untuk Summary Data
class _SummaryData extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryData({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Color(0xFF545454)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF545454),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF545454),
          ),
        ),
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
            backgroundColor: Color(0xFFD9D9D9),
            child: Icon(Icons.person_outline, color: Colors.black),
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

  String formatDate(String? rawDate, {String pattern = "dd MMMM yyyy"}) {
    if (rawDate == null || rawDate.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat(pattern).format(parsedDate);
    } catch (e) {
      return rawDate; // fallback kalau gagal parsing
    }
  }
