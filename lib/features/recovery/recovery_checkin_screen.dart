import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/recovery_repository.dart';
import 'package:kairo/data/models/recovery_checkin.dart';
import 'package:kairo/core/constants/app_colors.dart';

class RecoveryCheckinScreen extends StatefulWidget {
  const RecoveryCheckinScreen({super.key});

  @override
  State<RecoveryCheckinScreen> createState() => _RecoveryCheckinScreenState();
}

class _RecoveryCheckinScreenState extends State<RecoveryCheckinScreen> {
  final _uuid = const Uuid();
  final _notesController = TextEditingController();

  double _sleepHours = 7.0;
  double _sleepQuality = 3.0;
  double _energyLevel = 3.0;
  double _stressLevel = 3.0;
  double _hydrationLevel = 3.0;
  double _sorenessLevel = 3.0;
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final userRepo = UserRepository();
      final recoveryRepo = RecoveryRepository();

      // Determine recommendation enum based on computed RS
      // Let's compute RS inline using PhysiologyEngine logic to choose recommendation
      // RS = (sleepScore * 0.30) + ((1 - fatigueScore) * 0.15) + (hydrationScore * 0.10) + (dietScore * 0.15) + (bodyScore * 0.10) + (perfScore * 0.20)
      // For simplicity, let's write a quick computation
      final sleepScore = (_sleepHours.clamp(4.0, 10.0) - 4.0) / 6.0 * 0.4 + (_sleepQuality / 5.0) * 0.6;
      final fatigueScore = (_sorenessLevel / 5.0 * 0.6) + (_stressLevel / 5.0 * 0.4);
      final rs = (sleepScore * 0.30) + ((1.0 - fatigueScore).clamp(0.0, 1.0) * 0.15) + (_hydrationLevel / 5.0 * 0.10) + (0.7 * 0.15) + (0.8 * 0.10) + (0.7 * 0.20);

      RecoveryRecommendation rec = RecoveryRecommendation.normalTraining;
      String recText = "Moderate readiness. Stick to the plan.";
      
      if (rs > 0.75) {
        rec = RecoveryRecommendation.normalTraining;
        recText = "You're primed. Train hard today.";
      } else if (rs >= 0.50) {
        rec = RecoveryRecommendation.normalTraining;
        recText = "Moderate readiness. Stick to the plan.";
      } else if (rs >= 0.25) {
        rec = RecoveryRecommendation.reducedVolume;
        recText = "Reduce volume today. Consider a deload set.";
      } else {
        rec = RecoveryRecommendation.recoveryDay;
        recText = "Recovery day. Walk, stretch, eat well.";
      }

      final checkin = RecoveryCheckin(
        id: _uuid.v4(),
        userId: userId,
        checkinAt: DateTime.now(),
        sleepHours: _sleepHours,
        sleepQuality: _sleepQuality,
        energyLevel: _energyLevel,
        stressLevel: _stressLevel,
        hydrationLevel: _hydrationLevel,
        sorenessLevel: _sorenessLevel,
        notes: _notesController.text.trim(),
        recommendation: rec,
      );

      await recoveryRepo.saveCheckin(checkin);

      // Recompute snapshot
      final profile = await userRepo.getProfile(userId);
      final measurements = await userRepo.getLatestMeasurements(userId);
      final lifestyle = await userRepo.getLatestLifestyle(userId);
      final performance = await userRepo.getLatestPerformance(userId);

      if (profile != null && measurements != null && lifestyle != null && performance != null) {
        final snap = PhysiologyEngine().computeSnapshot(
          profile: profile,
          measurements: measurements,
          lifestyle: lifestyle,
          performance: performance,
          latestCheckin: checkin,
        );
        await userRepo.saveSnapshot(snap);
      }

      // Notify updates
      PhysiologyEngine().triggerUpdate();

      if (!mounted) return;

      // Show recommendation dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Readiness Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recovery Score: ${(rs * 100).round()}/100', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Text(
                recText,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // dismiss dialog
                context.pop(); // go back
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submission failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildSliderCard(String label, double val, double min, double max, int divisions, String displayVal, ValueChanged<double> onChanged) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(displayVal, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 10),
            Slider(
              value: val,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
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
        title: const Text('Daily Check-in'),
      ),
      body: SafeArea(
        child: _saving
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  const Text(
                    'Daily Readiness Check-in',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Track your physiological status to optimize training load.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  _buildSliderCard(
                    'Sleep Duration',
                    _sleepHours,
                    4.0,
                    10.0,
                    12,
                    '${_sleepHours.toStringAsFixed(1)} hrs',
                    (val) => setState(() => _sleepHours = val),
                  ),
                  _buildSliderCard(
                    'Sleep Quality',
                    _sleepQuality,
                    1.0,
                    5.0,
                    4,
                    '${_sleepQuality.round()}/5',
                    (val) => setState(() => _sleepQuality = val),
                  ),
                  _buildSliderCard(
                    'Energy Level',
                    _energyLevel,
                    1.0,
                    5.0,
                    4,
                    '${_energyLevel.round()}/5',
                    (val) => setState(() => _energyLevel = val),
                  ),
                  _buildSliderCard(
                    'Stress Level',
                    _stressLevel,
                    1.0,
                    5.0,
                    4,
                    '${_stressLevel.round()}/5',
                    (val) => setState(() => _stressLevel = val),
                  ),
                  _buildSliderCard(
                    'Hydration Status',
                    _hydrationLevel,
                    1.0,
                    5.0,
                    4,
                    '${_hydrationLevel.round()}/5',
                    (val) => setState(() => _hydrationLevel = val),
                  ),
                  _buildSliderCard(
                    'Muscle Soreness',
                    _sorenessLevel,
                    1.0,
                    5.0,
                    4,
                    '${_sorenessLevel.round()}/5',
                    (val) => setState(() => _sorenessLevel = val),
                  ),

                  // Optional notes input
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Describe how you feel...',
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('SUBMIT CHECK-IN'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
