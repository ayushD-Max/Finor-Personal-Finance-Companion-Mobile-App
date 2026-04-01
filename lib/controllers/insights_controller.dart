import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsController extends GetxController {
  final TransactionController transactionController = Get.find<TransactionController>();

  void onInit() {
    super.onInit();
  }

  // Bar chart data grouping by weekday
  List<BarChartGroupData> getWeeklyData() {
    // A simplified example
    final data = <int, double>{0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
    final now = DateTime.now();

    for (var t in transactionController.allTransactions) {
      if (t.type == 'expense' && now.difference(t.date).inDays < 7) {
        data[t.date.weekday - 1] = (data[t.date.weekday - 1] ?? 0) + t.amount;
      }
    }

    return data.entries.map((e) {
      return BarChartGroupData(x: e.key, barRods: [
        BarChartRodData(
          toY: e.value,
          color: const Color(0xFFFF4D4D),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        )
      ]);
    }).toList();
  }

  Map<String, double> getCategoryBreakdown() {
    final breakdown = <String, double>{};
    for (var t in transactionController.allTransactions) {
      if (t.type == 'expense') {
        breakdown[t.category] = (breakdown[t.category] ?? 0) + t.amount;
      }
    }
    return breakdown;
  }

  Map<String, double> compareThisVsLastMonth() {
    double thisMonth = 0;
    double lastMonth = 0;
    final now = DateTime.now();

    for (var t in transactionController.allTransactions) {
      if (t.type == 'expense') {
        if (t.date.year == now.year && t.date.month == now.month) {
          thisMonth += t.amount;
        } else if (t.date.year == now.year && t.date.month == now.month - 1) {
          // Simplistic last month check
          lastMonth += t.amount;
        }
      }
    }

    return {'thisMonth': thisMonth, 'lastMonth': lastMonth};
  }

  String getTopCategory() {
    final breakdown = getCategoryBreakdown();
    if (breakdown.isEmpty) return 'None';
    var topCat = breakdown.keys.first;
    for (var key in breakdown.keys) {
      if (breakdown[key]! > breakdown[topCat]!) {
        topCat = key;
      }
    }
    return topCat;
  }
}
