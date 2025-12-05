import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrdersOverviewChart extends StatelessWidget {
  const OrdersOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Orders Overview",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Orders breakdown by status",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                barGroups: _barGroups,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun",
                        ];
                        return Text(days[value.toInt()]);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              _Legend(color: Colors.red, label: "canceled"),
              SizedBox(width: 16),
              _Legend(color: Colors.green, label: "completed"),
              SizedBox(width: 16),
              _Legend(color: Colors.orange, label: "pending"),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------- LET’S BUILD THE DATA ----------------

final List<BarChartGroupData> _barGroups = List.generate(7, (i) {
  // Data from your chart
  const canceled = [5, 4, 3, 2, 6, 7, 4];
  const completed = [60, 55, 75, 70, 90, 110, 120];
  const pending = [15, 20, 10, 12, 18, 14, 11];

  return BarChartGroupData(
    x: i,
    barRods: [
      BarChartRodData(
        toY: canceled[i].toDouble(),
        color: Colors.red,
        width: 8,
        borderRadius: BorderRadius.circular(2),
      ),
      BarChartRodData(
        toY: completed[i].toDouble(),
        color: Colors.green,
        width: 8,
        borderRadius: BorderRadius.circular(2),
      ),
      BarChartRodData(
        toY: pending[i].toDouble(),
        color: Colors.orange,
        width: 8,
        borderRadius: BorderRadius.circular(2),
      ),
    ],
    barsSpace: 6,
  );
});

// ---------------- LEGEND WIDGET ----------------

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 15, height: 15, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
