import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_prapw/presentation/home/models/home_models.dart';
import 'package:project_prapw/routes/app_routes.dart';
import 'controller/report_controller.dart';
import 'models/report_models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.toNamed(AppRoutes.home),
        ),
        title: const Text('Reports',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Most of Borrowing Card ---
            Obx(() {
              if (controller.isLoadingPie.value) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final pieData = controller.pieData;
              if (pieData.isEmpty) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No data')),
                  ),
                );
              }
              final mainItem = pieData[0];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Most of Borrowing',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 45,
                                sections: pieData.map((e) {
                                  final idx = pieData.indexOf(e);
                                  final colors = [
                                    Colors.grey[300],
                                    Colors.grey[400],
                                    Colors.grey[500],
                                    Colors.grey[600],
                                    Colors.black,
                                  ];
                                  return PieChartSectionData(
                                    color: colors[idx % colors.length],
                                    value: e.persen,
                                    title: '',
                                    radius: 45,
                                  );
                                }).toList(),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${mainItem.persen.toInt()}%',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(mainItem.name,
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Obx(() {
                        if (controller.isLoadingLegend.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final legendData = controller.legendData;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: legendData.map((e) {
                            final idx = legendData.indexOf(e);
                            final colors = [
                              Colors.grey[300],
                              Colors.grey[400],
                              Colors.grey[500],
                              Colors.grey[600],
                              Colors.black,
                            ];
                            return _legendItem(colors[idx % colors.length],
                                e.name, e.totalBorrowed.toString());
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // --- Activity Statistics Card ---
            Obx(() {
              if (controller.isLoadingLoanReport.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Gunakan model LoanReportModel
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

              final maxY = (reportModel.monthlyData.values.isNotEmpty
                      ? (reportModel.monthlyData.values
                              .reduce((a, b) => a > b ? a : b) +
                          2)
                      : 10)
                  .toDouble();

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
                    const Text(
                      "Overview Statistics",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Chart
                    SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          // Chart
                          BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxY,
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
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            months[value.toInt()],
                                            style: const TextStyle(
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

                          // 🔹 Badge angka di atas bar
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final chartHeight = constraints.maxHeight;
                                final chartWidth = constraints.maxWidth;
                                final itemWidth = chartWidth /
                                    months.length; // lebar slot per bulan

                                return Stack(
                                  children: List.generate(months.length, (i) {
                                    final y = reportModel.monthlyData[months[i]]
                                            ?.toDouble() ??
                                        0.0;
                                    if (y <= 0) return const SizedBox.shrink();

                                    // hitung tinggi bar
                                    final barHeight = (y / maxY) * chartHeight;

                                    return Positioned(
                                      left: itemWidth * i +
                                          itemWidth / 2 -
                                          15, // geser ke tengah bar
                                      bottom:
                                          barHeight + 30, // selalu di atas bar
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF043D94),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          y.toInt().toString(),
                                          style: const TextStyle(
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
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static Widget _legendItem(Color? color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 10),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
