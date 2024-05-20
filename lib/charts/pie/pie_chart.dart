import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  MyPieChart({super.key});
  List numbers = [43000, 760000, 20000, 42000, 56000];

  List<PieChartSectionData> createSections() {
    List<PieChartSectionData> sections = [];

    for (int value in numbers) {
      // Create PieChartSectionData for each value in numbers
      PieChartSectionData section = PieChartSectionData(
        titlePositionPercentageOffset: value.toDouble(),
        //badgePositionPercentageOffset: value.toDouble(),
        value: value.toDouble(),
        color: getRandomColor(),
        radius: 50,
      );

      sections.add(section);
    }

    return sections;
  }

  Color getRandomColor() {
    // You can replace this with your own logic for generating colors
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Text('REVENUE'),
        PieChart(PieChartData(sections: createSections())),
      ],
    );
  }
}
