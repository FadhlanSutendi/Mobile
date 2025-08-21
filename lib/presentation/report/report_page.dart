import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'controller/report_controller.dart';
import 'models/report_models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Most of Borrowing Card
            Obx(() {
              if (controller.isLoadingPie.value) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final pieData = controller.pieData;
              if (pieData.isEmpty) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text('No data')),
                  ),
                );
              }
              final mainItem = pieData[0];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Most of Borrowing', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
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
                                    radius: 40,
                                  );
                                }).toList(),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${mainItem.persen.toInt()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Text(mainItem.name, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Obx(() {
                        if (controller.isLoadingLegend.value) {
                          return Center(child: CircularProgressIndicator());
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
                            return _legendItem(colors[idx % colors.length], e.name, e.totalBorrowed.toString());
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            // Activity Statistics Card
            Obx(() {
              if (controller.isLoadingLoanReport.value) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final report = controller.loanReportData;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('Activity Statistics', style: TextStyle(fontWeight: FontWeight.bold)),
                          Spacer(),
                          Text('Monthly', style: TextStyle(color: Colors.grey)),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (report.values.isNotEmpty
                                    ? (report.values.reduce((a, b) => a > b ? a : b) + 2)
                                    : 10)
                                .toDouble(),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 && value.toInt() < months.length) {
                                      return Text(months[value.toInt()], style: const TextStyle(fontSize: 12));
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(months.length, (i) {
                              final y = report[months[i]]?.toDouble() ?? 0.0;
                              return _barGroup(i, y);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  static BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.grey[400],
          width: 18,
          borderRadius: BorderRadius.circular(6),
          rodStackItems: [],
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
      showingTooltipIndicators: [0],
      barsSpace: 2,
    );
  }
}
