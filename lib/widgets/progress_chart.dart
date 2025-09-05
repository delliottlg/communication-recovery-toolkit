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
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: progressData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.confidence);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: false),
          ),
        ],
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

