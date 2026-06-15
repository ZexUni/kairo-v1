import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/widgets/muscle_radar_chart.dart';
import 'package:kairo/core/constants/app_colors.dart';

class MuscleRadarScreen extends StatefulWidget {
  const MuscleRadarScreen({super.key});

  @override
  State<MuscleRadarScreen> createState() => _MuscleRadarScreenState();
}

class _MuscleRadarScreenState extends State<MuscleRadarScreen> {
  bool _loading = true;
  String _selectedPeriod = "7 Days"; // 7 Days, 30 Days, 90 Days

  // Current vs Previous sets counts per muscle
  Map<String, double> _currentData = {};
  Map<String, double> _previousData = {};

  int _currentWorkouts = 0;
  int _prevWorkouts = 0;
  double _currentVolume = 0.0;
  double _prevVolume = 0.0;
  int _currentSets = 0;
  int _prevSets = 0;

  @override
  void initState() {
    super.initState();
    _loadRadarData();
  }

  Future<void> _loadRadarData() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final workoutRepo = WorkoutRepository();

      int days = 7;
      if (_selectedPeriod == "30 Days") days = 30;
      if (_selectedPeriod == "90 Days") days = 90;

      final now = DateTime.now();
      final currentStart = now.subtract(Duration(days: days));
      final prevStart = now.subtract(Duration(days: days * 2));

      // Fetch current period sessions
      final currentSessions = await workoutRepo.getSessionsForPeriod(userId, currentStart, now);
      // Fetch previous period sessions
      final prevSessions = await workoutRepo.getSessionsForPeriod(userId, prevStart, currentStart);

      // Aggregate current sets
      _currentData = {'Back': 0, 'Chest': 0, 'Core': 0, 'Shoulders': 0, 'Arms': 0, 'Legs': 0};
      _currentWorkouts = currentSessions.length;
      _currentVolume = 0.0;
      _currentSets = 0;

      for (var s in currentSessions) {
        _currentVolume += s.totalVolumeKg;
        for (var ex in s.exercises) {
          final group = _normalizeMuscleGroup(ex.muscleGroup);
          if (_currentData.containsKey(group)) {
            final completedSets = ex.sets.where((set) => set.isCompleted).length.toDouble();
            _currentData[group] = _currentData[group]! + completedSets;
            _currentSets += completedSets.round();
          }
        }
      }

      // Aggregate previous sets
      _previousData = {'Back': 0, 'Chest': 0, 'Core': 0, 'Shoulders': 0, 'Arms': 0, 'Legs': 0};
      _prevWorkouts = prevSessions.length;
      _prevVolume = 0.0;
      _prevSets = 0;

      for (var s in prevSessions) {
        _prevVolume += s.totalVolumeKg;
        for (var ex in s.exercises) {
          final group = _normalizeMuscleGroup(ex.muscleGroup);
          if (_previousData.containsKey(group)) {
            final completedSets = ex.sets.where((set) => set.isCompleted).length.toDouble();
            _previousData[group] = _previousData[group]! + completedSets;
            _prevSets += completedSets.round();
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading radar data: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _normalizeMuscleGroup(String muscle) {
    muscle = muscle.trim().toLowerCase();
    if (muscle == 'biceps' || muscle == 'triceps' || muscle == 'arms') return 'Arms';
    if (muscle == 'chest') return 'Chest';
    if (muscle == 'back' || muscle == 'lats') return 'Back';
    if (muscle == 'shoulders' || muscle == 'traps') return 'Shoulders';
    if (muscle == 'legs' || muscle == 'quads' || muscle == 'calves') return 'Legs';
    if (muscle == 'core' || muscle == 'abs') return 'Core';
    return 'Chest'; // default fallback
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = _selectedPeriod == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPeriod = label;
            _loadRadarData();
          });
        }
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCompareCard(String label, String currentVal, String prevVal, IconData icon) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        currentVal,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white24, size: 12),
                      const SizedBox(width: 8),
                      Text(
                        prevVal,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Muscle Radar Chart'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Period selectors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPeriodButton('7 Days'),
                      _buildPeriodButton('30 Days'),
                      _buildPeriodButton('90 Days'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Radar Chart
                  Center(
                    child: MuscleRadarChart(
                      currentData: _currentData,
                      previousData: _previousData,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 12, width: 12, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.4), border: Border.all(color: AppColors.primary))),
                      const SizedBox(width: 8),
                      const Text('Current Period', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                      const SizedBox(width: 24),
                      Container(height: 12, width: 12, decoration: BoxDecoration(color: Colors.white12, border: Border.all(color: Colors.white24))),
                      const SizedBox(width: 8),
                      const Text('Previous Period', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Summary list
                  const Text(
                    'PERIOD COMPARISON DETAILS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCompareCard('Workouts', '$_currentWorkouts', '$_prevWorkouts', Icons.fitness_center),
                  _buildCompareCard('Sets Logged', '$_currentSets', '$_prevSets', Icons.playlist_add_check),
                  _buildCompareCard('Volume Lifted', '${_currentVolume.round()}kg', '${_prevVolume.round()}kg', Icons.line_weight),
                ],
              ),
      ),
    );
  }
}
