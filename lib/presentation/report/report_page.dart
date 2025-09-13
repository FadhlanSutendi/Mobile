import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_prapw/presentation/home/models/home_models.dart';
import 'package:project_prapw/presentation/navbar_bottom/navbar_bottom_page.dart';
import 'package:project_prapw/routes/app_routes.dart';
import 'controller/report_controller.dart';
import 'models/report_models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.width < 375;
    final isMediumDevice = size.width >= 375 && size.width < 414;
    final isLargeDevice = size.width >= 414;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.toNamed(AppRoutes.home),
        ),
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: isSmallDevice ? 16 : 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: RefreshIndicator(
        onRefresh: () {
          return controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
            child: Column(
              children: [
                // --- Most of Borrowing Card ---
                Obx(() {
                  if (controller.isLoadingPie.value) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallDevice ? 24 : 32),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  final pieData = controller.pieData;
                  if (pieData.isEmpty) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallDevice ? 24 : 32),
                        child: Center(
                            child: Text('No data',
                                style:
                                    GoogleFonts.poppins(color: Colors.grey))),
                      ),
                    );
                  }

                  // ✅ Hitung total & normalisasi persentase
                  final total =
                      pieData.fold<int>(0, (sum, e) => sum + e.totalBorrowed);
                  final normalized = pieData.map((e) {
                    final percent =
                        total > 0 ? (e.totalBorrowed / total) * 100 : 0.0;
                    return {
                      "name": e.name,
                      "totalBorrowed": e.totalBorrowed,
                      "percent": percent,
                    };
                  }).toList();

                  // Item utama (yang pertama dari API)
                  final mainItem = normalized.first;

                  // ✅ Warna sesuai figma
                  final List<Color> figmaColors = [
                    Color(0xFFD9D9D9), // Laptop
                    Color(0xFFB0B0B0), // Keyboard
                    Color(0xFF8C8C8C), // Mouse
                    Color(0xFF595959), // Earphone
                    Color(0xFF000000), // Monitor
                  ];

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
                      child: Column(
                        children: [
                          Text(
                            'Most of Borrowing',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallDevice ? 14 : 16,
                            ),
                          ),
                          SizedBox(height: isSmallDevice ? 12 : 16),

                          // ✅ Responsive Pie Chart
                          SizedBox(
                            height: isSmallDevice ? 140 : isMediumDevice ? 150 : 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: isSmallDevice ? 35 : isMediumDevice ? 40 : 45,
                                    sections:
                                        normalized.asMap().entries.map((entry) {
                                      final idx = entry.key;
                                      final data = entry.value;
                                      return PieChartSectionData(
                                        color: figmaColors[
                                            idx % figmaColors.length],
                                        value: data["percent"] as double,
                                        title: '',
                                        radius: isSmallDevice ? 35 : isMediumDevice ? 40 : 45,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(mainItem["percent"] as double).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: isSmallDevice ? 20 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      mainItem["name"] as String,
                                      style: TextStyle(
                                        fontSize: isSmallDevice ? 11 : 14,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isSmallDevice ? 12 : 16),

                          // ✅ Responsive Legend
                          Obx(() {
                            if (controller.isLoadingLegend.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final legendData = controller.legendData;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: legendData.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final e = entry.value;
                                return _legendItem(
                                  figmaColors[idx % figmaColors.length],
                                  e.name,
                                  e.totalBorrowed.toString(),
                                  isSmallDevice,
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: isSmallDevice ? 12 : 16),

                // --- Activity Statistics Card ---
                Obx(() {
                  if (controller.isLoadingLoanReport.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reportModel = LoanReportModel(
                    status: 200,
                    monthlyData:
                        Map<String, int>.from(controller.loanReportData),
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
                    margin: EdgeInsets.symmetric(
                      horizontal: isSmallDevice ? 0 : 16, 
                      vertical: isSmallDevice ? 4 : 8
                    ),
                    padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
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
                        // 🔹 Responsive Header + Year Picker
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "Overview Statistics",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallDevice ? 14 : 16,
                                ),
                              ),
                            ),
                            SizedBox(width: isSmallDevice ? 4 : 8),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isSmallDevice)
                                    Text(
                                      "Select Year",
                                      style: GoogleFonts.poppins(
                                          fontSize: isSmallDevice ? 8 : 10,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF959595)),
                                    ),
                                  SizedBox(width: isSmallDevice ? 4 : 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: Get.context!,
                                        initialDate: DateTime(
                                            controller.selectedYear.value ??
                                                DateTime.now().year),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDatePickerMode:
                                            DatePickerMode.year,
                                      );
                                      if (selectedDate != null) {
                                        controller.fetchLoanReportByYear(
                                            selectedDate.year);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isSmallDevice ? 3 : 5, 
                                          vertical: isSmallDevice ? 2 : 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: const Color(0xFFD9D9D9),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: isSmallDevice ? 8 : 10,
                                            color: Colors.black87,
                                          ),
                                          SizedBox(width: isSmallDevice ? 4 : 6),
                                          Text(
                                            (controller.selectedYear.value ??
                                                    DateTime.now().year)
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: isSmallDevice ? 8 : 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallDevice ? 8 : 12),

                        // 🔹 Validasi data
                        if (controller.selectedYear.value == null ||
                            reportModel.monthlyData.values.every((v) => v == 0))
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.grey, 
                                    size: isSmallDevice ? 36 : 48),
                                SizedBox(height: isSmallDevice ? 6 : 8),
                                Text(
                                  "Data tidak ditemukan",
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallDevice ? 12 : 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          // 🔹 Responsive Chart dengan scroll horizontal
                          SizedBox(
                            height: isSmallDevice ? 220 : isMediumDevice ? 250 : 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: months.length * (isSmallDevice ? 50 : isMediumDevice ? 60 : 70),
                                child: Stack(
                                  children: [
                                    BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        maxY: (reportModel.monthlyData.values
                                                    .isNotEmpty
                                                ? (reportModel
                                                        .monthlyData.values
                                                        .reduce((a, b) =>
                                                            a > b ? a : b) +
                                                    2)
                                                : 10)
                                            .toDouble(),
                                        barTouchData:
                                            BarTouchData(enabled: false),
                                        titlesData: FlTitlesData(
                                          leftTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                if (value.toInt() >= 0 &&
                                                    value.toInt() <
                                                        months.length) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Text(
                                                      months[value.toInt()],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: isSmallDevice ? 9 : 11,
                                                        color:
                                                            Color(0xFF898989),
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
                                        barGroups:
                                            List.generate(months.length, (i) {
                                          final y = reportModel
                                                  .monthlyData[months[i]]
                                                  ?.toDouble() ??
                                              0.0;
                                          return BarChartGroupData(
                                            x: i,
                                            barRods: [
                                              BarChartRodData(
                                                toY: y,
                                                width: isSmallDevice ? 20 : isMediumDevice ? 24 : 28,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: const Color(0xFFD9D9D9),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),

                                    // 🔹 Responsive Badge angka
                                    Positioned.fill(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final chartHeight =
                                              constraints.maxHeight;
                                          final chartWidth =
                                              constraints.maxWidth;
                                          final itemWidth =
                                              chartWidth / months.length;

                                          return Stack(
                                            children: List.generate(
                                                months.length, (i) {
                                              final y = reportModel
                                                      .monthlyData[months[i]]
                                                      ?.toDouble() ??
                                                  0.0;
                                              final maxY = (reportModel
                                                          .monthlyData
                                                          .values
                                                          .isNotEmpty
                                                      ? (reportModel.monthlyData
                                                              .values
                                                              .reduce((a, b) =>
                                                                  a > b
                                                                      ? a
                                                                      : b) +
                                                          2)
                                                      : 10)
                                                  .toDouble();

                                              if (y <= 0)
                                                return const SizedBox.shrink();

                                              final barHeight =
                                                  (y / maxY) * chartHeight;

                                              return Positioned(
                                                left: itemWidth * i +
                                                    itemWidth / 2 -
                                                    (isSmallDevice ? 12 : 15),
                                                bottom: barHeight + (isSmallDevice ? 20 : 30),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: isSmallDevice ? 8 : 12,
                                                      vertical: isSmallDevice ? 3 : 4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF043D94),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            isSmallDevice ? 10 : 12),
                                                  ),
                                                  child: Text(
                                                    y.toInt().toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: isSmallDevice ? 8 : 9,
                                                      fontWeight:
                                                          FontWeight.bold,
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavbarBottom(selectedIndex: 0),
    );
  }

  static Widget _legendItem(Color? color, String label, String value, bool isSmallDevice) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallDevice ? 1 : 2),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: isSmallDevice ? 8 : 10),
          SizedBox(width: isSmallDevice ? 6 : 8),
          Expanded(
            child: Text(
              label, 
              style: GoogleFonts.poppins(
                fontSize: isSmallDevice ? 12 : 14
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value, 
            style: GoogleFonts.poppins(
              fontSize: isSmallDevice ? 12 : 14
            )
          ),
        ],
      ),
    );
  }
}