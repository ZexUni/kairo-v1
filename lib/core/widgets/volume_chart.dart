import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:kairo/core/constants/app_colors.dart';

class VolumeChart extends StatelessWidget {
  final List<double> volumes;

  const VolumeChart({super.key, required this.volumes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      height: 280,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white10, width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Volume Progression',

            style: TextStyle(
              color: AppColors.textPrimary,

              fontSize: 22,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Training volume trend over time.',

            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),

          const SizedBox(height: 28),

          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,

                  drawVerticalLine: false,

                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white10, strokeWidth: 1);
                  },
                ),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),

                          child: Text(
                            'D${value.toInt() + 1}',

                            style: const TextStyle(
                              color: AppColors.textSecondary,

                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: volumes.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),

                    isCurved: true,

                    color: AppColors.primary,

                    barWidth: 4,

                    dotData: FlDotData(show: true),

                    belowBarData: BarAreaData(
                      show: true,

                      color: AppColors.primary.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
