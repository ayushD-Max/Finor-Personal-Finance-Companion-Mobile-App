import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insights_controller.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    Get.put(InsightsController());
    final iCtrl = Get.find<InsightsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDown(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('Weekly Spending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 1000, // Make dynamic in real app
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        days[value.toInt() % 7],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: iCtrl.getWeeklyData(),
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 900),
                          swapAnimationCurve: Curves.easeOutCubic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _buildComparisonCard(iCtrl),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: const Text('Category Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),
            ...iCtrl.getCategoryBreakdown().entries.map((e) {
              return FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.category, color: AppTheme.primaryColor),
                    ),
                    title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(Formatters.formatCurrency(e.value), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.errorColor)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(InsightsController iCtrl) {
    final comparison = iCtrl.compareThisVsLastMonth();
    final thisMonth = comparison['thisMonth'] ?? 0;
    final lastMonth = comparison['lastMonth'] ?? 0;
    final percentChange = lastMonth == 0 ? 0 : ((thisMonth - lastMonth) / lastMonth * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryColor, AppTheme.primaryColor.withBlue(200)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Comparison', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This Month', style: TextStyle(color: Colors.white, fontSize: 13)),
                  Text(Formatters.formatCurrency(thisMonth), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Icon(percentChange > 0 ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: Colors.white),
                    Text('${percentChange.abs()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Last Month', style: TextStyle(color: Colors.white, fontSize: 13)),
                  Text(Formatters.formatCurrency(lastMonth), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
