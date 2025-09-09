import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ untuk chart
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_prapw/routes/app_routes.dart';

import '../navbar_bottom/navbar_bottom_page.dart';
import '../navbar_bottom/controller/navbar_bottom_controller.dart';
import '../home/controller/home_controller.dart';
import '../home/models/home_models.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(NavbarBottomController());
    final controller = Get.put(HomeController());

    final List<String> bannerList = [
      'assets/banner.jpg',
      'assets/Banner-DKV.jpg',
      'assets/Banner-HTL.jpg',
      'assets/Banner-KULINER.jpg',
      'assets/Banner-MPLB.jpg',
      'assets/Banner-PMN.jpg',
      'assets/Banner-TJKT.jpg',
      'assets/Banner-Web.jpg',
    ];

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
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 1.0, // full width
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        enlargeCenterPage: false,
                      ),
                      items: bannerList.map((item) {
                        return Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Logo
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/logo_putih.png",
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                // User info
                Positioned(
                  top: 175,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF003087)),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                controller.userName.value.isNotEmpty
                                    ? controller.userName.value
                                    : '...',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              )),
                          Text(
                            formatDateIndonesia(DateTime.now()),
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 7.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🔹 Summary Card
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -120,
                  child: Obx(() {
                    if (controller.isLoadingCard.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // Gunakan model CardOverview
                    final card = CardOverview.fromJson(
                        Map<String, dynamic>.from(controller.cardData));
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
                                value: "${card.reuse}",
                              ),
                              _SummaryItem(
                                icon: Icons.download_outlined,
                                label: "Consum",
                                value: "${card.used}",
                              ),
                              _SummaryItem(
                                icon: Icons.thumb_up_alt_outlined,
                                label: "Good",
                                value: "${card.good}",
                              ),
                              _SummaryItem(
                                icon: Icons.thumb_down_alt_outlined,
                                label: "Down",
                                value: "${card.down}",
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SummaryData(
                                icon: Icons.calendar_today_outlined,
                                label: "Monthly Data: ",
                                value: "${card.monthlyData}",
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey.shade400,
                              ),
                              _SummaryData(
                                icon: Icons.calendar_today_outlined,
                                label: "Daily Data: ",
                                value: "${card.dailyData}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 135),

            // 🔹 Chart Section
            // 🔹 Chart Section
           Obx(() {
            if (controller.isLoadingLoanReport.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final reportModel = LoanReportModel(
              status: 200,
              monthlyData: Map<String, int>.from(controller.loanReportData),
            );

            final months = [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec"
            ];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Header + Year Picker Custom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Overview Statistics",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Select Year",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF959595)
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime(
                                  controller.selectedYear.value ?? DateTime.now().year),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDatePickerMode: DatePickerMode.year,
                            );
                            if (selectedDate != null) {
                              controller.fetchLoanReportByYear(selectedDate.year);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFFD9D9D9), // 🔹 sesuai figma
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 10,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  (controller.selectedYear.value ?? DateTime.now().year)
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Validasi data
                  if (controller.selectedYear.value == null ||
                      reportModel.monthlyData.values.every((v) => v == 0))
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            "Data tidak ditemukan",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // 🔹 Chart dengan scroll horizontal
                    SizedBox(
                      height: 280,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: months.length * 70,
                          child: Stack(
                            children: [
                              BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: (reportModel.monthlyData.values.isNotEmpty
                                          ? (reportModel.monthlyData.values
                                                  .reduce((a, b) => a > b ? a : b) +
                                              2)
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
                                          if (value.toInt() >= 0 &&
                                              value.toInt() < months.length) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                months[value.toInt()],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Color(0xFF898989),
                                                ),
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
                                  barGroups: List.generate(months.length, (i) {
                                    final y = reportModel.monthlyData[months[i]]
                                            ?.toDouble() ??
                                        0.0;
                                    return BarChartGroupData(
                                      x: i,
                                      barRods: [
                                        BarChartRodData(
                                          toY: y,
                                          width: 28,
                                          borderRadius: BorderRadius.circular(6),
                                          color: const Color(0xFFD9D9D9),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),

                              // 🔹 Badge angka
                              Positioned.fill(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final chartHeight = constraints.maxHeight;
                                    final chartWidth = constraints.maxWidth;
                                    final itemWidth = chartWidth / months.length;

                                    return Stack(
                                      children: List.generate(months.length, (i) {
                                        final y = reportModel.monthlyData[months[i]]
                                                ?.toDouble() ??
                                            0.0;
                                        final maxY = (reportModel.monthlyData.values
                                                    .isNotEmpty
                                                ? (reportModel.monthlyData.values
                                                        .reduce((a, b) => a > b ? a : b) +
                                                    2)
                                                : 10)
                                            .toDouble();

                                        if (y <= 0) return const SizedBox.shrink();

                                        final barHeight = (y / maxY) * chartHeight;

                                        return Positioned(
                                          left: itemWidth * i + itemWidth / 2 - 15,
                                          bottom: barHeight + 30,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF043D94),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              y.toInt().toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          // 🔹 Latest Activity
            Obx(() {
              if (controller.isLoadingActivity.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Gunakan model LatestActivityModel
              final activities = controller.activityList
                  .map((item) => LatestActivityModel.fromJson(item))
                  .toList();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latest Activity",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.historyPeminjaman),
                          child: Text(
                            "See All",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...activities.map<Widget>((act) {
                      return _ActivityItem(
                        name: act.borrowerName,
                        date: formatDate(act.borrowedAt),
                      );
                    }).toList(),
                  ],
                ),
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottom(selectedIndex: 0),
    );
  }

  // 🔹 Helper format date
  String formatDate(String? rawDate, {String pattern = "dd MMMM yyyy"}) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat(pattern).format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  // 🔹 Helper format tanggal Indonesia (Jakarta)
  String formatDateIndonesia(DateTime date) {
    final jakarta = date.toUtc().add(const Duration(hours: 7));
    final formatter = DateFormat("EEEE, dd MMMM yyyy (HH:mm)", "id_ID");
    return formatter.format(jakarta);
  }
}

// 🔹 Helper Widget untuk Summary Item
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFF1E60C5),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Color(0xFF545454),
              ),
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Color(0xFF545454),
              ),
            ),
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
      children: [
        Icon(icon, size: 14, color: const Color(0xFF545454)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF545454),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: GoogleFonts.poppins(
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

  const _ActivityItem({
    required this.name,
    required this.date,
  });

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
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
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
