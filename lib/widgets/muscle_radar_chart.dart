import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kairo/core/constants/app_colors.dart';

class MuscleRadarChart extends StatelessWidget {
  final Map<String, double> currentData; // Muscle -> value
  final Map<String, double> previousData; // Muscle -> value

  const MuscleRadarChart({
    super.key,
    required this.currentData,
    required this.previousData,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> features = ['Back', 'Chest', 'Core', 'Shoulders', 'Arms', 'Legs'];
    
    // Find max value for scaling
    double maxVal = 10.0;
    for (var val in currentData.values) {
      if (val > maxVal) maxVal = val;
    }
    for (var val in previousData.values) {
      if (val > maxVal) maxVal = val;
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          dataSets: [
            // Current dataset (blue)
            RadarDataSet(
              fillColor: AppColors.primary.withOpacity(0.25),
              borderColor: AppColors.primary,
              entryRadius: 3,
              dataEntries: features.map((f) {
                final val = currentData[f] ?? 0.0;
                return RadarEntry(value: val);
              }).toList(),
              borderWidth: 2,
            ),
            // Previous dataset (grey)
            RadarDataSet(
              fillColor: Colors.white10.withOpacity(0.05),
              borderColor: Colors.white24,
              entryRadius: 2,
              dataEntries: features.map((f) {
                final val = previousData[f] ?? 0.0;
                return RadarEntry(value: val);
              }).toList(),
              borderWidth: 1.5,
            ),
          ],
          getTitle: (index, angle) {
            if (index < features.length) {
              return RadarChartTitle(
                text: features[index],
                angle: angle,
              );
            }
            return const RadarChartTitle(text: '');
          },
          tickCount: 4,
          ticksTextStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
          gridBorderData: const BorderSide(color: Colors.white12, width: 1),
          radarBorderData: const BorderSide(color: Colors.white12, width: 1),
          tickBorderData: const BorderSide(color: Colors.white12, width: 1),
        ),
      ),
    );
  }
}
