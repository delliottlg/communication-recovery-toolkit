import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/progress_data.dart';

class ProgressChart extends StatelessWidget {
  final List<ProgressData> progressData;

  const ProgressChart({super.key, required this.progressData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: progressData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.confidence);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
