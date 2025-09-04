import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/progress_data.dart';

class ConfidenceBarChart extends StatelessWidget {
  final List<ProgressData> progressData;

  const ConfidenceBarChart({super.key, required this.progressData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: progressData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.confidence,
                color: Colors.amber,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
