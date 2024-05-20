import 'package:ylorders/functions/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ylorders/charts/bar/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = weeklySummary.isNotEmpty
        ? BarData(
            jan: weeklySummary[0],
            feb: weeklySummary[1],
            mar: weeklySummary[2],
            apr: weeklySummary[3],
            may: weeklySummary[4],
            jun: weeklySummary[5],
            jul: weeklySummary[6],
            aug: weeklySummary[7],
            sep: weeklySummary[8],
            oct: weeklySummary[9],
            nov: weeklySummary[10],
            dec: weeklySummary[11],
          )
        : BarData(
            jan: 0,
            feb: 0,
            mar: 0,
            apr: 0,
            may: 0,
            jun: 0,
            jul: 0,
            aug: 0,
            sep: 0,
            oct: 0,
            nov: 0,
            dec: 0,
          );
    myBarData.initializeData();
    return BarChart(BarChartData(
        minY: 0,
        maxY: BusyBeeCore().findLargestNumber(weeklySummary),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: BusyBeeCore().getRandomColor(.5),
                    width: 20,
                    borderRadius: BorderRadius.circular(2),
                  )
                ]))
            .toList()));
  }
}
